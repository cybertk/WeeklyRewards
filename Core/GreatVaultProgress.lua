local _, namespace = ...

local Util = namespace.Util

local GreatVaultProgress = namespace.RewardProgress:New()
namespace.GreatVaultProgress = GreatVaultProgress

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
			})
		end
	end

	if C_WeeklyRewards.HasAvailableRewards() then
		table.insert(self.records, {
			text = format("HasAvailableRewards"),
			fulfilled = 0,
			required = 1,
		})
	end

	self.position = position
	self.total = #self.records
end
