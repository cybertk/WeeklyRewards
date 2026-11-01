local _, namespace = ...

namespace.DB.rewardCandidiates["vault"] = {
	{
		id = "vault",
		key = "GreatVault",
		description = "Great Vault rewards. Choose 1 piece of loot from a pool of up to 9 items.|n|n"
			.. "The item level depends on your highest runs of the week.|n"
			.. "You can also select {item:258556} instead of loot.",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 1 },
		},
	},
}
