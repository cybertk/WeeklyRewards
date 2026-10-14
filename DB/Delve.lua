local _, namespace = ...

local RewardsGroup = {
	DELVE = DELVES_LABEL,
}

namespace.DB.rewardCandidiates["Delve"] = {
	{
		id = "delve-map",
		key = "|A:delves-bountiful:16:16|aMap",
		description = "{item:265714:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 86371, items = { 265714 }, loot = { 581922, name = { 235559 } } } }, -- Hidden Trove
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
		entries = { { quest = 0, currency = 3310, loot = { 584514, 584515, 584518, name = { 228942, 257387, 257387 } } } }, -- Bountiful Coffer, Bountiful Heavy Trunk
	},
	{
		id = "delve-abundance",
		key = "|A:delves-bountiful:16:16|aAbundance",
		description = "{faction:2796:-3:1}|n|n"
			.. "The first time you find Dundun within delve each week, "
			.. "it will be made {spell:1297887}, and you will receive below extra chests at the end:|n"
			.. "- 1 |cnEPIC_PURPLE_COLOR:Bountiful Coffer|r|n"
			.. "- 2 |cnRARE_BLUE_COLOR:Abundantly Bountiful Heavy Trunk|r",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 97064, name = "{spell:1297887}", loot = { 658087, 658088 } } }, -- Abundantly Bountiful Heavy Trunk
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
		entries = { { quest = 97628, items = { 276547, 276548 }, loot = { 275726, 279574 } } },
	},
	{
		id = "delve-hero",
		key = "|A:delves-bountiful:16:16|aHero",
		description = "{faction:2796:-9:1}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 93935, name = "{faction:2796:9:1:0}" } },
	},
	{
		id = "delve-fragment-m",
		key = "|A:overworld-active-64x64:16:16|aFragment",
		description = "{item:285065} earned from the 6-week {storyline:6385}.|n|n{item:285065:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		pick = 6,
		entries = {
			{ quest = 98951, name = "{quest:98951}" },
			{ quest = 98963, name = "{quest:98963}" },
			{ quest = 98962, name = ("{quest:98962::(%s Week 12)}"):format(UNLOCKS_AT_LABEL) },
			{ quest = 98961, name = ("{quest:98961::(%s Week 13)}"):format(UNLOCKS_AT_LABEL) },
			{ quest = 98960, name = ("{quest:98960::(%s Week 14)}"):format(UNLOCKS_AT_LABEL) },
			{ quest = 98959, name = ("{quest:98959::(%s Week 15)}"):format(UNLOCKS_AT_LABEL) },
		},
	},
}
