local _, namespace = ...

local L = namespace.L
local Flags = namespace.Flags
local Settings = namespace.Settings

local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards
local Reward = namespace.Reward

WeeklyRewardsTrackingButtonMixin = CreateFromMixins(namespace.TitleBarButtonMixin)

function WeeklyRewardsTrackingButtonMixin:OnLoad()
	namespace.TitleBarButtonMixin.OnLoad(self)

	self.tooltip = L["columns_button_tooltip"]
	self.tooltipText = L["columns_button_description"]

	self:SetupMenu(function(_, rootMenu)
		self:AddCharacterInfoFilterToMenu(rootMenu)

		local activeRewards = ActiveRewards.Get()
		local groups, inactiveGroups = activeRewards:GetAllCandidates()

		activeRewards:Update()

		rootMenu:CreateTitle(REWARDS)
		self:AddRewardsFilterToMenu(rootMenu, groups, true)

		rootMenu:CreateTitle(LFG_LIST_LEGACY)
		for i = LE_EXPANSION_SHADOWLANDS, LE_EXPANSION_LEVEL_CURRENT - 1 do
			local groups = activeRewards:GetAllCandidatesByExpansion(i)
			if groups then
				local button = rootMenu:CreateButton(_G["EXPANSION_NAME" .. i])
				self:AddRewardsFilterToMenu(button, groups, false, WHITE_FONT_COLOR)
			end
		end

		rootMenu:CreateDivider()
		rootMenu:CreateTitle(GARRISON_FOLLOWER_INACTIVE)
		self:AddRewardsFilterToMenu(rootMenu, inactiveGroups, true, GRAY_FONT_COLOR)
	end)
end

function WeeklyRewardsTrackingButtonMixin.UpdateRewardTooltip(tooltip, description)
	local candidate = description.candidate
	local activeRewards = ActiveRewards.Get()

	if candidate.description then
		GameTooltip_AddNormalLine(tooltip, Util:ColoredText(candidate.description))
	elseif #candidate.entries > 1 then
		GameTooltip_AddNormalLine(tooltip, L["candidate_from_following_quests"]:format(REWARDS))
		for _, entry in ipairs(candidate.entries) do
			GameTooltip_AddHighlightLine(tooltip, entry:GetDescription(), false)
		end
	elseif candidate.entries[1].questPool then
		local entry = candidate.entries[1]

		if entry.quest then
			GameTooltip_AddNormalLine(tooltip, Util:Text(L["candidate_from_quest_format"], entry.quest), false)
			GameTooltip_AddBlankLineToTooltip(tooltip)
		end
		GameTooltip_AddNormalLine(tooltip, L["candidate_one_of_following_quests"])
		for _, quest in ipairs(entry.questPool) do
			GameTooltip_AddHighlightLine(tooltip, Util:Text("{quest:%d}", quest), false)
		end
	elseif candidate.entries[1].pois then
		local entry = candidate.entries[1]
		local rewards = REWARDS
		if entry.items then
			rewards = ""
			for _, item in ipairs(entry.items) do
				rewards = ("%s {item:%d}"):format(rewards, item)
			end
		end

		GameTooltip_AddNormalLine(tooltip, L["candidate_from_following_quests"]:format(Util:ColoredText(rewards)))
		for _, poi in ipairs(entry.pois) do
			GameTooltip_AddHighlightLine(tooltip, Util:Text("{poi:%d}", poi), false)
		end
	else
		GameTooltip_AddNormalLine(tooltip, L["candidate_from_quest"])
		GameTooltip_AddHighlightLine(tooltip, Util:Text("{quest:%d}", candidate.entries[1].quest), false)
	end

	local inactiveColor = nil
	if candidate.expansion then
		inactiveColor = not Reward:FromCandidate(candidate):HasConfirmed() and RED_FONT_COLOR or nil
	elseif not activeRewards:IsCandidateActive(candidate.id) then
		inactiveColor = GRAY_FONT_COLOR
	end

	if inactiveColor then
		GameTooltip_AddBlankLineToTooltip(tooltip)
		GameTooltip_AddColoredLine(tooltip, L["candidate_not_active"], inactiveColor)
	end

	Flags:Clear(description.flag, candidate.id)
end

function WeeklyRewardsTrackingButtonMixin:AddCharacterInfoFilterToMenu(rootMenu)
	local main = namespace.GUIMain
	if not main.columns then
		return
	end

	local hidden = Settings:Get("hiddenColumns")

	local button = rootMenu:CreateButton(CHARACTER_BUTTON)
	for _, column in ipairs(main.columns) do
		if column.reward == nil and column.key then
			button:CreateCheckbox(column.name, function()
				return not hidden[column.name]
			end, function(columnName)
				hidden[columnName] = not hidden[columnName]
				main:Redraw()
			end, column.name)
		end
	end

	rootMenu:CreateDivider()
end

function WeeklyRewardsTrackingButtonMixin:AddRewardsFilterToMenu(rootMenu, groups, shouldCreateSubmenu, color)
	local activeRewards = ActiveRewards.Get()

	for group, candidates in pairs(groups) do
		local button = rootMenu
		local name = Util:ResolveTags(group)

		if group == "" then
			-- candidiate w/o group
		elseif not shouldCreateSubmenu then
			button:CreateTitle(name)
		else
			button = rootMenu:CreateCheckbox((color or WHITE_FONT_COLOR):WrapTextInColorCode(Flags:Format(name, self.flag, candidates, "id")), function()
				return not activeRewards:IsGroupExcluded(group)
			end, function()
				activeRewards:ToggleExclusionByGroup(group)
				namespace.GUIMain:Redraw()
			end)
		end

		for _, candidate in ipairs(candidates) do
			local rewardColor = color or activeRewards:IsCandidateActive(candidate.id) and WHITE_FONT_COLOR or GRAY_FONT_COLOR

			local checkbox = button:CreateCheckbox(rewardColor:WrapTextInColorCode(Flags:Format(candidate.key, self.flag, candidate.id)), function()
				return not activeRewards:IsCandidateExcluded(candidate.id)
			end, function()
				activeRewards:ToggleExclusion(candidate.id)
				if not activeRewards:IsCandidateExcluded(candidate.id) then
					local character = CharacterStore.Get():CurrentPlayer()

					character:Scan(activeRewards)
					character:UpdateProgress()
				end
				namespace.GUIMain:Redraw()
			end)

			checkbox.candidate = candidate
			checkbox.flag = self.flag
			checkbox:SetTooltip(self.UpdateRewardTooltip)
		end

		if not shouldCreateSubmenu and group ~= "" then
			button:QueueDivider()
		end
	end
end
