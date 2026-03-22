local _, namespace = ...

local RewardsGroup = {
	DELVE = "Delves",
}

namespace.DB.rewardCandidiates["Delve"] = {
	{
		id = "delve-map",
		key = "|A:delves-bountiful:16:16|aMap",
		description = "Weekly Trovehunter's Bounty Map",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 86371, items = { 252415 }, loot = { 581922, name = { 252415 } } }, -- Hidden Trove
		},
		items = { { item = 252415, amount = 1 } },
	},
	{
		id = "delve-stash",
		key = "|A:delves-bountiful:16:16|aStash",
		description = "Weekly Gilded Stash in Tier 11 Delves",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 4 },
		},
		items = {
			{
				name = "3 |cffffffff[Gilded Stash]|r",
				texture = 5872049, -- Gilded Stash
			},
		},
	},
}
