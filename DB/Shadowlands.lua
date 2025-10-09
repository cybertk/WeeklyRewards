local _, namespace = ...

local RewardsGroup = {
	SL_EVENT = "Shadowlands",
}

namespace.DB.rewardCandidiates["shadowlands"] = {
	{
		id = "sl-reservoir",
		key = "Reservoir",
		group = RewardsGroup.SL_EVENT,
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
		group = RewardsGroup.SL_EVENT,
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
		group = RewardsGroup.SL_EVENT,
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
		group = RewardsGroup.SL_EVENT,
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
		group = RewardsGroup.SL_EVENT,
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
		group = RewardsGroup.SL_EVENT,
		minimumLevel = 60,
		pick = 1,
		entries = {
			{ quest = 63543 }, -- Necrolord Assault
			{ quest = 63822 }, -- Venthyr Assault
			{ quest = 63823 }, -- Night Fae Assault
			{ quest = 63824 }, -- Kyrian Assault
		},
	},
}
