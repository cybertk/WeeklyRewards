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
	questToReward = {},
	expansions = {}, -- current expansion candidates by group: table<ExpansionLevel, table<GroupID: list<Candidate>>>
	rewards = {}, -- active rewards: table<CandidateID: Reward>
	candidatesSelected = {}, -- selected candidates: table<CandidateID: Candidate>
	selected = {}, -- selected candidates: list<CandidateID>
	instance = nil,
}

local function AddRewardToCache(reward)
	Cache.rewards[reward:GetCandidateID()] = true

	for _, objective in ipairs(reward.objectives) do
		Cache.questToReward[objective:GetQuest()] = reward
	end
end

local function RemoveRewardFromCache(reward)
	Cache.rewards[reward:GetCandidateID()] = nil
	Cache.questToReward[reward.id] = nil
end

local function ResetCache(activeRewards)
	Cache.rewards = {}
	Cache.questToReward = {}

	for _, reward in ipairs(activeRewards) do
		AddRewardToCache(reward)
	end

	Cache.instance = activeRewards
end

function ActiveRewards.SetCandidates(candidates)
	Reward.SetCandidates(candidates)

	for _, candidate in ipairs(candidates) do
		local group = candidate.group or ""
		local expansion = candidate.expansion or LE_EXPANSION_LEVEL_CURRENT

		Cache.expansions[expansion] = Cache.expansions[expansion] or {}
		Cache.expansions[expansion][group] = Cache.expansions[expansion][group] or {}
		table.insert(Cache.expansions[expansion][group], candidate)
	end
end

function ActiveRewards:SetSelectedCandidates(list)
	Cache.selected = list

	wipe(Cache.candidatesSelected)
	for _, candidateID in ipairs(list) do
		Cache.candidatesSelected[candidateID] = true
	end
end

function ActiveRewards:New(o)
	if Cache.instance ~= nil then
		Util:Debug("ActiveRewards RESET")
	end

	o = o or {}
	self.__index = self
	setmetatable(o, self)

	for i = #o, 1, -1 do
		local reward = o[i]

		if Reward.IsValid(reward) then
			o[i] = Reward:New(reward)
		else
			Util:Debug("Invalid reward, cannot add to cache", reward.id)
			print("Invalid reward, cannot add to cache", reward.id, Reward.CandidatesById[reward.id])
			table.remove(o, i)
		end
	end

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

		return Cache.rewards[candidate.id] == nil
	end)
end

function ActiveRewards:GetAllCandidates()
	local current, inactive = {}, {}

	for groupID, candiates in pairs(Cache.expansions[LE_EXPANSION_LEVEL_CURRENT]) do
		local isActive = false

		for _, candidate in ipairs(candiates) do
			isActive = isActive or Cache.rewards[candidate.id]
		end

		local groups = isActive and current or inactive
		groups[groupID] = candiates
	end

	return current, inactive
end

function ActiveRewards:GetAllCandidatesByExpansion(expansionLevel)
	return Cache.expansions[expansionLevel]
end

function ActiveRewards:GetAllGroups()
	local current, inactive, legacy = {}, {}, {}

	-- local function GetOrAdd(d, k)
	-- 	local k = k or ""
	-- 	d[k] = d[k] or {}
	-- 	return d[k]
	-- end

	-- local isActive = {}
	-- for _, candidate in ipairs(Reward:EnumerateAllCandidates()) do
	-- 	if candidate.expansion then
	-- 		table.insert(GetOrAdd(GetOrAdd(legacy, candidate.expansion), candidate.group), candidate)
	-- 	else
	-- 		table.insert(GetOrAdd(GetOrAdd(current, candidate.group), nil), candidate)

	-- 		if candidate.group then
	-- 			isActive[candidate.group] = isActive[candidate.group] or self:IsActive(candidate.id)
	-- 		end
	-- 	end
	-- end

	-- for group, d in pairs(current) do
	-- 	if group ~= "" and not isActive[group] then
	-- 		inactive[group] = d
	-- 		current[group] = nil
	-- 	end
	-- end

	return current, inactive, legacy
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
	local candidatesToScan = self:_FindCandidatesToScan(candidates)

	Util:Debug("Scanning candidates: ", #candidatesToScan)

	if #candidatesToScan == 0 then
		return
	end

	for _, candidate in ipairs(candidatesToScan) do
		local reward = Reward:New({
			id = candidate.id,
			name = candidate.key,
			description = candidate.description,
			group = candidate.group,
			expansion = candidate.expansion,
			minimumLevel = candidate.minimumLevel,
			maximumLevel = candidate.maximumLevel,
			rollover = candidate.rollover,
			items = candidate.items,
		})
		local pick = candidate.pick or 1

		reward:DetermineObjectives(candidate.entries, pick, candidate.rollover == true)
		reward:DetermineResetTime(candidate.timeLeft and candidate.timeLeft() or nil)
		reward:DetermineState(pick)
		reward:UpdateDescription()

		if candidate.rollover and #candidate.entries > 1 and #reward.objectives > 0 then
			reward.id = reward.id .. ":" .. reward.objectives[1].quest
		end

		self:_Add(reward)
		if OnRewardAddedCallback then
			OnRewardAddedCallback(reward)
		end
	end

	self:Sort()
end

function ActiveRewards:ToggleExclusion(candidateID)
	if Cache.candidatesSelected[candidateID] then
		tDeleteItem(Cache.selected, candidateID)
	else
		table.insert(Cache.selected, candidateID)
	end

	Cache.candidatesSelected[candidateID] = not Cache.candidatesSelected[candidateID]
end

function ActiveRewards:IsCandidateExcluded(candidateID)
	return Cache.candidatesSelected[candidateID] ~= true
end

function ActiveRewards:ToggleExclusionByGroup(group)
	local exclude = not self:IsGroupExcluded(group)

	for _, candidate in ipairs(Cache.expansions[LE_EXPANSION_LEVEL_CURRENT][group]) do
		if exclude ~= not Cache.candidatesSelected[candidate.id] then
			self:ToggleExclusion(candidate.id)
		end
	end
end

function ActiveRewards:IsGroupExcluded(group)
	for _, candidate in ipairs(Cache.expansions[LE_EXPANSION_LEVEL_CURRENT][group]) do
		if Cache.candidatesSelected[candidate.id] then
			return false
		end
	end

	return true
end

function ActiveRewards:IsActive(rewardID)
	return Cache.rewards[rewardID] == true
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
