local _, namespace = ...

local Util = namespace.Util

local CyrceCircletProgress = namespace.RewardProgress:New()
namespace.CyrceCircletProgress = CyrceCircletProgress

-- See https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_WeeklyRewards/Blizzard_WeeklyRewards.lua
function CyrceCircletProgress:_UpdateRecords()
	-- Reset progress
	self.records = {}
	self.position = 0
	self.total = 0

	if not C_QuestLog.IsQuestFlaggedCompleted(84724) then
		table.insert(self.records, {
			text = "abcd",
			fulfilled = 0,
			required = 1,
		})
		self.total = 1
		return
	end

	local item

	for _, slot in ipairs({ INVSLOT_FINGER1, INVSLOT_FINGER2 }) do
		if 228411 == GetInventoryItemID("player", slot) then
			item = Item:CreateFromEquipmentSlot(slot)
		end
	end

	if not item then
		return
	end

	table.insert(self.records, {
		text = "1234",
		fulfilled = 0,
		required = 1,
	})

	self.position = item:GetCurrentItemLevel()

	-- 	C_Item.GetItemCount(228411)

	-- 	local item = GetInventoryItemLink("player", INVSLOT_FINGER2)
	-- 	GetInventoryItemID("player", INVSLOT_FINGER2)
	-- local item = ItemLocation:CreateFromEquipmentSlot(INVSLOT_FINGER2)

	-- print(C_Item.GetItemGUID(ItemLocation:CreateFromEquipmentSlot(INVSLOT_FINGER2)))

	-- C_Item.GetItemInfo(ItemLocation:CreateFromEquipmentSlot(INVSLOT_FINGER2))

	-- /dump Item:CreateFromEquipmentSlot(INVSLOT_FINGER2):GetCurrentItemLevel()
end
