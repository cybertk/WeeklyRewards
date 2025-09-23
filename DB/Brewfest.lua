local _, namespace = ...

local RewardsGroup = {
	BREWFEST_EVENT = "Brewfest",
}

namespace.DB.rewardCandidiates["brewfest"] = {
	{
		id = "brew-main",
		key = "Brew:Main",
		group = RewardsGroup.BREWFEST_EVENT,
		description = "One-time Mainline Quests",
		minimumLevel = 1,
		unlockEvent = 372, -- Brewfest
		timeLeft = "end-of-event",
		pick = 7,
		entries = {
			{ quest = 11118, questPool = { 11118, 11120 }, factionMask = { 1, 2 } }, -- Pink Elekks On Parade
			{ quest = 11318, questPool = { 11318, 11409 } }, -- Now This is Ram Racing... Almost.
			{ quest = 11122, questPool = { 11122, 11412 } }, -- There and Back Again
			{ quest = 12491, questPool = { 12491, 12492 }, factionMask = { 1, 2 } }, -- Direbrew's Dire Brew
			{ quest = 12022, questPool = { 12022, 12191 } }, -- Chug and Chuck!
			{ quest = 56764, questPool = { 56764, 56748 } }, -- Brewfest Chowdown
			{ quest = 90870, questPool = { 90870, 91067 } }, -- Gathering the Grub
		},
	},
	{
		id = "brew-daily",
		key = "Brew:Daily",
		group = RewardsGroup.BREWFEST_EVENT,
		description = "Daily Quests",
		minimumLevel = 10,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		unlockEvent = 372,
		pick = 4,
		entries = {
			{
				quest = 56322,
				maxCompletion = 1,
				questPool = {
					56372,
					56715, -- Hozen Totem
					56341,
					56716, -- Direbrew Cog
				},
				factionMask = { 1, 2, 1, 2, 1, 2 },
			}, -- Invasion
			{ quest = 87289, questPool = { 87289, 87341 } }, -- Barreling Down
			{ quest = 87347, questPool = { 87347, 87349 } }, -- Bubbling Brews
			{
				quest = 11407,
				maxCompletion = 1,
				questPool = {
					11407, -- Bark for Drohn's Distillery!
					11408, -- Bark for T'chali's Voodoo Brewery!
					11293, -- Bark for the Barleybrews!
					11294, -- Bark for the Thunderbrews!
				},
				factionMask = { 2, 2, 1, 1 },
			},
		},
	},
	{
		id = "brew-boss",
		key = "Brew:Boss",
		group = RewardsGroup.BREWFEST_EVENT,
		description = "Daily Blackrock Depths Dungeon Boss: Coren Direbrew",
		minimumLevel = 10,
		unlockEvent = 372,
		timeLeft = C_DateAndTime.GetSecondsUntilDailyReset,
		entries = {
			{ quest = 287 + 9000000, progressType = 2, dungeon = 287 },
		},
		items = {
			{ item = 117393, amount = 1 },
		},
	},
	{
		id = "brew-di",
		key = "BarTab:DI",
		group = RewardsGroup.BREWFEST_EVENT,
		description = "Donate to taverns across the Dragon Isles to cover the tab!",
		minimumLevel = 1,
		timeLeft = "end-of-event",
		unlockEvent = 372,
		pick = 12,
		entries = {
			{ quest = 77153, name = "{quest:77153}: {map:2112}" },
			{ quest = 77155, name = "{quest:77155}: {map:2025}" },
			{ quest = 77747, name = "{quest:77747}: {map:2025}" },
			{ quest = 77095, name = "{quest:77095}: {map:2022}" },
			{ quest = 76531, name = "{quest:76531}: {map:2022}" },
			{ quest = 77744, name = "{quest:77744}: {map:2022}" },
			{ quest = 77745, name = "{quest:77745}: {map:2023}" },
			{ quest = 77152, name = "{quest:77152}: {map:2023}" },
			{ quest = 77099, name = "{quest:77099}: {map:2023}" },
			{ quest = 77097, name = "{quest:77097}: {map:2024}" },
			{ quest = 77096, name = "{quest:77096}: {map:2024}" },
			{ quest = 77746, name = "{quest:77746}: {map:2024}" },
		},
	},
	{
		id = "brew-ka",
		key = "BarTab:KA",
		group = RewardsGroup.BREWFEST_EVENT,
		description = "Donate to taverns across the Khaz Algar to cover the tab!",
		minimumLevel = 1,
		timeLeft = "end-of-event",
		unlockEvent = 372,
		pick = 10,
		entries = {
			{ quest = 84305, name = "{quest:84305}: {map:2339}" },
			{ quest = 84306, name = "{quest:84306}: {map:2248}" },
			{ quest = 84307, name = "{quest:84307}: {map:2214}" },
			{ quest = 84308, name = "{quest:84308}: {map:2214}" },
			{ quest = 84310, name = "{quest:84310}: {map:2215}" },
			{ quest = 84311, name = "{quest:84311}: {map:2215}" },
			{ quest = 84313, name = "{quest:84313}: {map:2216}" },
			{ quest = 84314, name = "{quest:84314}: {map:2213}" },
			{ quest = 84315, name = "{quest:84315}: {map:2255}" },
			{ quest = 84316, name = "{quest:84316}: {map:2255}" },
		},
	},
}
