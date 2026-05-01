local _, namespace = ...

namespace.DB.rewardCandidiates["bonus"] = {
	{
		id = "bonus",
		key = "BonusEvent",
		description = "Weekly Bonus Event provides a weekly quest that rewards equipment."
			.. "|n|nThese events rotate on a set schedule, including:"
			.. "|n- {quest:93593}" -- A Call to Battle
			.. "|n- {quest:93595}" -- A Call to Delves
			.. "|n- {quest:93600}" -- The Arena Calls
			.. "|n- {quest:93605}" -- The World Awaits
			.. "",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 93593 }, -- A Call to Battle
			{ quest = 93595, unlockAura = 471521 }, -- A Call to Delves
			{ quest = 93598, unlockAura = 225787 }, -- Emissary of War
			{ quest = 93600, unlockAura = 186401 }, -- The Arena Calls
			{ quest = 93605, unlockAura = 225788 }, -- The World Awaits
		},
	},
}
