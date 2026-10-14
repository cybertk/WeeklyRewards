local _, namespace = ...

namespace.DB.rewardCandidiates["vault"] = {
	{
		id = "vault",
		key = "GreatVault",
		atlas = "greatVault-whole-normal",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 1 },
		},
	},
}
