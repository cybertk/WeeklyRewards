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

local Cache = {}

function GreatVaultProgress:_UpdateRecords()
	self.position = 0
	self.total = 9
	self.v = {}

	local i = 1
	for _, type in ipairs(self:EnumerateActivityTypes()) do
		for _, activity in ipairs(C_WeeklyRewards.GetActivities(type)) do
			self.v[i] = GetActivityItemLevel(activity) or -activity.progress
			if self.v[i] > 0 then
				self.position = self.position + 1
			end

			i = i + 1
		end
	end

	self.v[i] = C_WeeklyRewards.HasAvailableRewards() and self.position or -1
end

function GreatVaultProgress:_UpdateTimestamp() end

function GreatVaultProgress:ForEachRecord(callback)
	if not self.v then
		return
	end

	local records = {}
	local expired = self:IsExpired()

	for i, activity in ipairs(self:GetActivities()) do
		local completed = self.v[i] > 0

		if not expired or completed then
			local fulfilled = completed and activity.threshold or -self.v[i]
			local text = ("%d/%d %s"):format(fulfilled, activity.threshold, activity.s)
			local color = -self.v[i] > activity.start and YELLOW_FONT_COLOR or nil

			table.insert(records, {
				text = color and color:WrapTextInColorCode(text) or text,
				fulfilled = fulfilled,
				required = activity.threshold,
				s = completed and ("|cnLIGHTBLUE_FONT_COLOR:%s: |r|cnYELLOW_FONT_COLOR:%d|r"):format(ITEM_LEVEL_ABBR, self.v[i]) or nil,
			})
		end
	end

	if self.v[10] >= 0 then
		local text = "|cnGREEN_FONT_COLOR:" .. WEEKLY_REWARDS_UNCLAIMED_TITLE

		text = text .. (expired and (" (%s)"):format(self:GetNumUnclaimedRewards() or "? " .. UNKNOWN) or "") .. "|r"
		table.insert(records, 1, { text = text .. (#records > 0 and "|n " or ""), s = "", fulfilled = 0, required = 1 })
	end

	if not expired then
		local text = " |n|cnNORMAL_FONT_COLOR:" .. CURRENCY_THIS_WEEK:format(REWARDS) .. (":|r |cnWHITE_FONT_COLOR:%d/%d|r"):format(self.position, 9)
		table.insert(records, { text = text, s = "", fulfilled = 0, required = 1 })
	end

	for _, record in ipairs(records) do
		callback(record, record.fulfilled == record.required)
	end
end

function GreatVaultProgress:GetStatusLabel()
	if not self.v then
		return " "
	elseif self:IsExpired() and self.position > 0 then
		return ("%s |cnGREEN_FONT_COLOR:(%s)|r"):format(CRAFTING_ORDER_NOT_CLAIMED, self.position)
	end

	local atlas = CreateAtlasMarkup("PlayerPartyBlip", 8, 8)
	local fulfilled, intermediate = self:GetNumFulfilled()
	local labels = {}

	for i = 1, #fulfilled do
		local text = (fulfilled[i] == 0 or self:IsExpired()) and atlas or fulfilled[i]
		labels[i] = ("|cn%s_FONT_COLOR:%s|r"):format(intermediate[i] and "YELLOW" or "WHITE", text)
	end

	return ("%s %s %s |cn%s_FONT_COLOR:(%d)|r"):format(labels[1], labels[2], labels[3], self.v[10] >= 0 and "GREEN" or "WHITE", self.position)
end

function GreatVaultProgress:GetNumFulfilled()
	local fulfilled, intermediate = {}, {}
	local activities = self:GetActivities()

	for i = 3, 9, 3 do
		table.insert(fulfilled, self.v[i] > 0 and activities[i].threshold or -self.v[i])

		local inRange = false
		for j = 0, -2, -1 do
			local n = i + j
			if self.v[n] > 0 then
				break
			elseif -self.v[n] > activities[n].start then
				inRange = true
				break
			end
		end

		table.insert(intermediate, inRange)
	end
	return fulfilled, intermediate
end

function GreatVaultProgress:GetNumUnclaimedRewards()
	return self.v[10] > 0 and self.v[10] or nil
end

function GreatVaultProgress:EnumerateActivityTypes()
	return { Enum.WeeklyRewardChestThresholdType.Raid, Enum.WeeklyRewardChestThresholdType.Activities, Enum.WeeklyRewardChestThresholdType.World }
end

function GreatVaultProgress:GetActivities()
	if not Cache.activities then
		local rewardsDescriptionTemplate = {
			[Enum.WeeklyRewardChestThresholdType.Raid] = nil, -- WEEKLY_REWARDS_THRESHOLD_RAID is nil
			[Enum.WeeklyRewardChestThresholdType.Activities] = WEEKLY_REWARDS_THRESHOLD_DUNGEONS,
			[Enum.WeeklyRewardChestThresholdType.World] = WEEKLY_REWARDS_THRESHOLD_WORLD,
		}

		Cache.activities = {}

		for _, type in ipairs(self:EnumerateActivityTypes()) do
			local template = rewardsDescriptionTemplate[type]
			local start = 0
			for i, activity in ipairs(C_WeeklyRewards.GetActivities(type)) do
				local s = (template or activity.raidString):format(activity.threshold)

				table.insert(Cache.activities, { s = s, start = start, threshold = activity.threshold })
				start = activity.threshold
			end
		end
	end

	return Cache.activities
end
