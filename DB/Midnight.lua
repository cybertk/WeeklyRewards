local _, namespace = ...

local RewardsGroup = {
	PINNACLE_CACHE = "Pinnacle Cache",
	PVP = "PvP",
	LEVELING = "Leveling",
	PREY = "Prey",
}

local function range(start, stop, step)
	step = step or 1
	local t = {}
	for i = start, stop, step do
		table.insert(t, i)
	end
	return t
end

namespace.DB.rewardCandidiates["MN"] = {
	{
		id = "mn-hope",
		key = "Hope",
		group = RewardsGroup.LEVELING,
		minimumLevel = 80,
		maximumLevel = 89,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 95468 } }, -- Hope in the Darkest Corners
	},
	{
		id = "mn-spark",
		key = "Spark",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				quest = 93744, -- Unity Against the Void
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
				},
				maxCompletion = 1,
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
		key = "Runestones",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				quest = 91966, -- Saltheril's Soiree
				questPool = {
					90573, -- Fortify the Runestones: Magisters
					90574, -- Fortify the Runestones: Blood Knights
					90575, -- Fortify the Runestones: Farstriders
					90576, -- Fortify the Runestones: Shades of the Row
				},
				maxCompletion = 1,
			},
		},
	},
	{
		id = "mn-legends",
		key = "Legends",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				quest = 89268, -- Lost Legends
				questPool = {
					88993, -- Wey'nan's Ward
					88994, -- The Cauldron of Echoes
					88996, -- The Echoless Flame
					88997, -- Russula's Outreach
					88995, -- Aln'hara's Bloom
				},
				maxCompletion = 1,
			},
		},
	},
	{
		id = "mn-war",
		key = "WarSparks",
		group = RewardsGroup.PVP,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 93423 }, -- Sparks of War: Eversong Woods
			{ quest = 93424 }, -- Sparks of War: Zul'Aman
			{ quest = 93425 }, -- Sparks of War: Harandar
			{ quest = 93426 }, -- Sparks of War: Voidstorm
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
	{
		id = "mn-prey-n",
		key = "|A:worldquest-Prey-Crystal:16:16|aNormal",
		description = "Weekly Prey Quests (Normal)",
		group = RewardsGroup.PREY,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, questPool = range(91095, 91124), maxCompletion = 4 } },
	},
	{
		id = "mn-prey-h",
		key = "|A:worldquest-Prey-Crystal:16:16|aHard",
		description = "Weekly Prey Quests (Hard)",
		group = RewardsGroup.PREY,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { quest = 0, questPool = tAppendAll(range(91210, 91242, 2), range(91243, 91255)), maxCompletion = 4 } },
	},

	{
		id = "mn-prey-m",
		key = "|A:worldquest-Prey-Crystal:16:16|aNightmare",
		description = "Weekly Prey Quests (Nightmare)",
		group = RewardsGroup.PREY,
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, questPool = tAppendAll(range(91211, 91241, 2), range(91256, 91269)), maxCompletion = 4 },
		},
	},
}
