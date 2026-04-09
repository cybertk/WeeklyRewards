local _, namespace = ...

namespace.DB.rewardCandidiates["bonus"] = {
	{
		id = "bonus",
		key = "BonusEvent",
		description = "Weekly Bonus Event provides a weekly quest that rewards equipment."
			.. "|n|nThese events rotate on a set schedule, including:"
			.. "|n- {quest:93593}" -- A Call to Battle
			.. "|n- {quest:93595}" -- A Call to Delves
			.. "|n- {quest:93598}" -- Emissary of War
			.. "",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 93593 }, -- A Call to Battle
			{ quest = 93595, unlockAura = 471521 }, -- A Call to Delves
			{ quest = 93598, unlockAura = 225787 }, -- Emissary of War
		},
	},
}
