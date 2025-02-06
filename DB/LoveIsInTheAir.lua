local _, namespace = ...

local RewardsGroup = {
	LOVE_EVENT = "Love is in the Air",
}

namespace.DB.rewardCandidiates["love"] = {
	{
		id = "love-main",
		key = "Love:Main",
		group = RewardsGroup.LOVE_EVENT,
		description = "One-time Mainline Quests",
		minimumLevel = 1,
		unlockEvent = 423, -- Love in the Air
		timeLeft = "end-of-event",
		pick = 6,
		entries = {
			{ quest = 78328, questPool = { 78328, 78980 } }, -- Take a Look Around
			{ quest = 78332, questPool = { 78332, 78982 } }, -- I Smell Trouble
			{ quest = 78337, questPool = { 78337, 78983 } }, -- An Unwelcome Gift
			{ quest = 78729, questPool = { 78729, 78978 } }, -- Raising a Stink
			{ quest = 78369, questPool = { 78369, 78984 } }, -- Crushing the Crown
			{ quest = 78379, questPool = { 78379, 78985 } }, -- The Stench of Revenge
		},
	},
	{
		id = "love-daily",
		key = "Love:Daily",
		group = RewardsGroup.LOVE_EVENT,
		description = "Daily Quests",
		minimumLevel = 10,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		unlockEvent = 423,
		pick = 2,
		entries = {
			-- Gateway
			{ quest = 78565, questPool = { 78565, 78986 } }, -- Gateway to Scenic Grizzly Hills
			{ quest = 78591, questPool = { 78591, 78987 } }, -- Gateway to Scenic Nagrand
			{ quest = 78594, questPool = { 78594, 78988 } }, -- Gateway to Scenic Feralas
			-- Self-Care
			{ quest = 78664, questPool = { 78664, 78989 } }, -- The Gift of Self-Care
			{ quest = 78674, questPool = { 78674, 78990 } }, -- The Gift of Relief
			{ quest = 78679, questPool = { 78679, 78991 } }, -- The Gift of Relaxation
		},
	},
	{
		id = "love-boss",
		key = "Love:Boss",
		group = RewardsGroup.LOVE_EVENT,
		description = "Daily Shadowfang Keep Dungeon Boss: Crown Chemical Co. Trio",
		minimumLevel = 10,
		unlockEvent = 423,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		entries = {
			{ quest = 288 + 9000000, progressType = 2, dungeon = 288 },
		},
		items = {
			{ item = 54537, amount = 1 },
		},
	},
	{
		id = "love-dono",
		key = "Love:Dono",
		group = RewardsGroup.LOVE_EVENT,
		description = "Donate gold to the Artisan's Consortium to support the Gala of Gifts.|n|n"
			.. "The rewards is delivered by mail in several minutes after the donation.",
		minimumLevel = 1,
		unlockEvent = 423,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		entries = {
			{ quest = 0, questPool = { 78683, 78912 }, unlockQuest = { 78683, 78912 } },
		},
		items = {
			{
				name = "|cff1eff00[Bundle of Love Tokens]|r for offering 500 gold, contains 3-5 |T135453:12|t |cffffffff[Love Token]|r",
				texture = 135454, -- Bundle of Love Tokens
			},
			{
				name = "|cff0070dd[Bundle of Love Tokens]|r for offering 10,000 gold, contains 10-15 |T135453:12|t |cffffffff[Love Token]|r",
				texture = 135454,
			},
		},
	},
}
