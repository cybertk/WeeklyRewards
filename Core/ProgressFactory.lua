local _, namespace = ...

local ProgressFactory = {}
namespace.ProgressFactory = ProgressFactory

local RewardProgress = namespace.RewardProgress
local GreatVaultProgress = namespace.GreatVaultProgress

local PROGRESS_TYPE = {
	Quest = 0,
	GreatValut = 1,
}

function ProgressFactory:Create(type, o)
	local instance

	if type == PROGRESS_TYPE.GreatValut then
		instance = GreatVaultProgress:New(o)
	else
		instance = RewardProgress:New(o)
	end

	instance.type = type

	return instance
end
