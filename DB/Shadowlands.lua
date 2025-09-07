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
		pick = 1,
		entries = {
			-- {
			-- 	quest = 61981, -- Replenish the Reservoir
			-- 	unlockQuest = 61982, -- Replenish the Reservoir
			-- 	unlockUntilReset = true,
			-- },
			{ quest = 61981 },
			{ quest = 61982 },
			{ quest = 61983 },
			{ quest = 61984 },
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
		id = "sl-verayn",
		key = "Ve'rayn",
		group = RewardsGroup.SL_EVENT,
		minimumLevel = 60,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		rollover = true,
		entries = {
			{
				quest = 64513, -- Ve'rayn's Head
				items = { 187264 }, -- Ve'rayn's Head
			},
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
	{
		id = "sl-callings",
		key = "Callings",
		group = RewardsGroup.SL_EVENT,
		minimumLevel = 60,
		pick = 3,
		trackRecords = true,
		entries = {
			-- Epic Tribute Chests
			{
				quest = 60424,
				questPool = {
					60424, -- A Call to Ardenweald
					60419, -- Troubles at Home
				},
			},
			{
				quest = 60418,
				questPool = {
					60418, -- A Call to Bastion
					60425, -- Troubles at Home
				},
			},
			{
				quest = 60430,
				questPool = {
					60430, -- A Call to Maldraxxus
					60429, -- Troubles at Home
				},
			},
			{
				quest = 60434,
				questPool = {
					60434, -- A Call to Revendreth
					60432, -- Troubles at Home
				},
			},
			{ quest = 60439 }, -- Challenges in Ardenweald
			{ quest = 60442 }, -- Challenges in Bastion
			{ quest = 60447 }, -- Challenges in Maldraxxus
			{ quest = 60450 }, -- Challenges in Revendreth
			{ quest = 60454 }, -- Storm the Maw

			-- Rare Tribute Chests with special rewards
			{
				quest = 60403,
				questPool = {
					60403, -- Training in Ardenweald
					60408, -- Training Our Forces
				},
			},
			{
				quest = 60387,
				questPool = {
					60387, -- Training in Bastion
					60404, -- Training Our Forces
				},
			},
			{
				quest = 60407,
				questPool = {
					60407, -- Training in Maldraxxus
					60388, -- Training Our Forces
				},
			},
			{
				quest = 60412,
				questPool = {
					60412, -- Training in Revendreth
					60410, -- Training Our Forces
				},
			},

			-- Rare Tribute Chests
			{ quest = 60391 }, -- Aiding Ardenweald
			{ quest = 60393 }, -- Aiding Bastion
			{ quest = 60395 }, -- Aiding Maldraxxus
			{ quest = 60400 }, -- Aiding Revendreth
			{ quest = 60415 }, -- Rare Resources
		},
	},
}
