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
	nameToReward = {},
	questToReward = {},
	groups = {},
	instance = nil,
}

local function AddRewardToCache(reward)
	do -- Update rewardsCount
		local candidateID = string.gsub(reward.id, "([-%w+]):%d+", "%1")
		Cache.rewardsCount[candidateID] = Cache.rewardsCount[candidateID] == nil and 1 or Cache.rewardsCount[candidateID] + 1
	end

	Cache.nameToReward[reward.name] = reward
	for _, objective in ipairs(reward.objectives) do
		Cache.questToReward[objective.quest] = reward
	end

	if reward.group then
		Cache.groups[reward.group] = Cache.groups[reward.group] or {}
		Cache.groups[reward.group][reward.id] = reward
	end
end

local function RemoveRewardFromCache(reward)
	do -- Update rewardsCount
		local candidateID = string.gsub(reward.id, "([-%w+]):%d+", "%1")
		Cache.rewardsCount[candidateID] = (Cache.rewardsCount[candidateID] or 0) > 1 and Cache.rewardsCount[candidateID] - 1 or nil
	end

	Cache.nameToReward[reward.name] = nil
	Cache.questToReward[reward.id] = nil

	if reward.group then
		Cache.groups[reward.group][reward.id] = nil
	end
end

local function ResetCache(activeRewards)
	Cache.rewardsCount = {}
	Cache.nameToReward = {}
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

function ActiveRewards:_Sort()
	table.sort(self, function(x, y)
		if type(x) ~= "table" or type(y) ~= "table" then
			return true
		end

		-- Sort by, resetTime and name, nil resetTime means max
		if x.resetTime == y.resetTime then
			return x.name < y.name
		elseif x.resetTime and y.resetTime then
			return x.resetTime < y.resetTime
		else
			return x.resetTime ~= nil
		end
	end)
end

function ActiveRewards:_UpdateRewardId(reward) end

function ActiveRewards:_Add(reward)
	if reward:HasConfirmed() ~= true then
		-- Only add confirmed reward
		return
	end

	if Cache.questToReward[reward.id] then
		Util:Debug("Reward already added", reward.id)
		return
	end

	local name = reward.name
	local attempts = 0
	while Cache.nameToReward[name] ~= nil and attempts < 5 do
		name = string.gsub(name, "(%w+:#)(%d+)", function(basename, index)
			return basename .. (index + 1)
		end)
		attempts = attempts + 1
		Util:Debug(format("Updated reward name: %s => %s", reward.name, name))
	end

	reward.name = name

	table.insert(self, reward)
	AddRewardToCache(reward)
end

function ActiveRewards:_Remove(i)
	local reward = self[i]

	table.remove(self, i)
	RemoveRewardFromCache(reward)
end

function ActiveRewards:_FindCandidatesToScan(candidates)
	local candidatesToScan = {}
	local playerLevel = WAPI_UnitLevel("player")

	for _, candidate in ipairs(candidates) do
		if
			playerLevel >= candidate.minimumLevel
			and (Cache.rewardsCount[candidate.id] == nil or (candidate.trackRecords and Cache.rewardsCount[candidate.id] < candidate.pick))
		then
			table.insert(candidatesToScan, candidate)
		end
	end

	return candidatesToScan
end

function ActiveRewards:Reset(teardown_func, force)
	local now = WAPI_GetServerTime()

	-- Iterate in reserve order to ensure safe deleting
	for i = #self, 1, -1 do
		local reward = self[i]
		if force[reward.name] or (reward.resetTime and reward.resetTime < now) then
			Util:Debug("Reset: " .. reward.name)
			self:_Remove(i)
			teardown_func(reward)
		end
	end
end

function ActiveRewards:Update(candidates)
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
			minimumLevel = candidate.minimumLevel,
			rollover = candidate.rollover,
			items = candidate.items,
		})
		local entries = candidate.entries
		local pick = candidate.pick or 1

		if candidate.trackRecords then
			entries = Util:Filter(entries, function(e)
				return Cache.questToReward[e.quest] == nil
			end)
			pick = 1
			reward.name = reward.name .. ":#1"
		end

		reward:DetermineObjectives(entries, pick)
		reward:DetermineResetTime(candidate.timeLeft and candidate.timeLeft() or nil)
		reward:DetermineState(pick)
		reward:UpdateDescription()

		if candidate.trackRecords and #reward.objectives > 0 then
			reward.id = reward.id .. ":" .. reward.objectives[1].quest
		end

		self:_Add(reward)
	end

	self:_Sort()
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
