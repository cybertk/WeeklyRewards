local _, namespace = ...

local RewardsGroup = {
	PINNACLE_CACHE = "Pinnacle Cache",
	WEEKLY_CACHE = "Weekly Cache",
	SIREN_ISLE = "Siren Isle",
	UNDERMINE = "Undermine",
	DELVE = "Delve",
	NIGHTFALL = "Nightfall",
	KARESH = "K'aresh",
}

namespace.DB.rewardCandidiates["tww"] = {
	{
		id = "tww-worldboss",
		key = "WorldBoss",
		description = "Weekly World Boss",
		minimumLevel = 80,
		entries = {
			{ quest = 81624 }, -- Orta, the Broken Mountain
			{ quest = 81630 }, -- Kordac, the Dormant Protector
			{ quest = 81653 }, -- Shurrai, Atrocity of the Undersea
			{ quest = 82653 }, -- Aggregation of Horrors
		},
	},
	{
		id = "tww-dkeys",
		key = "DelveKeys",
		description = "Weekly Delve Keys",
		group = RewardsGroup.DELVE,
		pick = 8,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 91175, items = { 238527 }, loot = { 413590, name = { 228942 } } }, -- Bountiful Coffer
			{ quest = 91176, items = { 238527 } }, -- Restored Coffer Key
			{ quest = 91177, items = { 238527 } }, -- Restored Coffer Key
			{ quest = 91178, items = { 238527 } }, -- Restored Coffer Key
			{ quest = 84736, items = { 245653, amount = 50 } }, -- Coffer Key Shard
			{ quest = 84737, items = { 245653, amount = 50 } }, -- Coffer Key Shard
			{ quest = 84738, items = { 245653, amount = 50 } }, -- Coffer Key Shard
			{ quest = 84739, items = { 245653, amount = 50 } }, -- Coffer Key Shard
		},
		items = {
			{ currency = 3028, amount = 4 }, -- Restored Coffer Key
			{ item = 245653, amount = 200 }, -- Coffer Key Shard
		},
	},
	{
		id = "tww-archives",
		key = "Archives",
		description = "Archives Meta Quest",
		group = RewardsGroup.PINNACLE_CACHE,
		rollover = true,
		minimumLevel = 70,
		timeLeft = function()
			local questDuration = 21 * SECONDS_PER_DAY
			local questWeek = time({ year = 2025, month = 8, day = 4 })

			local now = GetServerTime()
			local timeStarted = questWeek + ((now + C_DateAndTime.GetSecondsUntilWeeklyReset() - questWeek) % (7 * SECONDS_PER_DAY))

			return questDuration - ((now - timeStarted) % questDuration)
		end,
		entries = {
			{
				quest = 82679, -- Archives: Seeking History
				unlockQuest = 82678, -- Archives: The First Disc
				unlockUntilReset = true,
			},
		},
	},
	{
		id = "tww-delves",
		key = "Delves",
		description = "Delves Meta Quest",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 70,
		timeLeft = function()
			local questDuration = 21 * SECONDS_PER_DAY
			local questWeek = time({ year = 2025, month = 2, day = 24 })

			local now = GetServerTime()
			local timeStarted = questWeek + ((now + C_DateAndTime.GetSecondsUntilWeeklyReset() - questWeek) % (7 * SECONDS_PER_DAY))

			return questDuration - ((now - timeStarted) % questDuration)
		end,
		entries = {
			{ quest = 82706 }, -- Delves: Worldwide Research
		},
	},
	{
		id = "tww-worldsoul",
		key = "Worldsoul",
		description = "The Call of the Worldsoul",
		group = RewardsGroup.PINNACLE_CACHE,
		minimumLevel = 70,
		entries = {
			{
				quest = 82511,
				unlockQuest = 82449, -- The Call of the Worldsoul
				maxCompletion = 1,
				questPool = {
					82511, -- Worldsoul: Awakening Machine
					82453, -- Worldsoul: Encore!
					82516, -- Worldsoul: Forging a Pact
					82458, -- Worldsoul: Renown
					82482, -- Worldsoul: Snuffling
					82483, -- Worldsoul: Spreading the Light
					82512, -- Worldsoul: World Boss
					82452, -- Worldsoul: World Quests
					82491, -- Worldsoul: Ara-Kara, City of Echoes [N]
					82494, -- Worldsoul: Ara-Kara, City of Echoes [H]
					82502, -- Worldsoul: Ara-Kara, City of Echoes [M]
					82485, -- Worldsoul: Cinderbrew Meadery [N]
					82495, -- Worldsoul: Cinderbrew Meadery [H]
					82503, -- Worldsoul: Cinderbrew Meadery [M]
					82492, -- Worldsoul: City of Threads [N]
					82496, -- Worldsoul: City of Threads [H]
					82504, -- Worldsoul: City of Threads [M]
					82488, -- Worldsoul: Darkflame Cleft [N]
					82498, -- Worldsoul: Darkflame Cleft [H]
					82506, -- Worldsoul: Darkflame Cleft [M]
					82490, -- Worldsoul: Priory of the Sacred Flame [N]
					82499, -- Worldsoul: Priory of the Sacred Flame [H]
					82507, -- Worldsoul: Priory of the Sacred Flame [M]
					82489, -- Worldsoul: The Dawnbreaker [N]
					82493, -- Worldsoul: The Dawnbreaker [H]
					82501, -- Worldsoul: The Dawnbreaker [M]
					82486, -- Worldsoul: The Rookery [N]
					82500, -- Worldsoul: The Rookery [H]
					82508, -- Worldsoul: The Rookery [M]
					82487, -- Worldsoul: The Stonevault [N]
					82497, -- Worldsoul: The Stonevault [H]
					82505, -- Worldsoul: The Stonevault [M]
					82509, -- Worldsoul: Nerub-ar Palace [LFR]
					82659, -- Worldsoul: Nerub-ar Palace [N]
					82510, -- Worldsoul: Nerub-ar Palace [H]
					87417, -- Worldsoul: Dungeons
					87419, -- Worldsoul: Delves
					87422, -- Worldsoul: Undermine World Quests
					87423, -- Worldsoul: Undermine Explorer
					87424, -- Worldsoul: World Bosses
					89514, -- Worldsoul: Horrific Visions Revisited
					91855, -- Worldsoul: K'aresh World Quests
				},
			},
		},
	},
	{
		id = "tww-sa",
		key = "SA",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 70,
		pick = 2,
		trackRecords = true,
		rollover = true,
		entries = {
			{ quest = 82355, unlockQuest = 82146 }, -- Special Assignment: Cinderbee Surge
			{ quest = 81647, unlockQuest = 82154 }, -- Special Assignment: Titanic Resurgence
			{ quest = 81649, unlockQuest = 83069 }, -- Special Assignment: Titanic Resurgence
			{ quest = 81650, unlockQuest = 83070 }, -- Special Assignment: Titanic Resurgence
			{ quest = 81691, unlockQuest = 82155 }, -- Special Assignment: Shadows Below
			{ quest = 83229, unlockQuest = 82156 }, -- Special Assignment: When the Deeps Stir
			{ quest = 82787, unlockQuest = 82157 }, -- Special Assignment: Rise of the Colossals
			{ quest = 82852, unlockQuest = 82158 }, -- Special Assignment: Lynx Rescue
			{ quest = 82414, unlockQuest = 82159 }, -- Special Assignment: A Pound of Cure
			{ quest = 82531, unlockQuest = 82161 }, -- Special Assignment: Bombs From Behind
		},
	},
	{
		id = "tww-light",
		key = "Light",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 70,
		entries = {
			{ quest = 76586 }, -- Spreading the Light
		},
	},
	{
		id = "tww-pact",
		key = "Spider",
		description = "Weekly Azj-Kahet Pact Choice",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 70,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		pick = 2,
		rollover = true,
		entries = {
			{
				quest = 80592, -- Forge a pact
				removeOnCompletion = true,
			},
			{
				quest = 80670,
				questPool = {
					80670, -- Eyes of the Weaver
					80671, -- Blade of the General
					80672, -- Hand of the Vizier
				},
				unlockQuest = {
					80544, -- Pact: The Weaver
					80545, -- Pact: The General
					80546, -- Pact: The Vizier
				},
			},
		},
	},
	{
		id = "tww-troupe",
		key = "Troupe",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 80,
		rollover = true,
		entries = {
			{ quest = 83240 }, -- The Theater Troupe
		},
	},
	{
		id = "tww-atm",
		key = "Machine",
		description = "Weekly Awakening the Machine Event",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 70,
		entries = {
			{ quest = 83333 }, -- Gearing Up for Trouble
		},
	},
	{
		id = "tww-wax",
		key = "Wax",
		description = "Collect wax for Kobolds",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 80,
		rollover = true,
		entries = {
			{ quest = 82946 }, -- Rollin' Down in the Deeps
		},
	},
	{
		id = "tww-lfd",
		key = "Dungeon",
		description = "Weekly Dungeon Quest",
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 83465 }, -- Ara-Kara, City of Echoes
			{ quest = 83436 }, -- Cinderbrew Meadery
			{ quest = 83469 }, -- City of Threads
			{ quest = 83443 }, -- Darkflame Cleft
			{ quest = 83458 }, -- Priory of the Sacred Flame
			{ quest = 83459 }, -- The Dawnbreaker
			{ quest = 83432 }, -- The Rookery
			{ quest = 83457 }, -- The Stonevault
			{ quest = 86203 }, -- Operation: Floodgate
		},
	},
	{
		id = "tww-storm",
		key = "SA:Storm",
		group = RewardsGroup.SIREN_ISLE,
		minimumLevel = 80,
		entries = {
			{
				quest = 85113, -- Special Assignment: Storm's a Brewin
				unlockQuest = 84850, -- Serpent's Wrath
			},
			{
				quest = 85113, -- Special Assignment: Storm's a Brewin
				unlockQuest = 84851, -- Tides of Greed
			},
			{
				quest = 85113, -- Special Assignment: Storm's a Brewin
				unlockQuest = 84852, -- Legacy of the Vrykul
			},
		},
	},
	{
		id = "tww-invasion",
		key = "Invasion",
		description = "Siren Isle Invasion Quests|n|n"
			.. "Enemies cycle every week from a pool of three types:|n"
			.. "|cffffff00Vrykul|r, |cffffff00Naga|r, and |cffffff00Pirate|r.",
		group = RewardsGroup.SIREN_ISLE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		pick = 5,
		entries = {
			-- Vrykul Invasion - Unlock by Legacy of the Vrykul
			{ quest = 84248, unlockQuest = 84852 }, -- A Ritual of Runes
			{ quest = 83932, unlockQuest = 84852 }, -- Historical Documents
			{ quest = 84432, unlockQuest = 84852 }, -- Longship Landing
			{ quest = 84680, unlockQuest = 84852 }, -- Rock 'n Stone Revival
			{ quest = 84222, unlockQuest = 84852 }, -- Secure the Perimeter
			-- Naga Invasion - Unlock by Serpent's Wrath
			{ quest = 84252, unlockQuest = 84850 }, -- Peak Precision
			{ quest = 84430, unlockQuest = 84850 }, -- Crystal Crusade
			{ quest = 84627, unlockQuest = 84850 }, -- Three Heads of the Deep
			{ quest = 85051, unlockQuest = 84850 }, -- Beach Comber
			{ quest = 85589, unlockQuest = 84850 }, -- Ruffled Pages
			-- Pirate Invasion - Unlock by Tides of Greed
			{ quest = 83753, unlockQuest = 84851 }, -- Cannon Karma
			{ quest = 83827, unlockQuest = 84851 }, -- Silence the Song
			{ quest = 84001, unlockQuest = 84851 }, -- Cart Blanche
			{ quest = 84299, unlockQuest = 84851 }, -- Pirate Plunder
			{ quest = 84619, unlockQuest = 84851 }, -- Ooker Dooker Literature Club
		},
	},
	{
		id = "tww-circlet",
		key = "Circlet",
		description = "|T6215518:12|t |cffa335ee[Cyrce's Circlet]|r|n|n"
			.. "The ring starts at Item Level 642 by completing |cffffff00[A Radiant Vault]|r.|n|n"
			.. "|T6215533:12|t |cffa335ee[Raw Singing Citrine]|r upgrades the ring to maximum Item Level 658.|n"
			.. "It drops from all Siren Isle content.",
		group = RewardsGroup.SIREN_ISLE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{
				quest = 0,
				unlockQuest = 84724, -- The Radiant Vault
				progressType = 3,
				items = { 228411 }, -- Cyrce's Circlet
				upgradeItem = 229365, -- Raw Singing Citrine
				itemLevelRange = { 642, 645, 649, 652, 655, 658 },
			},
		},
		items = { { item = 229365, amount = 1 } },
	},
	{
		id = "tww-vault",
		key = "GreatVault",
		description = "Great Valut Rewards that provides you with 1 piece of loot from a pool of up to 9 items. |n|n"
			.. "The item level of rewards depends on your highest runs of the week.|n"
			.. "You could select the |cffa335ee[Algari Token of Merit]|r instead of loots.",
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 1 },
		},
		items = {
			{
				name = "2 |cffa335ee[Algari Token of Meritz]|r for 1 Great Vault slot",
				texture = 2744751, -- Algari Token of Meritz
			},
			{
				name = "4 |cffa335ee[Algari Token of Meritz]|r for 2 Great Vault slots",
				texture = 2744751,
			},
			{
				name = "6 |cffa335ee[Algari Token of Meritz]|r for 3+ Great Vault slots",
				texture = 2744751,
			},
		},
	},
	{
		id = "tww-sa-um",
		key = "SA:Underm",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 80,
		entries = {
			{
				quest = 85487, -- Special Assignment: Boom! Headshot!
				unlockQuest = 85489, -- Special Assignment: Capstone 1 - Unlock
			},
			{
				quest = 85488, -- Special Assignment: Security Detail
				unlockQuest = 85490, -- Special Assignment: Capstone 2 - Unlock
			},
		},
	},
	{
		id = "tww-surge",
		key = "Surge",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 80,
		rollover = true,
		entries = {
			{
				quest = 86775, -- Urge to Surge
				loot = {
					236756, -- Socially Expected Tip Chest
					236757, -- Generous Tip Chest
					236758, -- Extravagant Tip Chest
				},
			},
		},
	},
	{
		id = "tww-gig",
		key = "SideGig",
		group = RewardsGroup.UNDERMINE,
		minimumLevel = 80,
		pick = 4,
		entries = {
			{ quest = 85554 }, -- Side Gig: It's Always Sunny Side Up
			{ quest = 86177 }, -- Side Gig: The Tides Provide
			{ quest = 86178 }, -- Side Gig: Cleanin' the Coast
			{ quest = 86179 }, -- Side Gig: Lucky Break's Big Break

			{ quest = 85914 }, -- Side Gig: Coolant Matters
			{ quest = 85944 }, -- Side Gig: Blood Type
			{ quest = 85945 }, -- Side Gig: Blood-B-Gone
			{ quest = 85960 }, -- Side Gig: Lost in the Sauce

			{ quest = 85553 }, -- Side Gig: Feeling Crabby
			{ quest = 85913 }, -- Side Gig: Cleanup Detail
			{ quest = 85962 }, -- Side Gig: Unseemly Reagents
			{ quest = 86180 }, -- Side Gig: Infested Waters
		},
	},
	{
		id = "tww-snh",
		key = "Shipping",
		group = RewardsGroup.UNDERMINE,
		minimumLevel = 80,
		rollover = true,
		entries = {
			{ quest = 85869 }, -- Many Jobs, Handle It!
		},
	},
	{
		id = "tww-scrap",
		key = "SCRAP",
		group = RewardsGroup.UNDERMINE,
		minimumLevel = 80,
		rollover = true,
		entries = {
			{ quest = 85879 }, -- Reduce, Reuse, Resell
		},
	},
	{
		id = "tww-gobfather",
		key = "Gobfather",
		group = RewardsGroup.UNDERMINE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 85088 }, -- The Main Event
		},
	},
	{
		id = "tww-chett",
		key = "C.H.E.T.T.",
		description = "Weekly C.H.E.T.T. List",
		group = RewardsGroup.UNDERMINE,
		minimumLevel = 80,
		rollover = true,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		pick = 2,
		entries = {
			{ quest = 87296, items = { 236682, 235053 }, itemsMaxCount = { 0, 1 }, removeOnCompletion = true },
			{
				quest = 0,
				maxCompletion = 4,
				unlockItem = 235053,
				questPool = {
					86915, -- Side with a Cartel
					86917, -- Ship Right
					86918, -- Reclaimed Scrap
					86919, -- Side Gig
					86920, -- War Mode Violence
					86923, -- Go Fish
					86924, -- Gotta Catch at Least a Few
					87302, -- Rare Rivals
					87303, -- Clean the Sidestreets
					87304, -- Time to Vacate
					87305, -- Desire to D.R.I.V.E.
					87306, -- Kaja Cruising
					87307, -- Garbage Day
				},
			},
		},
		items = {
			{ currency = 3008, amount = 1 },
			{ item = 235053, amount = 1 },
		},
	},
	{
		id = "tww-dmap",
		key = "DelveMap",
		description = "Weekly Delver's Bounty Map",
		group = RewardsGroup.DELVE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 86371, items = { 233071 }, loot = { 461482, name = { 235559 } } }, -- Hidden Trove
		},
		items = { { item = 233071, amount = 1 } },
	},
	{
		id = "tww-dstash",
		key = "GildedStash",
		description = "Weekly Gilded Stash in Delves",
		group = RewardsGroup.DELVE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 4 },
		},
		items = {
			{
				name = "3 |cffffffff[Gilded Stash]|r",
				texture = 5872049, -- Gilded Stash
			},
		},
	},
	{
		id = "tww-incursion",
		key = "Incursion",
		description = "Daily incursions in Hollowfall or Azj-Kahet",
		group = RewardsGroup.NIGHTFALL,
		minimumLevel = 70,
		rollover = true,
		pick = 3,
		entries = {
			{ quest = 87475 }, -- Sureki Incursion: Hold the Wall
			{ quest = 87477 }, -- Sureki Incursion: Southern Swarm
			{ quest = 87480 }, -- Sureki Incursion: The Eastern Assault

			{ quest = 88711 }, -- Radiant Incursion: Toxins and Pheromones
			{ quest = 88916 }, -- Radiant Incursion: Sureki's End
			{ quest = 88945 }, -- Radiant Incursion: Rak-Zakaz
		},
	},
	{
		id = "tww-nightfall",
		key = "Nightfall",
		group = RewardsGroup.NIGHTFALL,
		minimumLevel = 70,
		entries = {
			{
				quest = 91173, -- The Flame Burns Eternal
				loot = {
					237743, -- Arathi Soldier's Coffer
					237759, -- Arathi Cleric's Chest
					237760, -- Arathi Champion's Spoils
				},
			},
		},
	},
	{
		id = "tww-belt",
		key = "D.I.S.C.",
		description = "|T6883015:12|t |cffa335ee[Durable Information Securing Container]|r(D.I.S.C. Belt)|n|n"
			.. "The belt starts at Item Level 691 by completing the quest offered by Dagran II in Dornogal.|n|n"
			.. "|T134394:12|t |cffa335ee[Titan Memory Card]|r upgrades the belt to maximum Item Level 701 by 3 times.",
		group = RewardsGroup.DELVE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{
				quest = 0,
				unlockQuest = 91009, -- Durable Information Securing Container
				progressType = 3,
				items = { 242664, 245964, 245965, 245966 },
				upgradeItem = 244311, -- Titan Memory Card
				itemLevelRange = { 691, 694, 697, 701 },
			},
		},
		items = { { item = 244311, amount = 1 }, { item = 244696, amount = 1 } },
	},
	{
		id = "tww-sa-ka",
		key = "SA:K'aresh",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 80,
		entries = {
			{
				quest = 89293, -- Special Assignment: Overshadowed
				unlockQuest = 91193, -- Special Assignment: Capstone 1 - Unlock
			},
			{
				quest = 89294, -- Special Assignment: Aligned Views
				unlockQuest = 91203, -- Special Assignment: Capstone 2 - Unlock
			},
		},
	},
	{
		id = "tww-oasis",
		key = "Oasis",
		group = RewardsGroup.WEEKLY_CACHE,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{ quest = 85460 }, -- Ecological Succession
		},
	},
	{
		id = "tww-diving",
		key = "PhaseDiving",
		group = RewardsGroup.KARESH,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{ quest = 91093 }, -- More Than Just a Phase
		},
	},
	{
		id = "tww-reshanor",
		key = "Reshanor",
		group = RewardsGroup.KARESH,
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 87354 }, -- Reshanor, the Untethered
		},
	},
}
