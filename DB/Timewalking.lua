local _, namespace = ...

local RewardsGroup = {
	TIMEWALKING_EVENTS = "Timewalking Events",
}

namespace.DB.rewardCandidiates["timewalking"] = {
	{
		id = "tw-dd",
		key = "TW:Raid",
		description = "Timewalking Raid",
		group = RewardsGroup.TIMEWALKING_EVENTS,
		minimumLevel = 30,
		entries = {
			{ quest = 82817, unlockAura = 452307 }, -- Disturbance Detected: Blackrock Depths
			{ quest = 47523, unlockAura = 335148 }, -- Disturbance Detected: Black Temple
			{ quest = 50316, unlockAura = 335149 }, -- Disturbance Detected: Ulduar
			{ quest = 57637, unlockAura = 335150 }, -- Disturbance Detected: Firelands
		},
	},
	{
		id = "tw-lfd",
		key = "TW:LFD",
		description = "Timewalking Dungeon",
		group = RewardsGroup.TIMEWALKING_EVENTS,
		minimumLevel = 1,
		entries = {
			{ quest = 83285, items = { 225348 }, unlockAura = 452307 }, -- [Classic] - [Quest] The Ancient Scroll - [Aura] Sign of the Past
			{ quest = 40168, items = { 129747 }, unlockAura = 335148 }, -- [TBC] - [Quest] The Swirling Vial - [Aura] Sign of the Twisting Nether
			{ quest = 40173, items = { 129928 }, unlockAura = 335149 }, -- [WotLK] - [Quest] The Unstable Prism - [Aura] Sign of the Scourge
			{
				quest = 40786,
				items = {
					133377,
					133378, -- Smoldering Timewarped Ember
				},
				unlockAura = 335150, -- Sign of the Destroyer
				questPool = {
					40786, --[Cata] Horde: The Smoldering Ember
					40787, --[Cata] Alliance: The Smoldering Ember
				},
				factionMask = { 2, 1 },
			}, -- [Cata]
			{ quest = 45563, items = { 143776 }, unlockAura = 335151 }, -- [MoP] The Shrouded Coin - [Aura] Sign of the Mists
			{
				quest = 55498,
				items = {
					167921,
					167922,
				},
				unlockAura = 335150, -- Sign of Iron
				questPool = {
					55498, --[WoD] Alliance: The Shimmering Crystal
					55499, --[WoD] Horde: The Shimmering Crystal er
				},
				factionMask = { 1, 2 },
			}, -- [WoD]
			{ quest = 64710, items = { 187611 }, unlockAura = 359082 }, -- [Legion] Whispering Felflame Crystal - [Aura] Sign of the Legion
		},
	},
}
