local _, namespace = ...

local L = namespace.L
local Flags = namespace.Flags
local Settings = namespace.Settings

WeeklyRewardsAutomationButtonMixin = CreateFromMixins(namespace.TitleBarButtonMixin)

function WeeklyRewardsAutomationButtonMixin.AddExtraStuffToTooltip(tooltip, description)
	namespace.TitleBarButtonMixin.AddExtraStuffToTooltip(tooltip, description)

	tooltip:AddLine(" ")
	GameTooltip_AddInstructionLine(tooltip, L["automation_disable_hint"])
end

function WeeklyRewardsAutomationButtonMixin:OnLoad()
	namespace.TitleBarButtonMixin.OnLoad(self)

	self.tooltip = L["automation_button_tooltip"]
	self.tooltipText = L["automation_button_description"]

	local newEntries = {
		{ key = "AutoEnter", title = L["automation_auto_enter_title"], tooltip = L["automation_auto_enter_tooltip"] },
		{ key = "AutoFlight", title = L["automation_auto_flight_title"], tooltip = L["automation_auto_flight_tooltip"] },
	}

	self:SetupMenu(function(_, rootMenu)
		rootMenu:CreateTitle(L["automation_button_tooltip"])

		Settings:CreateCheckboxMenu("utilsUntrackQuests", rootMenu, L["settings_auto_untrack_quests"], nil, L["settings_auto_untrack_quests_tooltip"])
		Settings:CreateCheckboxMenu("utilsBroadcastRewards", rootMenu, L["settings_broadcast_rewards"], nil, L["settings_broadcast_rewards_tooltip"])

		for _, entry in ipairs(newEntries) do
			local checkbox =
				Settings:CreateCheckboxMenu(self.flag .. entry.key, rootMenu, Flags:Format(entry.title, self.flag, entry.key), nil, entry.tooltip)
			checkbox.AddExtraStuffToTooltip = self.AddExtraStuffToTooltip
			checkbox.entry = entry
			checkbox.flag = self.flag
		end

		local autoFlight = namespace.ModuleManager.Modules.AutoFlight
		if autoFlight and autoFlight:HasRoutes() then
			rootMenu:CreateSpacer()
			rootMenu:CreateButton(L["automation_auto_flight_clear"], function()
				StaticPopup_ShowGenericConfirmation(L["automation_auto_flight_clear_confirm"], function()
					autoFlight:ClearRoutes()
				end)
			end)
		end
	end)
end
