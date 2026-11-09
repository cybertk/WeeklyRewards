local _, namespace = ...

namespace.DB.rewardCandidiates[LE_EXPANSION_SHADOWLANDS] = {
	{
		id = "sl-reservoir",
		key = "Reservoir",
		minimumLevel = 10,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{
				quest = 61984,
				questPool = { 61981, 61982, 61983, 61984 }, -- Replenish the Reservoir
			},
		},
	},
	{
		id = "sl-shaping-fate",
		key = "ShapingFate",
		minimumLevel = 60,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{ quest = 63949 }, -- Shaping Fate,
		},
	},
	{
		id = "sl-rift",
		key = "Rift",
		minimumLevel = 60,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{ quest = 65266 }, -- Lost Research,
		},
	},
	{
		id = "sl-tormentor",
		key = "Tormentors",
		minimumLevel = 60,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				quest = 63854,
				items = { 185972 }, -- Tormentor's Cache
				loot = { 185972 },
			},
		},
	},
	{
		id = "sl-patterns",
		key = "Patterns",
		minimumLevel = 60,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{ quest = 66042 }, -- Patterns Within Patterns
		},
	},
	{
		id = "sl-assault",
		key = "Assault",
		minimumLevel = 60,
		pick = 1,
		entries = {
			{ quest = 63543, unlockPoi = 6989, name = "{poi:6989}" }, -- Necrolord Assault
			{ quest = 63822, unlockPoi = 6990, name = "{poi:6990}" }, -- Venthyr Assault
			{ quest = 63823, unlockPoi = 6992, name = "{poi:6992}" }, -- Night Fae Assault
			{ quest = 63824, unlockPoi = 6991, name = "{poi:6991}" }, -- Kyrian Assault
		},
	},
}
