local _, namespace = ...

local L = namespace.L
local Flags = namespace.Flags
local Settings = namespace.Settings

local TitleBarButtonMixin = {}

function TitleBarButtonMixin:OnLoad()
	if self.iconAtlas then
		self.Icon:SetAtlas(self.iconAtlas, false)
		self.Icon:SetSize(self.iconWidth, self.iconHeight or self.iconWidth)
	end

	if self.flag and self.flag ~= "" then
		Flags:InvokeAndRegisterCallback(self.flag, function(isSet)
			self.Notification:SetShown(isSet)
		end)
	end
end

function TitleBarButtonMixin:OnEnter()
	self.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
	namespace.Utils:SetBackgroundColor(self, 1, 1, 1, 0.05)
	namespace.GUIMain:SetTooltipOwner(GameTooltip, self)
	GameTooltip:SetText(self.tooltip, 1, 1, 1, 1, true)
	GameTooltip:AddLine(self.tooltipText, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:Show()
end

function TitleBarButtonMixin:OnLeave()
	self.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
	namespace.Utils:SetBackgroundColor(self, 1, 1, 1, 0)
	GameTooltip:Hide()
end

function TitleBarButtonMixin.AddExtraStuffToTooltip(tooltip, description)
	local entry = description.entry

	Flags:Clear(description.flag, entry.key)
end

namespace.TitleBarButtonMixin = TitleBarButtonMixin

WeeklyRewardsSettingsButtonMixin = CreateFromMixins(namespace.TitleBarButtonMixin)
WeeklyRewardsSettingsButtonMixin.flag = "settings"

function WeeklyRewardsSettingsButtonMixin:OnLoad()
	namespace.TitleBarButtonMixin.OnLoad(self)

	self.tooltip = L["settings_button_tooltip"]
	self.tooltipText = L["settings_button_description"]

	local newEntries = {
		{ key = "windowTutorials", title = SHOW_TUTORIALS, tooltip = L["settings_tutorials_tooltip"] },
	}

	self:SetupMenu(function(_, rootMenu)
		rootMenu:CreateTitle(MINIMAP_LABEL)
		local showMinimapIcon = rootMenu:CreateCheckbox(L["settings_show_minimap_button"], function()
			return not Settings:Get("minimap").hide
		end, function()
			Settings:Set("minimap", { hide = not Settings:Get("minimap").hide })
		end)
		Settings:CreateCheckboxMenu("minimap", rootMenu, L["settings_lock_minimap_button"], "lock")

		rootMenu:CreateTitle(L["settings_window_title"])
		Settings:CreateOptionsTree("windowScale", rootMenu, RENDER_SCALE, { range = { 0.8, 2, 0.1 } })
		Settings:CreateOptionsTree("windowMaxRelativeWidth", rootMenu, L["settings_max_width"], { range = { 0.2, 1, 0.1 } }, L["settings_max_width_percent"])
		Settings:CreateOptionsTree("windowMaxRows", rootMenu, L["settings_max_rows"], { range = { 5, 70, 5 }, e = 2 }, HUD_EDIT_MODE_SETTING_ACTION_BAR_NUM_ROWS)
		Settings:CreateColorSwatch("windowBackgroundColor", rootMenu, L["settings_background_color"])
		Settings:CreateColorSwatch("windowPlayerRowColor", rootMenu, L["settings_player_row_color"])
		Settings:CreateCheckboxMenu("windowBorder", rootMenu, L["settings_show_border"])
		Settings:CreateCheckboxMenu("windowRowNumbers", rootMenu, L["settings_show_row_numbers"])

		for _, entry in ipairs(newEntries) do
			local checkbox = Settings:CreateCheckboxMenu(entry.key, rootMenu, Flags:Format(entry.title, self.flag, entry.key), nil, entry.tooltip)
			checkbox.AddExtraStuffToTooltip = self.AddExtraStuffToTooltip
			checkbox.entry = entry
			checkbox.flag = self.flag
		end

		rootMenu:CreateTitle(L["settings_utility_title"])
		Settings:CreateCheckboxMenu("utilsUntrackQuests", rootMenu, L["settings_auto_untrack_quests"], nil, L["settings_auto_untrack_quests_tooltip"])
		Settings:CreateCheckboxMenu("utilsBroadcastRewards", rootMenu, L["settings_broadcast_rewards"], nil, L["settings_broadcast_rewards_tooltip"])
	end)
end
