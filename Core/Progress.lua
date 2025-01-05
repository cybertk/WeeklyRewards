local _, namespace = ...

local RewardProgress = {
	name = "",
	state = nil,
	position = 0,
	total = nil,
	records = nil,
	pendingObjectives = nil,
	fulfilledObjectives = nil,
	startedAt = nil,
	claimedAt = nil,
	rewards = nil,
	drops = nil,
}
namespace.RewardProgress = RewardProgress

local Util = namespace.Util

local WAPI_GetQuestTimeLeftSeconds = C_TaskQuest.GetQuestTimeLeftSeconds
local WAPI_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local WAPI_GetItemCount = C_Item.GetItemCount
local WAPI_IsOnQuest = C_QuestLog.IsOnQuest
local WAPI_IsWorldQuest = C_QuestLog.IsWorldQuest
local WAPI_GetQuestObjectives = C_QuestLog.GetQuestObjectives
local WAPI_GetQuestFactionGroup = GetQuestFactionGroup
local WAPI_GetServerTime = GetServerTime
local WAPI_GetQuestName = QuestUtils_GetQuestName

local PROGRESS_STATE = {
	["CLAIMED"] = 0,
	["NOT_STARTED"] = 1,
	["IN_PROGRESS"] = 2,
}

function RewardProgress:New(o)
	o = o or {}
	self.__index = self
	setmetatable(o, self)

	return o
end

-- Determine objectives in two levels:
-- 1. Via ActiveRewards.pick for account level reward
-- 2. Via questPool for per-character quest selection
function RewardProgress:Init(reward)
	if reward == nil then
		return false
	end

	self.name = reward.name
	self.state = PROGRESS_STATE.NOT_STARTED
	self.pendingObjectives = {}
	self.fulfilledObjectives = {}

	local factionNameToEnum = { ["Alliance"] = 1, ["Horde"] = 2 }

	for _, objective in ipairs(reward.objectives) do
		if objective.questPool then
			for i, quest in ipairs(objective.questPool) do
				if
					WAPI_IsOnQuest(quest)
					or (objective.unlockQuest and WAPI_IsQuestFlaggedCompleted(
						type(objective.unlockQuest) == "table" and objective.unlockQuest[i] or objective.unlockQuest
					))
					or (objective.factionMask and factionNameToEnum[UnitFactionGroup("player")] == objective.factionMask[i])
					or factionNameToEnum[UnitFactionGroup("player")] == WAPI_GetQuestFactionGroup(quest)
				then
					table.insert(self.pendingObjectives, { quest = quest, items = { objective.items and objective.items[i] } or nil })
				end
			end
		else
			table.insert(self.pendingObjectives, objective)
		end
	end

	self.total = #self.pendingObjectives

	return self.total > 0
end

function RewardProgress:NeedTrackPosition()
	if #self.pendingObjectives + #self.fulfilledObjectives > 1 then
		return true
	else
		return false
	end
end

function RewardProgress:_AddRecord(record)
	-- Cap to 100 to have a clearer view for complex quest. i.e. Archives: The First Disc
	if record.required == 100 then
		self.position = record.fulfilled
		self.total = 100
	else
		self.position = self.position + record.fulfilled
		self.total = self.total + record.required
	end
	table.insert(self.records, record)
end

function RewardProgress:_UpdateRecords()
	-- Reset progress
	self.position = 0
	self.total = 0
	self.records = {}

	for _, reward in ipairs(self.pendingObjectives) do
		if reward.items then
			local uniqueItems = {}
			for _, item in ipairs(reward.items) do
				uniqueItems[item] = 1 + (uniqueItems[item] or 0)
			end

			for item, count in pairs(uniqueItems) do
				self:_AddRecord({
					text = self:GetCachedItemName(item),
					fulfilled = WAPI_GetItemCount(item),
					required = count,
				})
			end
		end

		local quest = reward.unlockQuest or reward.quest
		for _, objective in ipairs(WAPI_GetQuestObjectives(quest) or {}) do
			if
				objective ~= nil
				and #objective.text > 0
				and (string.match(objective.text, OPTIONAL_QUEST_OBJECTIVE_DESCRIPTION:gsub("%%s", ".+"):gsub("([%(%)])", "%%%1")) == nil)
			then
				local record = { text = gsub(objective.text, ":18:18:0:2%|a", ":0:0:0:2|a") }

				if objective.type == "progressbar" then
					record.fulfilled = GetQuestProgressBarPercent(quest)
					record.required = 100
				elseif objective.numRequired == 1 and objective.numFulfilled == 1 then
					-- Some objectives are marked as fullfileld but is not finsihed. i.e. quest=57637 objective='Ragnaros Defeated'
					record.fulfilled = objective.finished and 1 or 0
					record.required = 1
				else
					record.fulfilled = objective.numFulfilled
					record.required = objective.numRequired
				end

				self:_AddRecord(record)
			end
		end
	end
end

function RewardProgress:_UpdateTimestamp()
	if self.state == PROGRESS_STATE.IN_PROGRESS then
		self.startedAt = WAPI_GetServerTime()
	elseif self.state == PROGRESS_STATE.CLAIMED then
		self.claimedAt = WAPI_GetServerTime()
	end
end

-- Return true indictes there is an update
-- completedQuest - quest has been marked as completed
function RewardProgress:Update(completedQuest)
	if self.pendingObjectives == nil or self.total == nil then
		return
	end

	if self.state == PROGRESS_STATE.CLAIMED then
		return false
	end

	local newState = self.state
	for i, objective in ipairs(self.pendingObjectives) do
		local fulfilled = false
		if objective.quest and (completedQuest == objective.quest or WAPI_IsQuestFlaggedCompleted(objective.quest)) then
			fulfilled = true
		end

		if fulfilled then
			table.insert(self.fulfilledObjectives, objective)
			table.remove(self.pendingObjectives, i)
		end
	end

	if #self.pendingObjectives == 0 then
		newState = PROGRESS_STATE.CLAIMED
	elseif #self.fulfilledObjectives > 0 then
		-- Multi rewards scenerio
		newState = PROGRESS_STATE.IN_PROGRESS
		self.position = #self.fulfilledObjectives
	elseif #self.pendingObjectives == 1 then
		-- Single reward scenerio: Track records for this case
		self:_UpdateRecords()
		if self.position > 0 or WAPI_IsOnQuest(self.pendingObjectives[1].quest) then
			newState = PROGRESS_STATE.IN_PROGRESS
		end

		if self.total == 0 then
			-- No records were found in this case, fallback to track rewards count
			self.total = 1
		end
	end

	if newState ~= self.state then
		Util:Debug(self.name .. " progress: " .. self.state .. " --> " .. newState)
		self.state = newState
		self:_UpdateTimestamp()
		return true
	end

	return false
end

function RewardProgress:_UpdateItemsGUID()
	local itemsByID = {}
	for _, rewardItem in ipairs(self.rewards) do
		if rewardItem.item and rewardItem.guid == nil then
			itemsByID[rewardItem.item] = rewardItem
		end
	end

	for containerIndex = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		for slotIndex = 1, C_Container.GetContainerNumSlots(containerIndex) do
			local info = C_Container.GetContainerItemInfo(containerIndex, slotIndex)

			if info then
				Util:Debug(
					format(
						"<%d,%d>: %s guid=xx item=%d lootable=%s",
						containerIndex,
						slotIndex,
						info.hyperlink,
						info.itemID,
						info.hasLoot == true and "yes" or "no"
					)
				)
			end

			if info and itemsByID[info.itemID] and C_NewItems.IsNewItem(containerIndex, slotIndex) then
				local item = Item:CreateFromBagAndSlot(containerIndex, slotIndex)

				itemsByID[info.itemID].guid = item:GetItemGUID()
				Util:Debug("guid updated for ", info.hyperlink, containerIndex, slotIndex)
			end
		end
	end
end

-- Handle uniqueness
function RewardProgress:AddReward(currency, item, quantity, asDrops)
	Util:Debug("RewardProgress:AddReward", currency, item, quantity, asDrops)

	local items
	if asDrops == true then
		self.drops = self.drops or {}
		items = self.drops
	else
		self.rewards = self.rewards or {}
		items = self.rewards
	end

	for _, rewardItem in ipairs(items) do
		if (currency and rewardItem.currency == currency) or (item and rewardItem.item == item) then
			rewardItem.quantity = rewardItem.quantity + quantity
			return
		end
	end

	-- No exsiting reward found
	if currency then
		table.insert(items, { currency = currency, quantity = quantity })
	elseif item then
		table.insert(items, { item = item, quantity = quantity })
	end
end

function RewardProgress:hasClaimed()
	return self.state == PROGRESS_STATE.CLAIMED
end

function RewardProgress:hasStarted()
	return self.state == PROGRESS_STATE.IN_PROGRESS
end

function RewardProgress:ObjectivesCount()
	return #self.pendingObjectives + #self.fulfilledObjectives
end

function RewardProgress:Quest()
	return #self.pendingObjectives > 0 and self.pendingObjectives[1].quest or self.fulfilledObjectives[1].quest
end

function RewardProgress:ForEachRewardQuest(callback)
	local objectives = {}

	for _, objective in ipairs(self.pendingObjectives) do
		table.insert(objectives, objective)
	end

	for _, objective in ipairs(self.fulfilledObjectives) do
		table.insert(objectives, objective)
	end

	local quests = {}
	for _, objective in ipairs(objectives) do
		if objective.quest then
			table.insert(quests, objective.quest)
			callback(objective.quest)
		end
	end

	return quests
end

function RewardProgress:ForEachObjective(callback)
	for _, objective in ipairs(self.fulfilledObjectives) do
		callback(objective, true)
	end

	for _, objective in ipairs(self.pendingObjectives) do
		callback(objective, false)
	end
end

function RewardProgress:ForEachRecord(callback)
	for _, record in ipairs(self.records or {}) do
		callback(record, record.fulfilled == record.required)
	end
end

function RewardProgress:ForEachRewardItem(callback, showDrops)
	local items = showDrops == true and (self.drops or {}) or (self.rewards or {}) -- self.drops or self.rewards might be nil

	for _, rewardItem in ipairs(items) do
		local item
		if rewardItem.currency then
			local currency = C_CurrencyInfo.GetCurrencyInfo(rewardItem.currency)
			item = {
				id = rewardItem.currency,
				name = currency.name,
				texture = currency.iconFileID,
				quantity = rewardItem.quantity,
				quality = currency.quality,
			}
		elseif rewardItem.item then
			local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subClassID = C_Item.GetItemInfoInstant(rewardItem.item)
			item = {
				id = rewardItem.item,
				name = C_Item.GetItemNameByID(rewardItem.item) or "Loading",
				texture = icon,
				quantity = rewardItem.quantity,
				quality = C_Item.GetItemQualityByID(rewardItem.item) or Enum.ItemQuality.Common, -- It requires server query and might not get instance result
			}
		end
		callback(item)
	end
end

function RewardProgress:GetCachedObjectiveName(objective)
	local name = WAPI_GetQuestName(objective.quest)

	if name ~= nil and #name > 0 then
		return name
	end

	if objective.items and #objective.items > 0 then
		return self:GetCachedItemName(objective.items[1])
	end

	return "Loading"
end

function RewardProgress:GetCachedItemName(item)
	local name, icon, quality = C_Item.GetItemNameByID(item), C_Item.GetItemIconByID(item), C_Item.GetItemQualityByID(item)
	if name and icon and quality then
		return CreateSimpleTextureMarkup(icon, 13, 13) .. ITEM_QUALITY_COLORS[quality].color:WrapTextInColorCode(format(" [%s]", name))
	else
		return "Loading"
	end
end
