local _, namespace = ...

local Util = namespace.Util

local LFGProgress = namespace.RewardProgress:New()
namespace.LFGProgress = LFGProgress

function LFGProgress:_UpdateRecords()
	if #self.pendingObjectives ~= 1 then
		Util:Debug("Skipping dungeon: " .. #self.pendingObjectives)
		return
	end

	self.records = {}
	self.position = 0
	self.total = 0

	-- Update records: Support 1 dungeon only
	local dungeon = self.pendingObjectives[1].dungeon
	local fulfilled = select(1, GetLFGDungeonRewards(dungeon)) and 1 or 0

	self:_AddRecord({
		text = format("%d / 1 ", fulfilled) .. GetLFGDungeonInfo(dungeon) or "Loading",
		fulfilled = fulfilled,
		required = 1,
	})

	if fulfilled == 1 then
		self.fulfilledObjectives = self.pendingObjectives
		self.pendingObjectives = {}
	end
end
