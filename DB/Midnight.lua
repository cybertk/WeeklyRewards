local _, namespace = ...

local RewardsGroup = {
	PINNACLE_CACHE = "Pinnacle Cache",
}

namespace.DB.rewardCandidiates["MN"] = {
	{
		id = "mn-spark",
		key = "Spark",
		description = "Meta Quest from Lady Liadrin|nRewards a weekly Spark of Radiance",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				questPool = {
					93766, -- Midnight: World Quests
					93767, -- Midnight: Arcantina
					93769, -- Midnight: Housing
					93889, -- Midnight: Saltheril's Soiree
					93890, -- Midnight: Abundance
					93891, -- Midnight: Legends of the Haranir
					93892, -- Midnight: Stormarion Assault
					93909, -- Midnight: Delves
					93910, -- Midnight: Prey
					93911, -- Midnight: Dungeons
					93912, -- Midnight: Raid
					93913, -- Midnight: World Boss
					94457, -- Midnight: Battlegrounds
					95468, -- Hope in the Darkest Corners
				},
			},
		},
	},
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
	{
		id = "mn-sa",
		key = "SA",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 80,
		pick = 2,
		trackRecords = true,
		rollover = true,
		entries = {
			{ quest = 92145, unlockQuest = 92848 }, -- Special Assignment: The Grand Magister's Drink
			{ quest = 92063, unlockQuest = 94390 }, -- Special Assignment: A Hunter's Regret
			{ quest = 93013, unlockQuest = 94391 }, -- Special Assignment: Push Back the Light
			{ quest = 93438, unlockQuest = 94743 }, -- Special Assignment: Precision Excision
			{ quest = 93244, unlockQuest = 94795 }, -- Special Assignment: Agents of the Shield
			{ quest = 91390, unlockQuest = 94865 }, -- Special Assignment: What Remains of a Temple Broken
			{ quest = 91796, unlockQuest = 94866 }, -- Special Assignment: Ours Once More!
			{ quest = 92139, unlockQuest = 95435 }, -- Special Assignment: Shade and Claw
		},
	},
}
