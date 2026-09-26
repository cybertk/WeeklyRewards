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
		entries = { { quest = 86371, items = { 265714 }, loot = { 581922 } } }, -- Hidden Trove
	},
	{
		id = "delve-stash",
		key = "|A:delves-bountiful:16:16|aStash",
		description = "{faction:2796:-4:1}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, progressType = 4, name = "|T5872049:12|t 4 {spell:1216211}", loot = { 584507 } } },
	},
	{
		id = "delve-shards",
		key = "|A:delves-bountiful:16:16|aShards",
		description = "{currency:3310:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, currency = 3310, loot = { 584514, name = { 252415 } } } },
	},
	{
		id = "delve-abundance",
		key = "|A:delves-bountiful:16:16|aAbundance",
		description = "{faction:2796:-3:1}|n|n"
			.. "The first time you find Dundun within delve each week, "
			.. "it will be made {spell:1297887}, and you will receive below extra chests at the end:|n"
			.. "- 1 |cnEPIC_PURPLE_COLOR:Bountiful Coffer|r|n"
			.. "- 1 |cnRARE_BLUE_COLOR:Bountiful Heavy Trunk|r|n"
			.. "- 2 |cnRARE_BLUE_COLOR:Abundantly Bountiful Heavy Trunk|r",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 97064, name = "{spell:1297887}", loot = { 584515, 658087, 658088 } } }, -- Bountiful Heavy Trunk, Abundantly Bountiful Heavy Trunk
	},
	{
		id = "delve-crystals",
		key = "|A:delves-bountiful:16:16|aCrystals",
		description = "{currency:3356:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, currency = 3356 } },
	},
	{
		id = "delve-souls",
		key = "|A:delves-bountiful:16:16|aSouls",
		description = "{item:276547} {item:276548}|n|n{faction:2808:-4:1}|n|n{faction:2808:9:1}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 97628, items = { 276547, 276548 } } },
	},
}
