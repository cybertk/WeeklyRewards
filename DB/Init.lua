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
				table.insert(self.all, reward)
			end
		end
	end

	return self.all
end
