local _, namespace = ...

namespace.DB.rewardCandidiates["bonus"] = {
	{
		id = "bonus", -- Weekly Bonus Event
		key = "BonusEvent",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 93593, unlockAura = 186403 }, -- A Call to Battle
			{ quest = 93595, unlockAura = 471521 }, -- A Call to Delves
			{ quest = 93598, unlockAura = 225787 }, -- Emissary of War
			{ quest = 93600, unlockAura = 186401 }, -- The Arena Calls
			{ quest = 93605, unlockAura = 225788 }, -- The World Awaits
		},
	},
}
