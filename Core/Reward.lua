local _, namespace = ...

---@enum STATE
local STATE = {
	CONFIRMED = 0,
	ANALYZING = 1,
}

---@class Reward
---@field name string
---@field group string
---@field state STATE
---@field description string
---@field minimumLevel number
local Reward = {
	name = "",
	id = "", -- id is unique, while name is not
	group = nil,
	state = STATE.ANALYZING,
	description = nil,
	objectives = {},
	minimumLevel = "",
	resetTime = nil,
	startTime = nil,
	items = nil,
}
namespace.Reward = Reward

local Util = namespace.Util

local WAPI_GetQuestTimeLeftSeconds = C_TaskQuest.GetQuestTimeLeftSeconds
local WAPI_GetQuestName = QuestUtils_GetQuestName
local WAPI_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local WAPI_GetQuestObjectives = C_QuestLog.GetQuestObjectives
local WAPI_IsOnQuest = C_QuestLog.IsOnQuest
local WAPI_IsWorldQuest = C_QuestLog.IsWorldQuest
local WAPI_GetSecondsUntilDailyReset = C_DateAndTime.GetSecondsUntilDailyReset
local WAPI_GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset
local WAPI_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local WAPI_GetServerTime = GetServerTime
local WAPI_UnitLevel = UnitLevel

function Reward:New(o)
	o = o or {}
	self.__index = self
	setmetatable(o, self)
	return o
end

function Reward:DetermineObjectives(entries, pick)
	if self.state == STATE.CONFIRMED then
		return
	end

	Util:Debug(string.format("Determine: [%s] %d out of %d candidiates", self.name, pick, #entries))

	self.objectives = {}

	-- Scenario: Fixed target
	if pick == #entries then
		for _, entry in ipairs(entries) do
			table.insert(self.objectives, entry)
		end

		return
	end

	-- Scenario: Dynamic targets
	if pick < #entries then
		for i, entry in pairs(entries) do
			local confirmed

			if entry.unlockAura then
				if WAPI_GetPlayerAuraBySpellID(entry.unlockAura) then
					confirmed = true
				end
			elseif entry.unlockQuest then
				if
					WAPI_IsOnQuest(entry.unlockQuest)
					or WAPI_GetQuestTimeLeftSeconds(entry.unlockQuest)
					or (WAPI_IsQuestFlaggedCompleted(entry.unlockQuest) and WAPI_IsOnQuest(entry.quest)) -- i.e. Spider Pact
				then
					confirmed = true
				end
			else
				local quests = entry.questPool and entry.questPool or { entry.quest }

				for _, quest in ipairs(quests) do
					if WAPI_IsOnQuest(quest) or WAPI_GetQuestTimeLeftSeconds(quest) then
						confirmed = true
					end
				end
			end

			Util:DebugQuest(entry.quest)
			Util:DebugQuest(entry.unlockQuest)

			if confirmed then
				Util:Debug("Reward [" .. self.name .. "] confirmed: " .. QuestUtils_GetQuestName(entry.quest))
				table.insert(self.objectives, entry)
				if #self.objectives == pick then
					Util:Debug("Reward [" .. self.name .. "] all confirmed: " .. pick)
					break
				end
			end
		end
	end
end

function Reward:DetermineState(pick)
	self.state = STATE.ANALYZING
	if #self.objectives ~= pick then
		return
	end

	-- Cannot always get valid reset time when just logged in
	if #self.objectives == pick and self.resetTime then
		self.state = STATE.CONFIRMED
	else
		Util:Debug("Cannot determine reset time for " .. self.name, #self.objectives, self.resetTime)
	end
end

function Reward:DetermineResetTime(timeLeft)
	if self.objectives == nil or #self.objectives == 0 then
		return
	end

	if timeLeft == nil then
		-- Cannot always get valid reset time when just logged in
		for _, objective in ipairs(self.objectives) do
			for _, quest in ipairs({ objective.quest, objective.unlockQuest }) do
				timeLeft = WAPI_GetQuestTimeLeftSeconds(quest)
				if timeLeft then
					break
				end
			end
		end
	end

	if timeLeft == nil then
		return
	end

	self.startTime = WAPI_GetServerTime()
	self.resetTime = self.startTime + timeLeft
end

function Reward:UpdateDescription()
	if self.description then
		return
	end

	if self.objectives and #self.objectives > 0 then
		self.description = WAPI_GetQuestName(self.objectives[1].quest)
	end
end

function Reward:HasConfirmed()
	return self.state == STATE.CONFIRMED
end

function Reward:HasQuestPool()
	for _, o in ipairs(self.objectives) do
		if o.questPool then
			return true
		end
	end

	return false
end

local questRewardItemsCache = {}
local function GetCachedQuestRewardItems(quest)
	questRewardItemsCache[quest] = questRewardItemsCache[quest] or {}

	if #questRewardItemsCache[quest] > 0 then
		return questRewardItemsCache[quest]
	end

	if questRewardItemsCache[quest].items == nil then
		local numChoice = GetNumQuestLogChoices(quest)
		-- GetNumQuestLogRewards() may returns 0 if the data is not loaded, no idea of how to know the loaded event
		-- Show only first choice
		local numRewards = numChoice > 0 and 1 or GetNumQuestLogRewards(quest)
		local Getter = numChoice > 0 and GetQuestLogChoiceInfo or GetQuestLogRewardInfo
		local items = {}

		for i = 1, numRewards do
			local itemName, itemTexture, numItems, quality, isUsable, itemID, itemLevel = Getter(i, quest)

			if itemName ~= nil then
				table.insert(items, { id = itemID, name = itemName, texture = itemTexture, amount = numItems, quality = quality })
			end
		end

		if #items == numRewards and #items > 0 then
			questRewardItemsCache[quest].items = items
		end
	end

	if questRewardItemsCache[quest].currencies == nil then
		local numChoice = GetNumQuestLogChoices(quest, true) - GetNumQuestLogChoices(quest)
		local numCurrencies = numChoice > 0 and 1 or #C_QuestLog.GetQuestRewardCurrencies(quest)
		local items = {}

		for i = 1, numCurrencies do
			local currency = C_QuestLog.GetQuestRewardCurrencyInfo(quest, i, numChoice > 0)
			if currency then
				table.insert(items, {
					id = currency.currencyID,
					name = currency.name,
					texture = currency.texture,
					amount = currency.bonusRewardAmount ~= 0 and currency.bonusRewardAmount or currency.baseRewardAmount,
					quality = currency.quality,
				})
			end
		end
		if quest == 85879 then
			Util:Debug("ccccc", numCurrencies, #items)
		end

		if #items == numCurrencies then
			questRewardItemsCache[quest].currencies = items
		end
	end

	do
		local items = {}
		for _, item in ipairs(questRewardItemsCache[quest].items or {}) do
			table.insert(items, item)
		end
		for _, item in ipairs(questRewardItemsCache[quest].currencies or {}) do
			table.insert(items, item)
		end

		if questRewardItemsCache[quest].items and questRewardItemsCache[quest].currencies then
			questRewardItemsCache[quest] = items
		end
		return items
	end
end

function Reward:ForEachItem(callback)
	if self.items then
		local items = {}
		for _, rewardItem in ipairs(self.items) do
			local item = rewardItem

			if rewardItem.currency then
				local currency = C_CurrencyInfo.GetCurrencyInfo(rewardItem.currency)
				item = {
					id = rewardItem.currency,
					name = currency.name,
					texture = currency.iconFileID,
					amount = rewardItem.amount,
					quality = currency.quality,
				}
			elseif rewardItem.item then
				item = {
					id = rewardItem.item,
					name = C_Item.GetItemNameByID(rewardItem.item) or "Loading",
					texture = select(5, C_Item.GetItemInfoInstant(rewardItem.item)),
					quantity = rewardItem.amount,
					quality = C_Item.GetItemQualityByID(rewardItem.item) or Enum.ItemQuality.Common,
				}
			end

			callback(item)
			table.insert(items, item)
		end
		return items
	end

	local uniqueItems = {}
	local items = {}
	for _, objective in ipairs(self.objectives) do
		for _, item in ipairs(GetCachedQuestRewardItems(objective.quest) or {}) do
			if uniqueItems[item.id] then
				uniqueItems[item.id].amount = item.amount + uniqueItems[item.id].amount
			else
				-- copy
				uniqueItems[item.id] = { id = item.id, name = item.name, texture = item.texture, amount = item.amount, quality = item.quality }
			end
		end
	end

	for _, item in pairs(uniqueItems) do
		callback(item)
		table.insert(items, item)
	end

	return items
end
