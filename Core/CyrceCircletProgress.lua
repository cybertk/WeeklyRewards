local _, namespace = ...

local Util = namespace.Util

local CyrceCircletProgress = namespace.RewardProgress:New()
namespace.CyrceCircletProgress = CyrceCircletProgress

local RING_ITEM_ID = 228411
local UPGRADE_ITEM_ID = 229365

local function GetRingRank(iLvl)
	local rank = 0
	if iLvl == 642 then
		rank = 1
	elseif iLvl == 645 then
		rank = 2
	elseif iLvl == 649 then
		rank = 3
	elseif iLvl == 652 then
		rank = 4
	elseif iLvl == 655 then
		rank = 5
	elseif iLvl == 658 then
		rank = 6
	end

	return rank, 6
end

local function GetRingItemLevel()
	local item
	for _, slot in ipairs({ INVSLOT_FINGER1, INVSLOT_FINGER2 }) do
		if RING_ITEM_ID == GetInventoryItemID("player", slot) then
			item = Item:CreateFromEquipmentSlot(slot)
		end
	end

	if not item then
		Util:Debug("Cannot find the ring")
		return 0
	end

	return item:GetCurrentItemLevel()
end

function CyrceCircletProgress:_UpdateRecords()
	-- Reset progress
	self.records = {}
	self.position = 0
	self.total = 0

	local unlockQuest = self.pendingObjectives[1].unlockQuest

	if not C_QuestLog.IsQuestFlaggedCompleted(unlockQuest) then
		table.insert(self.records, {
			text = format("%s %s", CreateAtlasMarkup("quest-important-available", 13, 13), QuestUtils_GetQuestName(unlockQuest)),
			fulfilled = 0,
			required = 1,
		})
		self.total = 1
		return
	end

	local iLvl = GetRingItemLevel()
	self.position, self.total = GetRingRank(iLvl)
	table.insert(self.records, {
		text = self:GetCachedItemName(RING_ITEM_ID) .. (iLvl > 0 and format(" (%d)", iLvl) or ""),
		fulfilled = iLvl > 0 and 1 or 0,
		required = 1,
	})

	if self.position == self.total then
		self.fulfilledObjectives = self.pendingObjectives
		self.pendingObjectives = {}
		return
	end

	local numInBag = C_Item.GetItemCount(UPGRADE_ITEM_ID, true)
	if numInBag > 0 then
		table.insert(self.records, {
			text = format("%s x%d", self:GetCachedItemName(UPGRADE_ITEM_ID), numInBag),
			fulfilled = numInBag,
			required = numInBag,
		})
		self.position = self.position + numInBag
	end

	table.insert(self.records, {
		text = format("%s x%d", self:GetCachedItemName(UPGRADE_ITEM_ID), self.total - self.position),
		fulfilled = 0,
		required = self.total - self.position,
	})
end
