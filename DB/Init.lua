local addonName, namespace = ...

local DB = {
	rewardCandidiates = {},
	all = {},
	currencyCandidiates = {},
	allCurrencies = {},
}
namespace.DB = DB

function DB:GetAllCandidates()
	if #self.all == 0 then
		for category, rewards in pairs(self.rewardCandidiates) do
			for _, reward in ipairs(rewards) do
				reward.expansion = type(category) == "number" and category or nil
				table.insert(self.all, reward)
			end
		end
	end

	return self.all
end

function DB:GetAllCurrencies()
	if #self.allCurrencies == 0 then
		for _, currencyID in ipairs(self.currencyCandidiates) do
			table.insert(self.allCurrencies, currencyID)
		end
	end

	return self.allCurrencies
end
