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
			local record = {
				text = format("%d / %d ", activity.progress, activity.threshold)
					.. format(#template > 0 and template or activity.raidString, activity.threshold),
				fulfilled = activity.progress,
				required = activity.threshold,
			}

			if activity.progress == activity.threshold then
				position = position + 1
			end

			table.insert(self.records, record)
		end
	end

	self.position = position
	self.total = #self.records
end
