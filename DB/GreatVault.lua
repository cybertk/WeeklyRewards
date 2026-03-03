local _, namespace = ...

namespace.DB.rewardCandidiates["vault"] = {
	{
		id = "vault",
		key = "GreatVault",
		description = "Great Valut Rewards that provides you with 1 piece of loot from a pool of up to 9 items. |n|n"
			.. "The item level of rewards depends on your highest runs of the week.|n"
			.. "You could also select the |cffa335ee[Algari Token of Merit]|r instead of loots.",
		minimumLevel = 90,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{ quest = 0, progressType = 1 },
		},
	},
}
