local _, namespace = ...

local RewardsGroup = {
	DARKMOON_EVENT = "Darkmoon Faire Event",
}

namespace.DB.rewardCandidiates["darkmoon"] = {
	{
		id = "df-artifacts",
		key = "DF:Artf.",
		group = RewardsGroup.DARKMOON_EVENT,
		description = "Darkmoon Faire Artifacts",
		minimumLevel = 1,
		unlockEvent = 479, -- Darkmoon Faire
		timeLeft = "end-of-event",
		pick = 9,
		entries = {
			{ quest = 29451, items = { 71715 } }, -- The Master Strategist/A Treatise on Strategy
			{ quest = 29456, items = { 71951 } }, -- A Captured Banner/Banner of the Fallen
			{ quest = 29457, items = { 71952 } }, -- The Enemy's Insignia/Captured Insignia
			{ quest = 29458, items = { 71953 } }, -- The Captured Journal/Fallen Adventurer's Journal
			{ quest = 29443, items = { 71635 } }, -- A Curious Crystal/Imbued Crystal
			{ quest = 29444, items = { 71636 } }, -- An Exotic Egg/Monstrous Egg
			{ quest = 29445, items = { 71637 } }, -- An Intriguing Grimoire/Mysterious Grimoire
			{ quest = 29446, items = { 71638 } }, -- A Wondrous Weapon/Ornate Weapon
			{ quest = 29464, items = { 71716 } }, -- Tools of Divination/Soothsayer's Runes
		},
	},
	{
		id = "df-prof",
		key = "DF:Prof.",
		group = RewardsGroup.DARKMOON_EVENT,
		description = "Darkmoon Faire Profession Quests",
		minimumLevel = 1,
		unlockEvent = 479,
		timeLeft = "end-of-event",
		entries = {
			{
				quest = 0,
				questPool = {
					29506, -- A Fizzy Fusion
					29507, -- Fun for the Little Ones
					29508, -- Baby Needs Two Pair of Shoes
					29509, -- Putting the Crunch in the Frog
					29510, -- Putting Trash to Good Use
					29511, -- Talkin' Tonks
					29513, -- Spoilin' for Salty Sea Dogs
					29514, -- Herbs for Healing
					29515, -- Writing the Future
					29516, -- Keeping the Faire Sparkling
					29517, -- Eye on the Prizes
					29518, -- Rearm, Reuse, Recycle
					29519, -- Tan My Hide
					29520, -- Banners, Banners Everywhere!
				},
				unlockProfession = {
					171, -- Alchemy
					794, -- Archaeology
					164, -- Blacksmithing
					185, -- Cooking
					333, -- Enchanting
					202, -- Engineering
					356, -- Fishing
					182, -- Herbalism
					773, -- Inscription
					755, -- Jewelcrafting
					165, -- Leatherworking
					186, -- Mining
					393, -- Skinning
					197, -- Tailoring
				},
			},
		},
		items = {
			{
				currency = 515, -- Darkmoon Prize Ticket
				amount = 0,
			},
			{
				name = "Profession Knownledge Points",
				texture = 3615911, -- Algrai Enchanter's Folio
				quality = Enum.ItemQuality.Artifact,
			},
		},
	},
	{
		id = "df-daily",
		key = "DF:Daily",
		group = RewardsGroup.DARKMOON_EVENT,
		description = "Darkmoon Faire Daily Quests",
		minimumLevel = 1,
		unlockEvent = 479,
		pick = 10,
		entries = {
			{ quest = 29434 }, -- Tonk Commander
			{ quest = 29436 }, -- The Humanoid Cannonball
			{ quest = 29438 }, -- He Shoots, He Scores!
			{ quest = 29455 }, -- Target: Turtle
			{ quest = 29463 }, -- It's Hammer Time
			{ quest = 32175 }, -- Darkmoon Pet Battle!/Darkmoon Pet Supplies
			{ quest = 36471 }, -- A New Darkmoon Challenger!/Greater Darkmoon Pet Supplies
			{ quest = 36481 }, -- Firebird's Challenge
			{ quest = 37910 }, -- The Real Race
			{ quest = 37911 }, -- The Real Big Race
		},
	},
	{
		id = "df-test",
		key = "DF:Test",
		group = RewardsGroup.DARKMOON_EVENT,
		minimumLevel = 1,
		unlockEvent = 479,
		timeLeft = "end-of-event",
		entries = {
			{ quest = 29433 }, -- Test Your Strength
		},
	},
}
