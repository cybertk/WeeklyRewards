local _, namespace = ...

local RewardsGroup = {
	MIDSUMMER_EVENT = "Midsummer Fire Festival",
}

namespace.DB.rewardCandidiates["midsummer"] = {
	{
		id = "msf-main",
		key = "MSF:Main",
		group = RewardsGroup.MIDSUMMER_EVENT,
		description = "One-time Quests",
		minimumLevel = 1,
		unlockEvent = 341, -- Midsummer Fire Festival
		timeLeft = "end-of-event",
		pick = 8,
		entries = {
			{ questPool = { 11970, 11971 } }, --The Spinner of Summer Tales
			{ questPool = { 82087, 82105 } }, -- Torch Tossing
			{ questPool = { 11657, 11923 } }, -- Torch Catching
			{ questPool = { 11964, 11966 } }, -- Incense for the Summer Scorchlings
			{ quest = 11886 }, -- Unusual Activity
			{ quest = 11891 }, -- An Innocent Disguise
			{ quest = 12012 }, -- Inform the Elder
			{ quest = 11972 }, -- Shards of Ahune
		},
	},
	{
		id = "msf-daily",
		key = "MSF:Daily",
		group = RewardsGroup.MIDSUMMER_EVENT,
		description = "Daily Quests",
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		unlockEvent = 341,
		pick = 3,
		entries = {
			{ questPool = { 82080, 82109 } }, -- More Torch Tossing
			{ questPool = { 11924, 11925 } }, -- More Torch Catching
			{ questPool = { 11947, 11948, 11952, 11953, 11954 } }, -- Striking Back
		},
	},
	{
		id = "msf-capital",
		key = "MSF:Capital",
		group = RewardsGroup.MIDSUMMER_EVENT,
		description = "Stealing Frame from faction Capitals",
		minimumLevel = 1,
		timeLeft = "end-of-event",
		unlockEvent = 341,
		pick = 4,
		entries = {
			{ questPool = { 9330, 9326 } }, -- Stormwind/Undercity
			{ questPool = { 9331, 9325 } }, -- Ironforge/Thunder Bluff
			{ questPool = { 9332, 9324 } }, -- Darnassus/Orgrimmar
			{ questPool = { 11933, 11935 } }, -- Exodar/Silvermoon
		},
	},
	{
		id = "msf-boss",
		key = "MSF:Boss",
		group = RewardsGroup.MIDSUMMER_EVENT,
		description = "Daily Dungeon Boss: The Frost Lord Ahune",
		minimumLevel = 10,
		unlockEvent = 341,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		entries = {
			{ quest = 286 + 9000000, progressType = 2, dungeon = 286 },
		},
		items = {
			{ item = 117394, amount = 1 },
		},
	},
}
