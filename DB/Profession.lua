local _, namespace = ...

local RewardsGroup = {
	PROFESSION = TRADE_SKILLS,
}

local function range(start, stop)
	local t = {}
	for i = start, stop, 1 do
		table.insert(t, i)
	end
	return t
end

namespace.DB.rewardCandidiates["PROFESSION"] = {
	{
		id = "mn-pquests",
		key = "|A:Profession:16:16:-5:0|aQuests",
		group = RewardsGroup.PROFESSION,
		description = "Weekly Profession Quests",
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = { { questPool = range(93690, 93714), maxCompletion = 2 } },
	},
	{
		id = "mn-pdrops",
		key = "|A:Profession:16:16:-5:0|aDrops",
		group = RewardsGroup.PROFESSION,
		description = "Weekly Profession Knowledge Drops from Treasures around the World",
		minimumLevel = 80,
		timeLeft = C_DateAndTime.GetSecondsUntilWeeklyReset,
		entries = {
			{
				questPool = { 93530, 93531, 93540, 93541, 93528, 93529, 93542, 93543, 93534, 93535, 93532, 93533, 93539, 93538, 93536, 93537 },
				items = { 259190, 259191, 259200, 259201, 259188, 259189, 259202, 259203, 259194, 259195, 259192, 259193, 259198, 259199, 259196, 259197 },
				unlockProfession = { 164, 164, 165, 165, 171, 171, 197, 197, 202, 202, 333, 333, 755, 755, 773, 773 },
			},
		},
	},
}
