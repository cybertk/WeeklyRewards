local _, namespace = ...

namespace.DB.rewardCandidiates["bonus"] = {
	{
		id = "bonus",
		key = "Bonus",
		description = "Weekly Bonus Event provides a passive bonus and a weekly quest that rewards equipment.|n"
			.. "These events rotate on a set schedule, including:|n"
			.. "- {quest:93593}|n" -- A Call to Battle
			.. "- {quest:93595}|n" -- A Call to Delves
			.. "",
		minimumLevel = 10,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 93593 }, -- A Call to Battle
			{ quest = 93595, unlockAura = 471521 }, -- A Call to Delves
		},
	},
}
