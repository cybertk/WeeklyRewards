local _, namespace = ...

local L = namespace.L

local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards

local Utils = namespace.Utils

WeeklyRewardsTrackingButtonMixin = {}

function WeeklyRewardsTrackingButtonMixin:QueueRedraw()
	self.pendingRedraw = true
end

function WeeklyRewardsTrackingButtonMixin:FlushPendingRedraw()
	if not self.pendingRedraw then
		return
	end
	self.pendingRedraw = nil
	namespace.GUIMain:Redraw()
end

function WeeklyRewardsTrackingButtonMixin:OnMenuClosed(menu, closeReason)
	DropdownButtonMixin.OnMenuClosed(self, menu, closeReason)
	self:FlushPendingRedraw()
end

function WeeklyRewardsTrackingButtonMixin:OnLoad()
	self:SetupMenu(function(_, rootMenu)
		-- local main = namespace.GUIMain
		local activeRewards = ActiveRewards.Get()

		self:AddCharacterInfoFilterToMenu(rootMenu)

		local groups, inactiveGroups = activeRewards:GetAllCandidates()

		rootMenu:CreateTitle(REWARDS)
		self:AddRewardsFilterToMenu(rootMenu, groups, true)

		rootMenu:CreateTitle(LFG_LIST_LEGACY)
		for i = LE_EXPANSION_SHADOWLANDS, LE_EXPANSION_LEVEL_CURRENT - 1 do
			local groups = activeRewards:GetAllCandidatesByExpansion(i)
			if groups then
				local button = rootMenu:CreateButton(_G["EXPANSION_NAME" .. i])
				self:AddRewardsFilterToMenu(button, groups)
			end
		end

		rootMenu:CreateDivider()
		rootMenu:CreateTitle(GARRISON_FOLLOWER_INACTIVE)
		self:AddRewardsFilterToMenu(rootMenu, inactiveGroups, true, GRAY_FONT_COLOR)
	end)
end

function WeeklyRewardsTrackingButtonMixin:OnEnter()
	self.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
	Utils:SetBackgroundColor(self, 1, 1, 1, 0.05)
	namespace.GUIMain:SetTooltipOwner(GameTooltip, self)
	GameTooltip:SetText(L["columns_button_tooltip"], 1, 1, 1, 1, true)
	GameTooltip:AddLine(L["columns_button_description"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:Show()
end

function WeeklyRewardsTrackingButtonMixin:OnLeave()
	self.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
	Utils:SetBackgroundColor(self, 1, 1, 1, 0)
	GameTooltip:Hide()
end

function WeeklyRewardsTrackingButtonMixin:GenerateRewardTooltip(candidate)
	local activeRewards = ActiveRewards.Get()

	return function(tooltip)
		if candidate.description then
			GameTooltip_AddNormalLine(tooltip, Util:ColoredText(candidate.description))
		elseif #candidate.entries > 1 then
			GameTooltip_AddNormalLine(tooltip, L["candidate_from_following_quests"])
			for _, entry in ipairs(candidate.entries) do
				GameTooltip_AddHighlightLine(tooltip, Util:Text("{quest:%d}", entry.quest), false)
			end
		elseif candidate.entries[1].questPool then
			local entry = candidate.entries[1]

			GameTooltip_AddNormalLine(tooltip, Util:Text(L["candidate_from_quest_format"], (entry.quest == 0 or not entry.quest) and "0:0" or entry.quest))
			GameTooltip_AddBlankLineToTooltip(tooltip)
			GameTooltip_AddHighlightLine(tooltip, L["candidate_one_of_following_quests"])
			for _, quest in ipairs(entry.questPool) do
				GameTooltip_AddHighlightLine(tooltip, Util:Text("{quest:%d}", quest), false)
			end
		else
			GameTooltip_AddNormalLine(tooltip, L["candidate_from_quest"])
			GameTooltip_AddHighlightLine(tooltip, Util:Text("{quest:%d}", candidate.entries[1].quest), false)
		end

		if not activeRewards:IsCandidateActive(candidate.id) then
			GameTooltip_AddBlankLineToTooltip(tooltip)
			GameTooltip_AddDisabledLine(tooltip, L["candidate_not_active"])
		end
	end
end

function WeeklyRewardsTrackingButtonMixin:AddCharacterInfoFilterToMenu(rootMenu)
	local main = namespace.GUIMain
	if not main.columns then
		return
	end

	local hidden = WeeklyRewards.db.global.main.hiddenColumns

	local button = rootMenu:CreateButton(CHARACTER_BUTTON)
	for _, column in ipairs(main.columns) do
		if column.reward == nil and not column.tracking then
			button:CreateCheckbox(column.name, function()
				return not hidden[column.name]
			end, function(columnName)
				hidden[columnName] = not hidden[columnName]
				self:QueueRedraw()
			end, column.name)
		end
	end

	rootMenu:CreateDivider()
end

function WeeklyRewardsTrackingButtonMixin:AddRewardsFilterToMenu(rootMenu, groups, shouldCreateSubmenu, color)
	local activeRewards = ActiveRewards.Get()

	for name, candidates in pairs(groups) do
		local button = rootMenu

		if name == "" then
			-- candidiate w/o group
		elseif not shouldCreateSubmenu then
			button:CreateTitle(name)
		else
			button = rootMenu:CreateCheckbox((color or WHITE_FONT_COLOR):WrapTextInColorCode(name), function()
				return not activeRewards:IsGroupExcluded(name)
			end, function()
				activeRewards:ToggleExclusionByGroup(name)
				self:QueueRedraw()
			end)
		end

		for _, candidate in ipairs(candidates) do
			local rewardColor = color or activeRewards:IsCandidateActive(candidate.id) and WHITE_FONT_COLOR or GRAY_FONT_COLOR

			local checkbox = button:CreateCheckbox(rewardColor:WrapTextInColorCode(candidate.key), function()
				return not activeRewards:IsCandidateExcluded(candidate.id)
			end, function()
				activeRewards:ToggleExclusion(candidate.id)
				if not activeRewards:IsCandidateExcluded(candidate.id) then
					local character = CharacterStore.Get():CurrentPlayer()

					character:Scan(activeRewards)
					character:UpdateProgress()
				end
				self:QueueRedraw()
			end)

			checkbox:SetTooltip(self:GenerateRewardTooltip(candidate))
		end

		if not shouldCreateSubmenu and name ~= "" then
			button:QueueDivider()
		end
	end
end
