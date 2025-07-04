local _, namespace = ...

local RewardsGroup = {
	COLLECTORS_BOUNTY_EVENT = "Collector's Bounty",
}

namespace.DB.rewardCandidiates["collectors-bounty"] = {
	{
		id = "mount-69",
		key = "Rivendare's Deathcharger",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 69, dungeon = 329, difficulties = { 1 }, journals = { 484 }, encounters = { 456 } }, -- Lord Aurius Rivendare
		},
		items = {
			{ item = 13335 },
		},
	},
	{
		id = "mount-168",
		key = "Fiery Warhorse",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 168, dungeon = 532, difficulties = { 3 }, journals = { 652 }, encounters = { 1553 } }, -- Attumen the Huntsman
		},
		items = {
			{ item = 30480 },
		},
	},
	{
		id = "mount-183",
		key = "Ashes of Al'ar",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 183, dungeon = 550, difficulties = { 4 }, journals = { 733 }, encounters = { 1576 } }, -- Kael'thas Sunstrider
		},
		items = {
			{ item = 32458 },
		},
	},
	{
		id = "mount-185",
		key = "Raven Lord",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 185, dungeon = 556, difficulties = { 2 }, journals = { 1904 }, encounters = { 542 } }, -- Anzu
		},
		items = {
			{ item = 32768 },
		},
	},
	{
		id = "mount-213",
		key = "Swift White Hawkstrider",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 213, dungeon = 585, difficulties = { 2 }, journals = { 1894 }, encounters = { 533 } }, -- Kael'thas Sunstrider
		},
		items = {
			{ item = 35513 },
		},
	},
	{
		id = "mount-246",
		key = "Azure Drake",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 246, dungeon = 616, difficulties = { 3, 4 }, journals = { 1094 }, encounters = { 1617 } }, -- Malygos
		},
		items = {
			{ item = 43952 },
		},
	},
	{
		id = "mount-247",
		key = "Blue Drake",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 247, dungeon = 616, difficulties = { 3, 4 }, journals = { 1094 }, encounters = { 1617 } }, -- Malygos
		},
		items = {
			{ item = 43953 },
		},
	},
	{
		id = "mount-264",
		key = "Blue Proto-Drake",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 264, dungeon = 575, difficulties = { 2 }, journals = { 2029 }, encounters = { 643 } }, -- Skadi the Ruthless
		},
		items = {
			{ item = 44151 },
		},
	},
	{
		id = "mount-286",
		key = "Grand Black War Mammoth",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				quest = 0,
				progressType = 5,
				mount = 286,
				dungeon = 624,
				difficulties = { 3, 4 },
				journals = { 1126, 1127, 1128, 1129 },
				encounters = { 1597, 1598, 1599, 1600 },
			}, -- Archavon the Stone Watcher, Emalon the Storm Watcher, Koralon the Flame Watcher, Toravon the Ice Watcher
		},
		items = {
			{ item = 43959 },
		},
	},
	{
		id = "mount-304",
		key = "Mimiron's Head",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 304, dungeon = 603, difficulties = { 14 }, journals = { 1143 }, encounters = { 1649 } }, -- Yogg-Saron
		},
		items = {
			{ item = 45693 },
		},
	},
	{
		id = "mount-349",
		key = "Onyxian Drake",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 349, dungeon = 249, difficulties = { 3, 4 }, journals = { 1084 }, encounters = { 1651 } }, -- Onyxia
		},
		items = {
			{ item = 49636 },
		},
	},
	{
		id = "mount-363",
		key = "Invincible",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 363, dungeon = 631, difficulties = { 6 }, journals = { 1106 }, encounters = { 1636 } }, -- The Lich King
		},
		items = {
			{ item = 50818 },
		},
	},
	{
		id = "mount-395",
		key = "Drake of the North Wind",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 395, dungeon = 657, difficulties = { 1, 2 }, journals = { 1041 }, encounters = { 115 } }, -- Altairus
		},
		items = {
			{ item = 63040 },
		},
	},
	{
		id = "mount-396",
		key = "Drake of the South Wind",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 396, dungeon = 754, difficulties = { 3, 4, 5, 6 }, journals = { 1034 }, encounters = { 155 } }, -- Al'Akir
		},
		items = {
			{ item = 63041 },
		},
	},
	{
		id = "mount-397",
		key = "Vitreous Stone Drake",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 397, dungeon = 725, difficulties = { 1, 2 }, journals = { 1059 }, encounters = { 111 } }, -- Slabhide
		},
		items = {
			{ item = 63043 },
		},
	},
	{
		id = "mount-410",
		key = "Armored Razzashi Raptor",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 410, dungeon = 859, difficulties = { 2 }, journals = { 1179 }, encounters = { 176 } }, -- Bloodlord Mandokir
		},
		items = {
			{ item = 68823 },
		},
	},
	{
		id = "mount-411",
		key = "Swift Zulian Panther",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 411, dungeon = 859, difficulties = { 2 }, journals = { 1180 }, encounters = { 181 } }, -- High Priestess Kilnara
		},
		items = {
			{ item = 68824 },
		},
	},
	{
		id = "mount-415",
		key = "Pureblood Fire Hawk",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 415, dungeon = 720, difficulties = { 14, 15 }, journals = { 1203 }, encounters = { 198 } }, -- Ragnaros
		},
		items = {
			{ item = 69224 },
		},
	},
	{
		id = "mount-425",
		key = "Flametalon of Alysrazor",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 425, dungeon = 720, difficulties = { 14, 15 }, journals = { 1206 }, encounters = { 194 } }, -- Alysrazor
		},
		items = {
			{ item = 71665 },
		},
	},
	{
		id = "mount-442",
		key = "Blazing Drake",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 442, dungeon = 967, difficulties = { 3, 4, 5, 6 }, journals = { 1299 }, encounters = { 333 } }, -- Madness of Deathwing
		},
		items = {
			{ item = 77067 },
		},
	},
	{
		id = "mount-444",
		key = "Life-Binder's Handmaiden",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 444, dungeon = 967, difficulties = { 4, 6 }, journals = { 1299 }, encounters = { 333 } }, -- Madness of Deathwing
		},
		items = {
			{ item = 77069 },
		},
	},
	{
		id = "mount-445",
		key = "Experiment 12-B",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 445, dungeon = 967, difficulties = { 3, 4, 5, 6 }, journals = { 1297 }, encounters = { 331 } }, -- Ultraxion
		},
		items = {
			{ item = 78919 },
		},
	},
	{
		id = "mount-478",
		key = "Astral Cloud Serpent",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 478, dungeon = 1008, difficulties = { 3, 4, 5, 6 }, journals = { 1500 }, encounters = { 726 } }, -- Elegon
		},
		items = {
			{ item = 87777 },
		},
	},
	{
		id = "mount-531",
		key = "Spawn of Horridon",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 531, dungeon = 1098, difficulties = { 3, 4, 5, 6 }, journals = { 1575 }, encounters = { 819 } }, -- Horridon
		},
		items = {
			{ item = 93666 },
		},
	},
	{
		id = "mount-543",
		key = "Clutch of Ji-Kun",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 543, dungeon = 1098, difficulties = { 3, 4, 5, 6 }, journals = { 1573 }, encounters = { 828 } }, -- Ji-Kun
		},
		items = {
			{ item = 95059 },
		},
	},
	{
		id = "mount-559",
		key = "Kor'kron Juggernaut",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 559, dungeon = 1136, difficulties = { 16 }, journals = { 1623 }, encounters = { 869 } }, -- Garrosh Hellscream
		},
		items = {
			{ item = 104253 },
		},
	},
	{
		id = "mount-613",
		key = "Ironhoof Destroyer",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 613, dungeon = 1205, difficulties = { 16 }, journals = { 1704 }, encounters = { 959 } }, -- Blackhand
		},
		items = {
			{ item = 116660 },
		},
	},
	{
		id = "mount-751",
		key = "Felsteel Annihilator",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 751, dungeon = 1448, difficulties = { 16 }, journals = { 1799 }, encounters = { 1438 } }, -- Archimonde
		},
		items = {
			{ item = 123890 },
		},
	},
	{
		id = "mount-791",
		key = "Felblaze Infernal",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 791, dungeon = 1530, difficulties = { 14, 15, 16 }, journals = { 1866 }, encounters = { 1737 } }, -- Gul'dan
		},
		items = {
			{ item = 137574 },
		},
	},
	{
		id = "mount-633",
		key = "Hellfire Infernal",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 633, dungeon = 1530, difficulties = { 16 }, journals = { 1866 }, encounters = { 1737 } }, -- Gul'dan
		},
		items = {
			{ item = 137575 },
		},
	},
	{
		id = "mount-875",
		key = "Midnight",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 875, dungeon = 1651, difficulties = { 23 }, journals = { 1960 }, encounters = { 1835 } }, -- Attumen the Huntsman
		},
		items = {
			{ item = 142236 },
		},
	},
	{
		id = "mount-899",
		key = "Abyss Worm",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 899, dungeon = 1676, difficulties = { 14, 15, 16, 17 }, journals = { 2037 }, encounters = { 1861 } }, -- Mistress Sassz'ine
		},
		items = {
			{ item = 143643 },
		},
	},
	{
		id = "mount-954",
		key = "Shackled Ur'zul",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 954, dungeon = 1712, difficulties = { 16 }, journals = { 2092 }, encounters = { 2031 } }, -- Argus the Unmaker
		},
		items = {
			{ item = 152789 },
		},
	},
	{
		id = "mount-971",
		key = "Antoran Charhound",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 971, dungeon = 1712, difficulties = { 14, 15, 16, 17 }, journals = { 2074 }, encounters = { 1987 } }, -- Felhounds of Sargeras
		},
		items = {
			{ item = 152816 },
		},
	},
	{
		id = "mount-995",
		key = "Sharkbait",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 995, dungeon = 1754, difficulties = { 23 }, journals = { 2096 }, encounters = { 2095 } }, -- Lord Harlan Sweete
		},
		items = {
			{ item = 159842 },
		},
	},
	{
		id = "mount-1040",
		key = "Tomb Stalker",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 1040, dungeon = 1762, difficulties = { 23 }, journals = { 2143 }, encounters = { 2172 } }, -- King Dazar
		},
		items = {
			{ item = 159921 },
		},
	},
	{
		id = "mount-1053",
		key = "Underrot Crawg",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 1053, dungeon = 1841, difficulties = { 23 }, journals = { 2123 }, encounters = { 2158 } }, -- Unbound Abomination
		},
		items = {
			{ item = 160829 },
		},
	},
	{
		id = "mount-1217",
		key = "G.M.O.D.",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 1217, dungeon = 2070, difficulties = { 14, 15, 16, 17 }, journals = { 2276 }, encounters = { 2334 } }, -- Mekkatorque
		},
		items = {
			{ item = 166518 },
		},
	},
	{
		id = "mount-1219",
		key = "Glacial Tidestorm",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 1219, dungeon = 2070, difficulties = { 16 }, journals = { 2281 }, encounters = { 2343 } }, -- Lady Jaina Proudmoore
		},
		items = {
			{ item = 166705 },
		},
	},
	{
		id = "mount-1293",
		key = "Ny'alotha Allseer",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 1293, dungeon = 2217, difficulties = { 16 }, journals = { 2344 }, encounters = { 2375 } }, -- N'Zoth the Corruptor
		},
		items = {
			{ item = 174872 },
		},
	},
	{
		id = "mount-1406",
		key = "Marrowfang",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 1406, dungeon = 2286, difficulties = { 23 }, journals = { 2390 }, encounters = { 2396 } }, -- Nalthor the Rimebinder
		},
		items = {
			{ item = 181819 },
		},
	},
	{
		id = "mount-1471",
		key = "Vengeance",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 1471, dungeon = 2450, difficulties = { 16 }, journals = { 2435 }, encounters = { 2441 } }, -- Sylvanas Windrunner
		},
		items = {
			{ item = 186642 },
		},
	},
	{
		id = "mount-1481",
		key = "Cartel Master's Gearglider",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		entries = {
			{ quest = 0, progressType = 5, mount = 1481, dungeon = 2441, difficulties = { 2, 23 }, journals = { 2442 }, encounters = { 2455 } }, -- So'leah
		},
		items = {
			{ item = 186638 },
		},
	},
	{
		id = "mount-1500",
		key = "Sanctum Gloomcharger",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 1500, dungeon = 2450, difficulties = { 14, 15, 16, 17 }, journals = { 2429 }, encounters = { 2439 } }, -- The Nine
		},
		items = {
			{ item = 186656 },
		},
	},
	{
		id = "mount-1587",
		key = "Zereth Overseer",
		group = RewardsGroup.COLLECTORS_BOUNTY_EVENT,
		minimumLevel = 1,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 5, mount = 1587, dungeon = 2481, difficulties = { 16 }, journals = { 2537 }, encounters = { 2464 } }, -- The Jailer
		},
		items = {
			{ item = 190768 },
		},
	},
}
