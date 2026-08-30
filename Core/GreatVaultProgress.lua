local _, namespace = ...

local Util = namespace.Util

local GreatVaultProgress = namespace.RewardProgress:New()
namespace.GreatVaultProgress = GreatVaultProgress

local function GetActivityItemLevel(activity)
	local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id)
	if not itemLink or itemLink == "" then
		return
	end

	local itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
	if itemLevel then
		return itemLevel
	end
end

local function GetRecordStatus(activity)
	local itemLevel = GetActivityItemLevel(activity)

	if itemLevel then
		return format("|cnLIGHTBLUE_FONT_COLOR:%s: |r|cnYELLOW_FONT_COLOR:%d|r", ITEM_LEVEL_ABBR, itemLevel)
	end
end

-- See https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_WeeklyRewards/Blizzard_WeeklyRewards.lua
function GreatVaultProgress:_UpdateRecords()
	local rewardsDescriptionTemplate = {
		[Enum.WeeklyRewardChestThresholdType.Raid] = "", -- WEEKLY_REWARDS_THRESHOLD_RAID is nil
		[Enum.WeeklyRewardChestThresholdType.Activities] = WEEKLY_REWARDS_THRESHOLD_DUNGEONS,
		[Enum.WeeklyRewardChestThresholdType.World] = WEEKLY_REWARDS_THRESHOLD_WORLD,
	}
	local position = 0

	-- Reset progress
	self.records = {}
	self.position = 0
	self.total = 0

	if C_WeeklyRewards.HasAvailableRewards() then
		table.insert(self.records, {
			text = RED_FONT_COLOR:WrapTextInColorCode(WEEKLY_REWARDS_UNCLAIMED_TITLE),
			fulfilled = 0,
			required = 1,
		})
	end

	-- Update records
	for type, template in pairs(rewardsDescriptionTemplate) do
		for _, activity in ipairs(C_WeeklyRewards.GetActivities(type)) do
			local progress = activity.progress

			if progress >= activity.threshold then
				progress = activity.threshold
				position = position + 1
			end

			table.insert(self.records, {
				text = format("%d / %d ", progress, activity.threshold) .. format(#template > 0 and template or activity.raidString, activity.threshold),
				fulfilled = progress,
				required = activity.threshold,
				s = GetRecordStatus(activity),
			})
		end
	end

	self.position = position
	self.total = #self.records
end
