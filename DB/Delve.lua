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
	{
		id = "delve-abundance",
		key = "|A:delves-bountiful:16:16|aAbundance",
		description = "{faction:2796:-3:1}|n|n"
			.. "The first time you find Dundun within delve each week, "
			.. "it will be made {spell:1297887}, and you will receive below extra chests at the end:|n"
			.. "- 1 |cnEPIC_PURPLE_COLOR:Bountiful Coffer|r|n"
			.. "- 3 |cnRARE_BLUE_COLOR:Abundantly Bountiful Heavy Trunk",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 97064, text = "{spell:1297887}" } },
	},
}
