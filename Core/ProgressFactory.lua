local _, ns = ...

local ProgressFactory = {}

local PROGRESS_TYPE = {
	Quest = 0,
	GreatVault = 1,
	LFG = 2,
	CyrceCirclet = 3,
	GildedStash = 4,
	Encounter = 5,
}

function ProgressFactory:Create(type, o)
	local class = ns.RewardProgress

	for k, v in pairs(PROGRESS_TYPE) do
		if type == v then
			class = ns[k .. "Progress"]
		end
	end

	local instance = class:New(o)
	instance.type = type

	return instance
end

ns.ProgressFactory = ProgressFactory
