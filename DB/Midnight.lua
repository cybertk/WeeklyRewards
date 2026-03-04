local _, namespace = ...

local RewardsGroup = {
	PINNACLE_CACHE = "Pinnacle Cache",
}

namespace.DB.rewardCandidiates["MN"] = {
	{
		id = "mn-worldboss",
		key = "WorldBoss",
		description = "Weekly World Boss",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 92123 }, -- Cragpine
			{ quest = 92560 }, -- Lu'ashal
			{ quest = 92636 }, -- Predaxas
			{ quest = 92034 }, -- Thorm'belan
		},
	},
	{
		id = "mn-abundant",
		key = "Abundance",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 89507 } }, -- Abundant Offerings
	},
	{
		id = "mn-stormarion",
		key = "Stormarion",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 90962 } }, -- Stormarion Assault
	},
	{
		id = "mn-soiree",
		key = "Soiree",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				questPool = {
					90573, -- Fortify the Runestones: Magisters
					90574, -- Fortify the Runestones: Blood Knights
					90575, -- Fortify the Runestones: Farstriders
					90576, -- Fortify the Runestones: Shades of the Row
				},
			},
		},
	},
}
