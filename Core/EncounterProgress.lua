local _, namespace = ...

local Util = namespace.Util

local EncounterProgress = namespace.RewardProgress:New()
namespace.EncounterProgress = EncounterProgress

function GetDifficultyNames(difficulties)
	local names = {}
	local isLegacy = false

	for _, difficultyID in ipairs(difficulties) do
		local name = GetDifficultyInfo(difficultyID)
		table.insert(names, name)
	end

	if #names > 0 and IsLegacyDifficulty(difficulties[1]) then
		local aggregated = names[1]

		for i = 2, #names do
			aggregated = aggregated .. " / " .. names[i]
		end

		names = { aggregated }
		isLegacy = true
	end

	return names, isLegacy
end

function EncounterProgress:_UpdateRecords()
	if #self.pendingObjectives ~= 1 then
		Util:Debug("Skipping dungeon: " .. #self.pendingObjectives)
		return
	end

	self.records = {}
	self.position = 0
	self.total = 0

	local objective = self.pendingObjectives[1]

	if objective.mount and C_MountJournal.GetMountInfoByID(objective.mount) and select(11, C_MountJournal.GetMountInfoByID(objective.mount)) then
		local name, _, icon, _, _, _, _, _, _, _, collected = C_MountJournal.GetMountInfoByID(objective.mount)
		if collected then
			self.fulfilledObjectives = self.pendingObjectives
			self.pendingObjectives = {}

			self:_AddRecord({ text = format("|T%d:13|t %s", icon, name), fulfilled = 1, required = 1 })

			return
		end
	end

	local difficultyNames, isLegacy = GetDifficultyNames(objective.difficulties)

	for _, encounterID in ipairs(objective.encounters) do
		local name, description, journalEncounterID, rootSectionID, link, journalInstanceID, dungeonEncounterID, instanceID = EJ_GetEncounterInfo(encounterID)

		local claimedDifficulties = Util.SavedInstances:FindByBossName(name, instanceID)

		for i, difficultyName in ipairs(difficultyNames) do
			local difficultyID = objective.difficulties[i]
			local fulfilled = claimedDifficulties and (isLegacy or tContains(claimedDifficulties, difficultyID))

			self:_AddRecord({ text = format("%s (%s)", name, difficultyName), fulfilled = fulfilled and 1 or 0, required = 1 })
		end
	end

	if self.position == self.total then
		self.fulfilledObjectives = self.pendingObjectives
		self.pendingObjectives = {}
	end
end
