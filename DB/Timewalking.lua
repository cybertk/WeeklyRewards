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
		rollover = true,
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
		rollover = true,
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
				unlockAura = 335152, -- Sign of Iron
				questPool = {
					55498, --[WoD] Alliance: The Shimmering Crystal
					55499, --[WoD] Horde: The Shimmering Crystal er
				},
				factionMask = { 1, 2 },
			}, -- [WoD]
			{ quest = 64710, items = { 187611 }, unlockAura = 359082 }, -- [Legion] Whispering Felflame Crystal - [Aura] Sign of the Legion
			{
				quest = 89223,
				items = {
					238790, -- Alliance: Remnant of Azeroth
					238791, -- Horde: Remnant of Azeroth
				},
				unlockAura = 1223878, -- Sign of the Azeroth
				questPool = {
					89222, -- Alliance: Remnant of Azeroth
					89223, -- Horde: Remnant of Azeroth
				},
				factionMask = { 1, 2 },
			}, -- [BfA]
			{ quest = 92650, items = { 253517 }, unlockAura = 1256081 }, -- [SL] - [Quest] The Flickering Anima - [Aura] Sign of Azeroth
		},
	},
	{
		id = "tw-path",
		key = "TW:Path",
		group = RewardsGroup.TIMEWALKING_EVENTS,
		minimumLevel = 80,
		entries = {
			{ quest = 86731, unlockAura = 452307 }, -- An Original Path Through Time - Clapths
			{ quest = 83363, unlockAura = 335148 }, -- A Burning Path Through Time - TBC
			{ quest = 83365, unlockAura = 335149 }, -- A Frozen Path Through Time - WLK
			{ quest = 83359, unlockAura = 335150 }, -- A Shattered Path Through Time - Cat
			{ quest = 83362, unlockAura = 335151 }, -- A Shrouded Path Through Time - MoP
			{ quest = 83364, unlockAura = 335152 }, -- A Savage Path Through Time - WoD
			{ quest = 83360, unlockAura = 359082 }, -- A Fel Path Through Time - Legion
			{ quest = 88805, unlockAura = 1223878 }, -- A Scarred Path Through Time - BFA
			{ quest = 92649, unlockAura = 1256081 }, -- A Shadowed Path Through Time - SL
		},
	},
}
