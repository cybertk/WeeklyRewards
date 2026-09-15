local _, namespace = ...

local L = namespace.L
local Utils = namespace.Utils
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards

WeeklyRewardsTrackingButtonMixin = {}

function WeeklyRewardsTrackingButtonMixin:OnLoad()
	self:SetupMenu(function(_, rootMenu)
		local main = namespace.GUIMain
		if not main.columns then
			return
		end

		local hidden = WeeklyRewards.db.global.main.hiddenColumns
		local activeRewards = ActiveRewards.Get()

		for _, column in ipairs(main.columns) do
			if column.reward == nil then
				rootMenu:CreateCheckbox(column.name, function()
					return not hidden[column.name]
				end, function(columnName)
					hidden[columnName] = not hidden[columnName]
					main:Redraw()
				end, column.name)
			end
		end

		local groups, inactiveGroups = activeRewards:GetAllCandidates()
		rootMenu:CreateDivider()
		rootMenu:CreateTitle(REWARDS)

		self:AddRewardsFilterToMenu(rootMenu, groups)
		rootMenu:CreateTitle(LFG_LIST_LEGACY)
		for i = 1, LE_EXPANSION_LEVEL_CURRENT - 1 do
			local expansionGroups = activeRewards:GetAllCandidatesByExpansion(i)
			if expansionGroups then
				local button = rootMenu:CreateButton(_G["EXPANSION_NAME" .. i])
				self:AddRewardsFilterToMenu(button, expansionGroups, true)
			end
		end
		rootMenu:CreateDivider()
		rootMenu:CreateTitle(GARRISON_FOLLOWER_INACTIVE)
		self:AddRewardsFilterToMenu(rootMenu, inactiveGroups, false, true)
	end)
end

function WeeklyRewardsTrackingButtonMixin:AddRewardsFilterToMenu(rootMenu, groups, isLegacy, isInactive)
	local activeRewards = ActiveRewards.Get()

	for name, candidates in pairs(groups) do
		local button = rootMenu

		if name == "" then
		elseif isLegacy then
			button:CreateTitle(name)
		else
			local color = isInactive and GRAY_FONT_COLOR or WHITE_FONT_COLOR
			button = rootMenu:CreateCheckbox(color:WrapTextInColorCode(name), function()
				return not activeRewards:IsGroupExcluded(name)
			end, function()
				activeRewards:ToggleExclusionByGroup(name)
				namespace.GUIMain:Redraw()
			end)
		end

		for _, candidate in ipairs(candidates) do
			local color = activeRewards:IsActive(candidate.id) and WHITE_FONT_COLOR or GRAY_FONT_COLOR
			button:CreateCheckbox(color:WrapTextInColorCode(candidate.key), function()
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
		end

		if isLegacy and name ~= "" then
			button:QueueDivider()
		end
	end
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
