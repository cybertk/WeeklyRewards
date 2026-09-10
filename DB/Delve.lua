local _, namespace = ...

local RewardsGroup = {
	DELVE = "Delves",
}

namespace.DB.rewardCandidiates["Delve"] = {
	{
		id = "delve-map",
		key = "|A:delves-bountiful:16:16|aMap",
		description = "{item:265714:0}",
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
		description = "{faction:2796:-4:1}",
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
	{
		id = "delve-shards",
		key = "|A:delves-bountiful:16:16|aShards",
		description = "{currency:3310:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, currency = 3310, loot = { 584514, name = { 252415 } } },
		},
	},
}
