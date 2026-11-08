local _, namespace = ...

namespace.DB.rewardCandidiates["vault"] = {
	{
		id = "vault",
		key = "GreatVault",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 1 },
		},
	},
}
