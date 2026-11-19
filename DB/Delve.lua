local _, namespace = ...

local RewardsGroup = {
	DELVE = DELVES_LABEL,
}

namespace.DB.rewardCandidiates["Delve"] = {
	{
		id = "delve-map",
		key = "Map",
		texture = 1064187,
		description = "{item:265714:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 86371, items = { 265714 }, loot = { 581922, name = { 235559 } } } }, -- Hidden Trove
	},
	{
		id = "delve-stash",
		key = "Stash",
		texture = 5872049,
		description = "{faction:2796:-4:1}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, progressType = 4, name = "|T5872049:12|t 4 {spell:1216211}", loot = { 584507 } } },
	},
	{
		id = "delve-shards",
		key = "Shards",
		texture = 133016,
		description = "{currency:3310:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, currency = 3310, loot = { 584514, 584515, 584518, name = { 228942, 257387, 257387 } } } }, -- Bountiful Coffer, Bountiful Heavy Trunk
	},
	{
		id = "delve-abundance", -- Weekly abundance made by finding Dundun within delve
		key = "Abundance",
		texture = 647701,
		description = "{faction:2796:-3:1}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 97064, name = "{spell:1297887}", loot = { 658087, 658088 } } }, -- Abundantly Bountiful Heavy Trunk
	},
	{
		id = "delve-crystals",
		key = "Crystals",
		texture = 5931199,
		description = "{currency:3356:0}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, currency = 3356 } },
	},
	{
		id = "delve-souls",
		key = "Souls",
		texture = 136214,
		description = "{item:276547} {item:276548}|n|n{faction:2808:-4:1}|n|n{faction:2808:9:1}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 97628, items = { 276547, 276548 } } },
	},
	{
		id = "delve-hero",
		key = "Hero",
		atlas = "delves-bountiful",
		description = "{faction:2796:-9:1}",
		group = RewardsGroup.DELVE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 93935, name = "{faction:2796:9:1:0}" } },
	},
	{
		id = "delve-fragment-m", -- Mythical Soul Fragments
		key = "Fragment",
		atlas = "overworld-active-64x64",
		description = "{item:285065}",
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
