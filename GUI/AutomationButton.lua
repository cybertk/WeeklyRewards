local _, namespace = ...

local L = namespace.L
local Flags = namespace.Flags
local Settings = namespace.Settings

WeeklyRewardsAutomationButtonMixin = CreateFromMixins(namespace.TitleBarButtonMixin)

function WeeklyRewardsAutomationButtonMixin.AddExtraStuffToTooltip(tooltip, description)
	namespace.TitleBarButtonMixin.AddExtraStuffToTooltip(tooltip, description)

	local entry = description.entry
	if not entry.hint or entry.hint ~= "" then
		tooltip:AddLine(" ")
		GameTooltip_AddInstructionLine(tooltip, L["automation_disable_hint"])
	end
end

function WeeklyRewardsAutomationButtonMixin:OnLoad()
	namespace.TitleBarButtonMixin.OnLoad(self)

	self.tooltip = L["automation_button_tooltip"]
	self.tooltipText = L["automation_button_description"]

	local newEntries = {
		{ key = "AutoEnter", title = L["automation_auto_enter_title"], tooltip = L["automation_auto_enter_tooltip"] },
		{ key = "AutoFlight", title = L["automation_auto_flight_title"], tooltip = L["automation_auto_flight_tooltip"] },
		{ key = "FastLoot", title = L["automation_fast_loot_title"], tooltip = L["automation_fast_loot_tooltip"], hint = "" },
	}

	self:SetupMenu(function(_, rootMenu)
		rootMenu:CreateTitle(L["automation_button_tooltip"])

		Settings:CreateCheckboxMenu("utilsUntrackQuests", rootMenu, L["settings_auto_untrack_quests"], nil, L["settings_auto_untrack_quests_tooltip"])
		Settings:CreateOptionsTree("utilsAnnounceRewards", rootMenu, L["settings_broadcast_rewards"], {
			{ text = "self", value = "SELF" },
			{
				text = "LARGEST",
				value = "LARGEST",
			},
		}, L["settings_broadcast_rewards_tooltip"], MenuResponse.Refresh)

		for _, entry in ipairs(newEntries) do
			local checkbox =
				Settings:CreateCheckboxMenu(self.flag .. entry.key, rootMenu, Flags:Format(entry.title, self.flag, entry.key), nil, entry.tooltip)
			checkbox.AddExtraStuffToTooltip = self.AddExtraStuffToTooltip
			checkbox.entry = entry
			checkbox.flag = self.flag
		end
	end)
end
