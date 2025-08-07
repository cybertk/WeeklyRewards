local _, namespace = ...

local Util = namespace.Util

local CyrceCircletProgress = namespace.RewardProgress:New()
namespace.CyrceCircletProgress = CyrceCircletProgress

function CyrceCircletProgress:_UpdateRecords()
	-- Reset progress
	self.records = {}
	self.position = 0
	self.total = 0

	local reward = self.pendingObjectives[1]

	if not C_QuestLog.IsQuestFlaggedCompleted(reward.unlockQuest) then
		table.insert(self.records, {
			text = format("%s %s", CreateAtlasMarkup("quest-important-available", 13, 13), QuestUtils_GetQuestName(reward.unlockQuest)),
			fulfilled = 0,
			required = 1,
		})
		self.total = 1
		return
	end

	local item = Util:FindEquippedItem(reward.items)
	local iLvl = item and item:GetCurrentItemLevel() or 0

	self.position = tIndexOf(reward.itemLevelRange, iLvl) or 0
	self.total = #reward.itemLevelRange

	table.insert(self.records, {
		text = self:GetCachedItemName(item and item:GetItemID() or reward.items[1]) .. (iLvl > 0 and format(" (%d)", iLvl) or ""),
		fulfilled = iLvl > 0 and 1 or 0,
		required = 1,
	})

	if self.position == self.total then
		self.fulfilledObjectives = self.pendingObjectives
		self.pendingObjectives = {}
		return
	end

	local numInBag = C_Item.GetItemCount(reward.upgradeItem, true)
	if numInBag > 0 then
		table.insert(self.records, {
			text = format("%s x%d", self:GetCachedItemName(reward.upgradeItem), numInBag),
			fulfilled = numInBag,
			required = numInBag,
		})
		self.position = self.position + numInBag
	end

	if self.position < self.total then
		table.insert(self.records, {
			text = format("%s x%d", self:GetCachedItemName(reward.upgradeItem), self.total - self.position),
			fulfilled = 0,
			required = self.total - self.position,
		})
	end
end
