local addonName, namespace = ...

local DB = {
	rewardCandidiates = {},
	all = {},
}
namespace.DB = DB

function DB:GetAllCandidates()
	if #self.all == 0 then
		for category, rewards in pairs(self.rewardCandidiates) do
			for _, reward in ipairs(rewards) do
				reward.expansion = type(category) == "number" and category or nil

				-- Localization key is reward:<id>. An id of "<id>:<arg>" is formatted in, for example {map:%s}.
				local id, arg1 = (":"):split(reward.id)
				local description = namespace.L["reward:" .. id]
				-- if description and arg1 then
				-- 	description = description:format(arg1)
				-- end

				if description then
					-- description = description:format(arg1)
					reward.description = reward.description and reward.description .. "|n|n" .. description:format(arg1) or description:format(arg1)
				end

				table.insert(self.all, reward)
			end
		end
	end

	return self.all
end
