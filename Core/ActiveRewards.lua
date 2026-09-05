local _, namespace = ...

local ActiveRewards = {}
namespace.ActiveRewards = ActiveRewards

local Reward = namespace.Reward
local Util = namespace.Util

local WAPI_GetQuestTimeLeftSeconds = C_TaskQuest.GetQuestTimeLeftSeconds
local WAPI_GetQuestName = QuestUtils_GetQuestName
local WAPI_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local WAPI_IsOnQuest = C_QuestLog.IsOnQuest
local WAPI_IsWorldQuest = C_QuestLog.IsWorldQuest
local WAPI_GetSecondsUntilDailyReset = C_DateAndTime.GetSecondsUntilDailyReset
local WAPI_GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset
local WAPI_GetWeeklyResetStartTime = C_DateAndTime.GetWeeklyResetStartTime
local WAPI_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local WAPI_GetServerTime = GetServerTime
local WAPI_UnitLevel = UnitLevel

local Cache = {
	rewardsCount = {}, -- Per candidiate ID defined in DB.candidates
	questToReward = {},
	groups = {},
	instance = nil,
}

local function AddRewardToCache(reward)
	do -- Update rewardsCount
		local candidateID = reward:GetCandidateID()
		Cache.rewardsCount[candidateID] = Cache.rewardsCount[candidateID] == nil and 1 or Cache.rewardsCount[candidateID] + 1
	end

	for _, objective in ipairs(reward.objectives) do
		Cache.questToReward[objective:GetQuest()] = reward
	end

	if reward.group then
		Cache.groups[reward.group] = Cache.groups[reward.group] or {}
		Cache.groups[reward.group][reward.id] = reward
	end
end

local function RemoveRewardFromCache(reward)
	do -- Update rewardsCount
		local candidateID = reward:GetCandidateID()
		Cache.rewardsCount[candidateID] = (Cache.rewardsCount[candidateID] or 0) > 1 and Cache.rewardsCount[candidateID] - 1 or nil
	end

	Cache.questToReward[reward.id] = nil

	if reward.group then
		Cache.groups[reward.group][reward.id] = nil
	end
end

local function ResetCache(activeRewards)
	Cache.rewardsCount = {}
	Cache.questToReward = {}
	Cache.groups = {}

	for _, reward in ipairs(activeRewards) do
		AddRewardToCache(reward)
	end

	Cache.instance = activeRewards
end

function ActiveRewards:New(o)
	if Cache.instance ~= nil then
		Util:Debug("ActiveRewards RESET")
	end

	o = o or {}
	self.__index = self
	setmetatable(o, self)

	for i, reward in ipairs(o) do
		o[i] = Reward:New(reward)
	end

	-- Init
	o.excluded = o.excluded or {}

	ResetCache(o)
	return o
end

function ActiveRewards.Get()
	return Cache.instance
end

function ActiveRewards:Sort()
	local field = self.sortBy or "resetTime"

	table.sort(self, function(x, y)
		local xV = x[field] or "0"
		local yV = y[field] or "0"

		return xV .. x.name < yV .. y.name
	end)
end

function ActiveRewards:_Add(reward)
	if reward:HasConfirmed() ~= true then
		-- Only add confirmed reward
		return
	end

	if Cache.questToReward[reward.id] then
		Util:Debug("Reward already added", reward.id)
		return
	end

	table.insert(self, reward)
	AddRewardToCache(reward)
end

function ActiveRewards:_Remove(i)
	local reward = self[i]

	table.remove(self, i)
	RemoveRewardFromCache(reward)
end

function ActiveRewards:_FindCandidatesToScan(candidates)
	local playerLevel = WAPI_UnitLevel("player")
	local activeEvents = Util:GetCalendarActiveEvents()

	return Util:Filter(candidates, function(candidate)
		if candidate.unlockEvent and activeEvents[candidate.unlockEvent] == nil then
			Util:Debug("Event is not active: ", candidate.id)
			return false
		end

		if candidate.timeLeft == "end-of-event" then
			-- Append actual event end time
			candidate.timeLeft = function()
				local eventEndTime = Util:GetTimestampFromCalendarTime(activeEvents[candidate.unlockEvent].endTime)
				local now = Util:GetTimestampFromCalendarTime(C_DateAndTime.GetCurrentCalendarTime())

				return eventEndTime - now
			end
		end

		return Cache.rewardsCount[candidate.id] == nil
	end)
end

function ActiveRewards:GetAllGroups()
	local current, legacy = {}, {}

	local function GetOrAdd(d, k)
		local k = k or ""
		d[k] = d[k] or {}
		return d[k]
	end

	for _, reward in ipairs(self) do
		if reward.expansion then
			table.insert(GetOrAdd(GetOrAdd(legacy, reward.expansion), reward.group), reward)
		else
			table.insert(GetOrAdd(GetOrAdd(current, reward.group), nil), reward)
		end
	end

	return current, legacy
end

function ActiveRewards:Reset(teardown_func, force)
	local now = WAPI_GetServerTime()

	if self.nextResetTime ~= nil and self.nextResetTime > now then
		Util:Debug("Already reset in this hour")
		return
	end

	now = now - 10
	self.nextResetTime = now - now % 3600 + 3600 -- 1 hour buffer

	-- Iterate in reserve order to ensure safe deleting
	for i = #self, 1, -1 do
		local reward = self[i]
		if (force and force[reward.name]) or (reward.resetTime and reward.resetTime < now) then
			Util:Debug("Reset: " .. reward.name)
			self:_Remove(i)
			teardown_func(reward)
		end
	end
end

function ActiveRewards:Update(candidates, OnRewardAddedCallback)
	Reward.SetCandidates(candidates)
	ResetCache(self)

	local candidatesToScan = self:_FindCandidatesToScan(candidates)

	Util:Debug("Scanning candidates: ", #candidatesToScan)

	self:ApplyLegacyExpansionExclusions(candidates)

	if #candidatesToScan == 0 then
		return
	end

	for _, candidate in ipairs(candidatesToScan) do
		local reward = Reward:FromCandidate(candidate)

		self:_Add(reward)
		if OnRewardAddedCallback then
			OnRewardAddedCallback(reward)
		end
	end

	self:Sort()
end

function ActiveRewards:ToggleExclusion(rewardID)
	if self.excluded[rewardID] == true then
		self.excluded[rewardID] = nil
	else
		self.excluded[rewardID] = true
	end
end

function ActiveRewards:IsExcluded(rewardID)
	return self.excluded[rewardID] == true
end

function ActiveRewards:ToggleExclusionByGroup(group)
	local action = not self:IsGroupExcluded(group) and true or nil

	for _, reward in pairs(Cache.groups[group]) do
		self.excluded[reward.id] = action
	end
end

function ActiveRewards:IsGroupExcluded(group)
	for _, reward in pairs(Cache.groups[group]) do
		if not self:IsExcluded(reward.id) then
			return false
		end
	end
	return true
end

function ActiveRewards:ApplyLegacyExpansionExclusions(candidates)
	if #self > 0 then
		return
	end

	for _, candidate in ipairs(candidates) do
		if type(candidate.expansion) == "number" then
			self.excluded[candidate.id] = true
		end
	end
end

function ActiveRewards:ScanJournal()
	local JournalScanner = Addon.JournalScanner
	local resetStartTime = WAPI_GetWeeklyResetStartTime()
	local w = JournalScanner:ForEach(function(suggestion)
		for _, reward in ipairs(self) do
			if reward.objectives[1].unlockJournal == suggestion.iconPath and reward.startTime and reward.startTime < resetStartTime then
				Util:Debug("binggo: " .. reward.name)
				reward.resetTime = resetStartTime
			end
		end
	end)
end
