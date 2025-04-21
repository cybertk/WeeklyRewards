local _, namespace = ...

local RewardsGroup = {
	NOBLE_EVENT = "Noblegarden",
}

namespace.DB.rewardCandidiates["noble"] = {
	{
		id = "noble-main",
		key = "Noble:Main",
		group = RewardsGroup.NOBLE_EVENT,
		description = "One-time introductory quests",
		minimumLevel = 1,
		unlockEvent = 181, -- Noblegarden
		timeLeft = "end-of-event",
		pick = 5,
		entries = {
			{ quest = 13502, questPool = { 13502, 13503 } }, -- A Tisket, a Tasket, a Noblegarden Basket
			{ quest = 79322, questPool = { 79322, 79575 } }, -- What the Duck?
			{ quest = 79323, questPool = { 79323, 79576 } }, -- A Fowl Concoction
			{ quest = 79330, questPool = { 79330, 79577 } }, -- Duck Tales
			{ quest = 79331, questPool = { 79331, 79578 } }, -- Just a Waddle Away
		},
	},
	{
		id = "noble-daily",
		key = "Noble:Daily",
		group = RewardsGroup.NOBLE_EVENT,
		description = "Daily Quests",
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		unlockEvent = 181,
		pick = 2,
		entries = {
			{ quest = 13480, questPool = { 13480, 13479 } }, -- The Great Egg Hunt
			{ quest = 78274, questPool = { 78274, 79135 } }, -- Quacking Down
		},
	},
	{
		id = "noble-boss",
		key = "Noble:Boss",
		group = RewardsGroup.NOBLE_EVENT,
		description = "Daily Holiday Boss: Daetan Swiftplume.|n|nThe nest of this feathery fiend is located in both Elwyn Forest and Durotar.",
		minimumLevel = 1,
		unlockEvent = 181,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		entries = {
			{ quest = 73192, questPool = { 73192, 79558 } }, -- Feathered Fiend
		},
	},
}
