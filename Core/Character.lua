local _, namespace = ...

local Character = {
	enabled = true,
	progress = {},
	lastUpdate = 0,
	GUID = "",
	name = "",
	realmName = "",
	level = 0,
	factionName = "",
	class = "",
}
namespace.Character = Character

local Util = namespace.Util
local ProgressFactory = namespace.ProgressFactory

local WAPI = {
	GetServerTime = GetServerTime,
}

local Cache = {
	questToProgress = {}, -- k,v
	lootToProgress = {}, -- k,v
}

function Character:New(o)
	o = o or {}
	self.__index = self
	setmetatable(o, self)

	if next(o) == nil then
		Character._Init(o)
	end

	for k, v in pairs(o.progress or {}) do
		Character._AddProgress(o, ProgressFactory:Create(v.type, v), k)
	end

	-- Character:_UpdateLootCache(o)

	return o
end

function Character:_Init()
	local _localizedClassName, classFile, _classID = UnitClass("player")
	local _englishFactionName, localizedFactionName = UnitFactionGroup("player")

	self.name = UnitName("player")
	self.GUID = UnitGUID("player")
	self.realmName = GetRealmName()
	self.level = UnitLevel("player")
	self.factionName = localizedFactionName
	self.class = classFile
	self.progress = {}
	self.lastUpdate = WAPI.GetServerTime()

	Util:Debug("Initialized new character:", self.name)
end

function Character:_AddProgress(progress, name)
	self.progress[name] = progress

	-- Cache only current character
	if UnitGUID("player") == self.GUID then
		progress:ForEachRewardQuest(function(quest)
			Cache.questToProgress[quest] = progress
		end)

		for _, item in ipairs(progress.rewards or {}) do
			if item.item and item.guid then
				Cache.lootToProgress[item.guid] = progress
			end
		end
	end
end

function Character:UpdateProgress(quest)
	local changeSet = {}
	local count = 0

	if self.progress == nil then
		return
	end

	self.lastUpdate = WAPI.GetServerTime()

	local progressList = quest and { Cache.questToProgress[quest] } or self.progress

	for name, progress in pairs(progressList) do
		local updated = progress:Update(quest)

		if updated then
			table.insert(changeSet, 1, name)
			Util:Debug("progress updated: " .. name)
		end
		count = count + 1
	end
end

function Character:ResetProgress(reward)
	local progress = self.progress[reward.id]

	if progress == nil then
		return
	end

	if reward.rollover and progress:hasStarted() then
		-- skip reset if: rollover and started.  OR progress.started > rewarwd.started
		Util:Debug(format("progress of [%s] has been rollovered for character: %s ", reward.name, self.name))
		return
	end

	-- Reset
	self.progress[reward.id] = nil

	return progress
end

function Character:ReceiveReward(quest, quantity, itemLink, currencyId)
	local progress = Cache.questToProgress[quest]

	Util:Debug("Character:ReceiveReward", quest, quantity, itemLink, currencyId, progress)
	if progress == nil then
		return
	end

	local item
	if itemLink then
		item, _ = C_Item.GetItemInfoInstant(itemLink)
	end

	progress:AddReward(currencyId, item, quantity)
end

function Character:UpdateRewardsGUID(quest)
	local remainingItems = {} -- k,v
	local count = 0

	local progressList = quest and { Cache.questToProgress[quest] } or self.progress

	for _, progress in pairs(progressList) do
		for _, rewardItem in ipairs(progress.rewards or {}) do
			if rewardItem.item and rewardItem.guid == nil then
				remainingItems[rewardItem.item] = { rewardItem, progress }
				count = count + 1
			end
		end
	end

	Util:Debug("UpdateRewardsGUID:", quest, count)

	if count == 0 then
		return true
	end

	local includeOldItems = quest == nil
	local found = false
	for containerIndex = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		for slotIndex = 1, C_Container.GetContainerNumSlots(containerIndex) do
			local info = C_Container.GetContainerItemInfo(containerIndex, slotIndex)

			if info and remainingItems[info.itemID] then
				local item, progress = unpack(remainingItems[info.itemID])

				if info.stackCount > 1 then
					item.guid = false
				elseif includeOldItems == true or C_NewItems.IsNewItem(containerIndex, slotIndex) then
					item.guid = Item:CreateFromBagAndSlot(containerIndex, slotIndex):GetItemGUID()
					Cache.lootToProgress[item.guid] = progress
				end

				if item.guid or item.guid == false then
					found = true
					Util:Debug("guid updated for ", info.hyperlink, info.stackCount, containerIndex, slotIndex, item.guid)
				end
			end
		end
	end

	return found
end

function Character:ReceiveDrop(guid, quantity, itemId, currencyId)
	local progress = Cache.lootToProgress[guid]

	if progress == nil then
		return
	end

	Util:Debug("Received drop: ", guid, quantity, itemId, currencyId, progress)

	progress:AddReward(currencyId, itemId, quantity, true)
end

-- Reset progress, replace old with new one
function Character:Scan(activeRewards)
	-- Reset level and etc
	self.level = UnitLevel("player")

	local rewardsToScan = Util:Filter(activeRewards, function(reward)
		if self.level < reward.minimumLevel then
			return false
		end

		if self.progress[reward.id] and next(self.progress[reward.id]) ~= nil then
			return false
		end

		return true
	end)

	Util:Debug("Rewards to scan: " .. #rewardsToScan)

	for _, reward in ipairs(rewardsToScan) do
		local progress = self.progress[reward.id] or ProgressFactory:Create(reward.objectives[1].progressType)

		if progress:Init(reward) then
			self:_AddProgress(progress, reward.id)
			Util:Debug("progress initalized: " .. reward.id)
		end
	end
end

function Character:ForEachProgress(callback, completedOnly)
	for _, progress in pairs(self.progress) do
		if completedOnly ~= true or progress:hasClaimed() then
			callback(progress)
		end
	end
end
