local addonName, namespace = ...

local Main = {}
namespace.GUIMain = Main

local LibDBIcon = LibStub("LibDBIcon-1.0")

-- Imported by Embeds/WeeklyKnowledge
local Constants = namespace.Constants
local UI = namespace.UI
local Utils = namespace.Utils

local L = namespace.L
local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards
local RewardSummary = namespace.RewardSummary

local Dialogs = namespace.Dialogs

function Main:ToggleWindow()
	if not self.window then
		self:CreateWindow()
	end

	if self.window:IsVisible() then
		self.window:Hide()
	else
		CharacterStore.Get():CurrentPlayer():UpdateProgress()
		self.window:Show()
		self:Redraw()
	end
end

function Main:SetTooltipOwner(tooltip, owner)
	if GetScreenHeight() / self.window:GetScale() - self.window:GetTop() < 50 then
		tooltip:SetOwner(owner, "ANCHOR_BOTTOM")
	else
		tooltip:SetOwner(owner, "ANCHOR_TOP")
	end
end

function Main:AddCloseButton()
	self.window.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.window.titlebar)
	self.window.titlebar.closeButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
	self.window.titlebar.closeButton:SetPoint("RIGHT", self.window.titlebar, "RIGHT", 0, 0)
	self.window.titlebar.closeButton:SetScript("OnClick", function()
		self:ToggleWindow()
	end)
	self.window.titlebar.closeButton:SetScript("OnEnter", function()
		self.window.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
		Utils:SetBackgroundColor(self.window.titlebar.closeButton, 1, 0, 0, 0.2)
		self:SetTooltipOwner(GameTooltip, self.window.titlebar.closeButton)
		GameTooltip:SetText(L["close_button_tooltip"], 1, 1, 1, 1, true)
		GameTooltip:Show()
	end)
	self.window.titlebar.closeButton:SetScript("OnLeave", function()
		self.window.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
		Utils:SetBackgroundColor(self.window.titlebar.closeButton, 1, 1, 1, 0)
		GameTooltip:Hide()
	end)

	self.window.titlebar.closeButton.Icon = self.window.titlebar:CreateTexture("$parentIcon", "ARTWORK")
	self.window.titlebar.closeButton.Icon:SetPoint("CENTER", self.window.titlebar.closeButton, "CENTER")
	self.window.titlebar.closeButton.Icon:SetSize(16, 16)
	self.window.titlebar.closeButton.Icon:SetAtlas("uitools-icon-close")
	self.window.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
end

function Main:AddSettingsButton()
	self.window.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", self.window.titlebar)
	self.window.titlebar.SettingsButton:SetPoint("RIGHT", self.window.titlebar.closeButton, "LEFT", 0, 0)
	self.window.titlebar.SettingsButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
	self.window.titlebar.SettingsButton:SetScript("OnEnter", function()
		self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
		Utils:SetBackgroundColor(self.window.titlebar.SettingsButton, 1, 1, 1, 0.05)
		self:SetTooltipOwner(GameTooltip, self.window.titlebar.SettingsButton)
		GameTooltip:SetText(L["settings_button_tooltip"], 1, 1, 1, 1, true)
		GameTooltip:AddLine(L["settings_button_description"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		GameTooltip:Show()
	end)
	self.window.titlebar.SettingsButton:SetScript("OnLeave", function()
		self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
		Utils:SetBackgroundColor(self.window.titlebar.SettingsButton, 1, 1, 1, 0)
		GameTooltip:Hide()
	end)
	self.window.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
		local showMinimapIcon = rootMenu:CreateCheckbox(L["settings_show_minimap_button"], function()
			return not WeeklyRewards.db.global.minimap.hide
		end, function()
			WeeklyRewards.db.global.minimap.hide = not WeeklyRewards.db.global.minimap.hide
			LibDBIcon:Refresh(addonName, WeeklyRewards.db.global.minimap)
		end)
		showMinimapIcon:SetTooltip(function(tooltip, elementDescription)
			GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
			GameTooltip_AddNormalLine(tooltip, L["settings_show_minimap_tooltip"])
		end)

		local lockMinimapIcon = rootMenu:CreateCheckbox(L["settings_lock_minimap_button"], function()
			return WeeklyRewards.db.global.minimap.lock
		end, function()
			WeeklyRewards.db.global.minimap.lock = not WeeklyRewards.db.global.minimap.lock
			LibDBIcon:Refresh(addonName, WeeklyRewards.db.global.minimap)
		end)
		lockMinimapIcon:SetTooltip(function(tooltip, elementDescription)
			GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
			GameTooltip_AddNormalLine(tooltip, L["settings_lock_minimap_tooltip"])
		end)

		rootMenu:CreateTitle(L["settings_window_title"])
		local windowScale = rootMenu:CreateButton(L["settings_scaling"])
		for i = 80, 200, 10 do
			windowScale:CreateRadio(i .. "%", function()
				return WeeklyRewards.db.global.main.windowScale == i
			end, function(data)
				WeeklyRewards.db.global.main.windowScale = data
				self:Redraw()
			end, i)
		end

		local windowMaxWidth = rootMenu:CreateButton(L["settings_max_width"])
		windowMaxWidth:CreateTitle(L["settings_max_width_percent"])
		for i = 20, 100, 10 do
			windowMaxWidth:CreateRadio(i .. "%", function()
				return WeeklyRewards.db.global.main.windowMaxRelativeWidth == i
			end, function(data)
				WeeklyRewards.db.global.main.windowMaxRelativeWidth = data
				self:Redraw()
			end, i)
		end

		local windowMaxRows = rootMenu:CreateButton(L["settings_max_rows"])
		windowMaxRows:CreateTitle(HUD_EDIT_MODE_SETTING_ACTION_BAR_NUM_ROWS)
		for i = 5, 70, 5 do
			if i < 40 or i % 10 == 0 then
				windowMaxRows:CreateRadio(i, function()
					return WeeklyRewards.db.global.main.windowMaxRows == i
				end, function(data)
					WeeklyRewards.db.global.main.windowMaxRows = data
					self:Redraw()
				end, i)
			end
		end

		local colorInfo = {
			r = WeeklyRewards.db.global.main.windowBackgroundColor.r,
			g = WeeklyRewards.db.global.main.windowBackgroundColor.g,
			b = WeeklyRewards.db.global.main.windowBackgroundColor.b,
			opacity = WeeklyRewards.db.global.main.windowBackgroundColor.a,
			swatchFunc = function()
				local r, g, b = ColorPickerFrame:GetColorRGB()
				local a = ColorPickerFrame:GetColorAlpha()
				if r then
					WeeklyRewards.db.global.main.windowBackgroundColor.r = r
					WeeklyRewards.db.global.main.windowBackgroundColor.g = g
					WeeklyRewards.db.global.main.windowBackgroundColor.b = b
					if a then
						WeeklyRewards.db.global.main.windowBackgroundColor.a = a
					end
					Utils:SetBackgroundColor(
						self.window,
						WeeklyRewards.db.global.main.windowBackgroundColor.r,
						WeeklyRewards.db.global.main.windowBackgroundColor.g,
						WeeklyRewards.db.global.main.windowBackgroundColor.b,
						WeeklyRewards.db.global.main.windowBackgroundColor.a
					)
				end
			end,
			opacityFunc = function() end,
			cancelFunc = function(color)
				if color.r then
					WeeklyRewards.db.global.main.windowBackgroundColor.r = color.r
					WeeklyRewards.db.global.main.windowBackgroundColor.g = color.g
					WeeklyRewards.db.global.main.windowBackgroundColor.b = color.b
					if color.a then
						WeeklyRewards.db.global.main.windowBackgroundColor.a = color.a
					end
					Utils:SetBackgroundColor(
						self.window,
						WeeklyRewards.db.global.main.windowBackgroundColor.r,
						WeeklyRewards.db.global.main.windowBackgroundColor.g,
						WeeklyRewards.db.global.main.windowBackgroundColor.b,
						WeeklyRewards.db.global.main.windowBackgroundColor.a
					)
				end
			end,
			hasOpacity = 1,
		}
		rootMenu:CreateColorSwatch(L["settings_background_color"], function()
			ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
		end, colorInfo)

		rootMenu:CreateCheckbox(L["settings_show_border"], function()
			return WeeklyRewards.db.global.main.windowBorder
		end, function()
			WeeklyRewards.db.global.main.windowBorder = not WeeklyRewards.db.global.main.windowBorder
			self:Redraw()
		end)

		rootMenu:CreateTitle(L["settings_utility_title"])
		local untrackQuests = rootMenu:CreateCheckbox(L["settings_auto_untrack_quests"], function()
			return WeeklyRewards.db.global.utils.untrackQuests
		end, function()
			WeeklyRewards.db.global.utils.untrackQuests = not WeeklyRewards.db.global.utils.untrackQuests
		end)
		untrackQuests:SetTooltip(function(tooltip, elementDescription)
			GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
			GameTooltip_AddNormalLine(tooltip, L["settings_auto_untrack_quests_tooltip"])
		end)

		local broadcastRewards = rootMenu:CreateCheckbox(L["settings_broadcast_rewards"], function()
			return WeeklyRewards.db.global.utils.broadcastRewards
		end, function()
			WeeklyRewards.db.global.utils.broadcastRewards = not WeeklyRewards.db.global.utils.broadcastRewards
		end)
		broadcastRewards:SetTooltip(function(tooltip, elementDescription)
			GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
			GameTooltip_AddNormalLine(tooltip, L["settings_broadcast_rewards_tooltip"])
		end)
	end)

	self.window.titlebar.SettingsButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
	self.window.titlebar.SettingsButton.Icon:SetPoint("CENTER", self.window.titlebar.SettingsButton, "CENTER")
	self.window.titlebar.SettingsButton.Icon:SetSize(30, 30)
	self.window.titlebar.SettingsButton.Icon:SetAtlas("GM-icon-settings")

	self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
end

function Main:AddCharactersButton()
	self.window.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", self.window.titlebar)
	self.window.titlebar.CharactersButton:SetPoint("RIGHT", self.window.titlebar.SettingsButton, "LEFT", 0, 0)
	self.window.titlebar.CharactersButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
	self.window.titlebar.CharactersButton:SetScript("OnEnter", function()
		self.window.titlebar.CharactersButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
		Utils:SetBackgroundColor(self.window.titlebar.CharactersButton, 1, 1, 1, 0.05)
		self:SetTooltipOwner(GameTooltip, self.window.titlebar.CharactersButton)
		GameTooltip:SetText(L["characters_button_title"], 1, 1, 1, 1, true)
		GameTooltip:AddLine(L["characters_button_description"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		GameTooltip:Show()
	end)
	self.window.titlebar.CharactersButton:SetScript("OnLeave", function()
		self.window.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
		Utils:SetBackgroundColor(self.window.titlebar.CharactersButton, 1, 1, 1, 0)
		GameTooltip:Hide()
	end)
	self.window.titlebar.CharactersButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.CharactersButton:GetName() .. "Icon", "ARTWORK")
	self.window.titlebar.CharactersButton.Icon:SetPoint("CENTER", self.window.titlebar.CharactersButton, "CENTER")
	self.window.titlebar.CharactersButton.Icon:SetSize(18, 18)
	self.window.titlebar.CharactersButton.Icon:SetAtlas("squad_size_trios")

	self.window.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
	self.window.titlebar.CharactersButton:SetupMenu(function(_, rootMenu)
		rootMenu:CreateTitle():AddInitializer(function(frame, description, menu)
			frame.fontString:SetText(format("|cnWHITE_FONT_COLOR:%s (%d)|r", L["characters_button_title"], CharacterStore.Get():GetNumEnabledCharacters()))
		end)
		CharacterStore.Get():ForEach(function(character)
			local name = character.name

			if character.realmName then
				name = format("%s - %s", character.name, character.realmName)
			end

			local characterButton = rootMenu:CreateCheckbox(Util.WrapTextInClassColor(character.class, name), function()
				return character.enabled or false
			end, function()
				if IsControlKeyDown() then
					self:RemoveRow(character)
					return
				end

				character.enabled = not character.enabled
				self:Redraw()
			end)
		end, function(character)
			return not CharacterStore.IsCurrentPlayer(character)
		end)

		rootMenu:CreateSpacer()
		rootMenu:CreateTitle(GREEN_FONT_COLOR:WrapTextInColorCode(L["characters_button_remove_hint"]))
	end)
end

function Main:AddRewardsFilterButton()
	self.window.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.window.titlebar)
	self.window.titlebar.ColumnsButton:SetPoint("RIGHT", self.window.titlebar.CharactersButton, "LEFT", 0, 0)
	self.window.titlebar.ColumnsButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
	self.window.titlebar.ColumnsButton:SetScript("OnEnter", function()
		self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
		Utils:SetBackgroundColor(self.window.titlebar.ColumnsButton, 1, 1, 1, 0.05)
		self:SetTooltipOwner(GameTooltip, self.window.titlebar.ColumnsButton)
		GameTooltip:SetText(L["columns_button_tooltip"], 1, 1, 1, 1, true)
		GameTooltip:AddLine(L["columns_button_description"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		GameTooltip:Show()
	end)
	self.window.titlebar.ColumnsButton:SetScript("OnLeave", function()
		self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
		Utils:SetBackgroundColor(self.window.titlebar.ColumnsButton, 1, 1, 1, 0)
		GameTooltip:Hide()
	end)
	self.window.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
		if not self.columns then
			return
		end

		local hidden = WeeklyRewards.db.global.main.hiddenColumns
		local activeRewards = ActiveRewards.Get()

		for _, column in ipairs(self.columns) do
			if column.reward == nil then
				rootMenu:CreateCheckbox(column.name, function()
					return not hidden[column.name]
				end, function(columnName)
					hidden[columnName] = not hidden[columnName]
					self:Redraw()
				end, column.name)
			end
		end

		local groups, legacyExpansions = activeRewards:GetAllGroups()

		rootMenu:CreateDivider()
		rootMenu:CreateTitle(REWARDS)
		self:AddRewardsFilterToMenu(rootMenu, groups)

		rootMenu:CreateTitle(LFG_LIST_LEGACY)
		self:AddRewardsFilterToMenu(rootMenu, legacyExpansions, true)
	end)

	self.window.titlebar.ColumnsButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
	self.window.titlebar.ColumnsButton.Icon:SetPoint("CENTER", self.window.titlebar.ColumnsButton, "CENTER")
	self.window.titlebar.ColumnsButton.Icon:SetSize(15, 14)
	self.window.titlebar.ColumnsButton.Icon:SetAtlas("UI-HUD-Minimap-Tracking-Up")
	self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
end

function Main:AddRewardsFilterToMenu(rootMenu, expansions, isLegacy)
	local activeRewards = ActiveRewards.Get()

	for name, expansion in pairs(expansions) do
		local button = rootMenu

		if isLegacy then
			button = rootMenu:CreateButton(_G["EXPANSION_NAME" .. name])
		elseif name ~= "" then
			button = rootMenu:CreateCheckbox(name, function()
				return not activeRewards:IsGroupExcluded(name)
			end, function()
				activeRewards:ToggleExclusionByGroup(name)
				self:Redraw()
			end)
		end

		for group, rewards in pairs(expansion) do
			if isLegacy and group ~= "" then
				button:CreateTitle(group)
			end

			for _, reward in ipairs(rewards) do
				button:CreateCheckbox(reward.name, function()
					return not activeRewards:IsExcluded(reward.id)
				end, function()
					activeRewards:ToggleExclusion(reward.id)
					if not activeRewards:IsExcluded(reward.id) then
						local character = CharacterStore.Get():CurrentPlayer()

						character:Scan(activeRewards)
						character:UpdateProgress()
					end
					self:Redraw()
				end)
			end

			if isLegacy and group ~= "" then
				button:QueueDivider()
			end
		end
	end
end

function Main:AddSortButton()
	self.window.titlebar.SortButton = CreateFrame("DropdownButton", "$parentSettingsButton", self.window.titlebar)
	self.window.titlebar.SortButton:SetPoint("RIGHT", self.window.titlebar.ColumnsButton, "LEFT", 0, 0)
	self.window.titlebar.SortButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
	self.window.titlebar.SortButton:SetScript("OnEnter", function()
		self.window.titlebar.SortButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
		Utils:SetBackgroundColor(self.window.titlebar.SortButton, 1, 1, 1, 0.05)
		self:SetTooltipOwner(GameTooltip, self.window.titlebar.SortButton)
		GameTooltip:SetText(L["sort_button_tooltip"], 1, 1, 1, 1, true)
		GameTooltip:AddLine(L["sort_button_description"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		GameTooltip:Show()
	end)
	self.window.titlebar.SortButton:SetScript("OnLeave", function()
		self.window.titlebar.SortButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
		Utils:SetBackgroundColor(self.window.titlebar.SortButton, 1, 1, 1, 0)
		GameTooltip:Hide()
	end)
	self.window.titlebar.SortButton:SetupMenu(function(_, rootMenu)
		local activeRewards = ActiveRewards.Get()
		local sortingFields = {
			group = L["sort_reward_group"],
			name = L["sort_reward_name"],
			resetTime = L["sort_time_left"],
		}
		for field, name in pairs(sortingFields) do
			rootMenu:CreateCheckbox(name, function()
				return activeRewards.sortBy == field
			end, function()
				activeRewards.sortBy = field
				activeRewards:Sort()
				self:SyncRewardColumnOrder()
				self:Redraw()
			end)
		end
		-- end
	end)

	self.window.titlebar.SortButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.SortButton:GetName() .. "Icon", "ARTWORK")
	self.window.titlebar.SortButton.Icon:SetPoint("CENTER", self.window.titlebar.SortButton, "CENTER")
	self.window.titlebar.SortButton.Icon:SetSize(20, 20)
	self.window.titlebar.SortButton.Icon:SetAtlas("shop-header-arrow-disabled")
	self.window.titlebar.SortButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
end

function Main:CreateWindow()
	local frameName = addonName .. "MainWindow"
	self.window = CreateFrame("Frame", frameName, UIParent)
	self.window:SetSize(500, 500)
	self.window:SetFrameStrata("MEDIUM")
	self.window:SetFrameLevel(8000)
	self.window:SetToplevel(true)
	self.window:SetClampedToScreen(true)
	self.window:SetMovable(true)
	self.window:SetPoint("CENTER")
	self.window:SetUserPlaced(true)
	self.window:RegisterForDrag("LeftButton")
	self.window:EnableMouse(true)
	self.window:SetScript("OnDragStart", function()
		self.window:StartMoving()
	end)
	self.window:SetScript("OnDragStop", function()
		self.window:StopMovingOrSizing()
	end)
	self.window:Hide()
	Utils:SetBackgroundColor(
		self.window,
		WeeklyRewards.db.global.main.windowBackgroundColor.r,
		WeeklyRewards.db.global.main.windowBackgroundColor.g,
		WeeklyRewards.db.global.main.windowBackgroundColor.b,
		WeeklyRewards.db.global.main.windowBackgroundColor.a
	)

	self.window.border = CreateFrame("Frame", "$parentBorder", self.window, "BackdropTemplate")
	self.window.border:SetPoint("TOPLEFT", self.window, "TOPLEFT", -3, 3)
	self.window.border:SetPoint("BOTTOMRIGHT", self.window, "BOTTOMRIGHT", 3, -3)
	self.window.border:SetBackdrop({
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	self.window.border:SetBackdropBorderColor(0, 0, 0, 0.5)
	self.window.border:Show()

	self.window.titlebar = CreateFrame("Frame", "$parentTitle", self.window)
	self.window.titlebar:SetPoint("TOPLEFT", self.window, "TOPLEFT")
	self.window.titlebar:SetPoint("TOPRIGHT", self.window, "TOPRIGHT")
	self.window.titlebar:SetHeight(Constants.TITLEBAR_HEIGHT)
	self.window.titlebar:RegisterForDrag("LeftButton")
	self.window.titlebar:EnableMouse(true)
	self.window.titlebar:SetScript("OnDragStart", function()
		self.window:StartMoving()
	end)
	self.window.titlebar:SetScript("OnDragStop", function()
		self.window:StopMovingOrSizing()
	end)
	Utils:SetBackgroundColor(self.window.titlebar, 0, 0, 0, 0.5)

	self.window.titlebar.icon = self.window.titlebar:CreateTexture("$parentIcon", "ARTWORK")
	self.window.titlebar.icon:SetPoint("LEFT", self.window.titlebar, "LEFT", 6, 0)
	self.window.titlebar.icon:SetSize(20, 20)
	self.window.titlebar.icon:SetTexture("Interface/AddOns/WeeklyRewards/Media/Icon.blp")

	self.window.titlebar.title = self.window.titlebar:CreateFontString("$parentText", "OVERLAY")
	self.window.titlebar.title:SetFontObject("SystemFont_Med2")
	self.window.titlebar.title:SetPoint("LEFT", self.window.titlebar, 28, 0)
	self.window.titlebar.title:SetJustifyH("LEFT")
	self.window.titlebar.title:SetJustifyV("MIDDLE")
	self.window.titlebar.title:SetText(addonName)

	self.window.titlebar.season = self.window.titlebar:CreateFontString("$parentText", "OVERLAY")
	self.window.titlebar.season:SetFontObject("SystemFont_Med2")
	self.window.titlebar.season:SetPoint("CENTER", self.window.titlebar)
	self.window.titlebar.season:SetJustifyH("CENTER")
	self.window.titlebar.season:SetJustifyV("MIDDLE")
	self.window.titlebar.season:SetText(Util:GetCurrentSeasonName())

	self:AddCloseButton()
	self:AddSettingsButton()
	self:AddCharactersButton()
	self:AddRewardsFilterButton()
	self:AddSortButton()

	self.window.table = UI:CreateTableFrame({
		header = {
			enabled = true,
			height = Constants.TABLE_HEADER_HEIGHT,
			sticky = true,
		},
		rows = {
			height = Constants.TABLE_ROW_HEIGHT,
			highlight = true,
			striped = true,
		},
	})
	self.window.table:SetParent(self.window)
	self.window.table:SetPoint("TOPLEFT", self.window, "TOPLEFT", 0, -Constants.TITLEBAR_HEIGHT)
	self.window.table:SetPoint("BOTTOMRIGHT", self.window, "BOTTOMRIGHT", 0, 0)

	self.window.table.scrollFrame:HookScript("OnMouseWheel", function(frame, _)
		if IsModifierKeyDown() or not frame.scrollbarV:IsVisible() then
			self:LayoutHeader()
		end
	end)

	-- bugfix: horizontal scroll is always triggerd by mousewheel after adjusting window scale
	hooksecurefunc(self.window.table.scrollFrame, "RenderScrollFrame", function(frame)
		if not frame.scrollbarH:IsShown() then
			frame.scrollbarH:SetMinMaxValues(0, 0)
		end
	end)

	hooksecurefunc(self.window.table, "RenderTable", function()
		C_Timer.After(0, GenerateClosure(self.LayoutHeader, self, true))
	end)

	table.insert(UISpecialFrames, frameName)
end

function Main:RemoveRow(character)
	Util:Debug("Removing row:", character.name)

	local text = CONFIRM_DESTROY_CHARACTER_COMMUNITY:gsub(CLUB_FINDER_COMMUNITY_TYPE:lower(), PVP_PROGRESS_REWARDS_HEADER:lower())

	StaticPopup_ShowGenericConfirmation(text:gsub("|n.*$", ""):format(character.name), function()
		CharacterStore:Get():RemoveCharacter(character.GUID)
		self:Redraw()
	end)
end

function Main:ResetCell(character, reward)
	Util:Debug("Reseting cell:", character.name, reward.id)

	local text = CONFIRM_DESTROY_CHARACTER_COMMUNITY:gsub(CLUB_FINDER_COMMUNITY_TYPE:lower(), PVP_PROGRESS_REWARDS_HEADER:lower())

	StaticPopup_ShowGenericConfirmation(text:gsub("|n.*$", ""):format(reward.name), function()
		character:ResetProgress(reward, true)
		character:Scan({ reward })
		character:UpdateProgress()
		self:Redraw()
	end)
end

function Main:AddCharacterColumns()
	local columns = {
		{
			name = NAME,
			key = "name",
			cell = function(character)
				local note, tag = character:GetNote()

				tag = #tag > 0 and format(" |cnGOLD_FONT_COLOR:(%s)|r", #tag > 4 and "*" or tag) or tag

				local text = Util.WrapTextInClassColor(character.class, character.name)
				return {
					text = character:IsCurrent() and format("|T%s.tga:13:13|t%s%s", FRIENDS_TEXTURE_ONLINE, text, tag) or text .. tag,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						GameTooltip:SetText(Util.WrapTextInClassColor(character.class, format("%s-%s", character.name, character.realmName)))
						GameTooltip:AddLine(" ")
						if #note > 0 then
							GameTooltip:AddLine("|T131129:12|t" .. note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
							GameTooltip:AddLine(" ")
						end
						GameTooltip:AddLine(CLICK_TO_ENTER_COMMENT, GREEN_FONT_COLOR:GetRGB())
						GameTooltip:Show()
					end,
					onLeave = GameTooltip_Hide,
					onClick = function()
						Dialogs.ShowCharacterNote(character)
					end,
				}
			end,
		},
		{
			name = L["column_realm"],
			key = "realmName",
			cell = function(character)
				return { text = character.realmName }
			end,
		},
		{
			name = LEVEL,
			key = "level",
			align = "CENTER",
			cell = function(character)
				local _, timeToCharge = character:GetRestedXP()
				return {
					text = timeToCharge == 0 and GREEN_FONT_COLOR:WrapTextInColorCode(character.level) or character.level,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						character:AddXPToTooltip(GameTooltip)
						GameTooltip:Show()
					end,
					onLeave = GameTooltip_Hide,
				}
			end,
		},
		{
			name = ITEM_LEVEL_ABBR,
			key = "itemLevels",
			align = "CENTER",
			cell = function(character)
				local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = character:GetAverageItemLevel()
				return {
					text = avgItemLevel and floor(avgItemLevel) or "-",
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")

						if not avgItemLevel then
							GameTooltip:SetText(L["table_alts_collect_hint"], GREEN_FONT_COLOR:GetRGB())
						else
							local title = format("%s %d", STAT_AVERAGE_ITEM_LEVEL, avgItemLevel)
							if avgItemLevelEquipped ~= avgItemLevel then
								title = title .. "  " .. STAT_AVERAGE_ITEM_LEVEL_EQUIPPED:format(avgItemLevelEquipped)
							end
							GameTooltip:SetText(title, HIGHLIGHT_FONT_COLOR:GetRGB())

							GameTooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL_TOOLTIP)
							GameTooltip:AddLine(" ")
							GameTooltip:AddLine(PVP_RATING_LINK_ITEM_LEVEL:format(avgItemLevelPvP))
						end
						GameTooltip:Show()
					end,
					onLeave = GameTooltip_Hide,
				}
			end,
		},
		{
			name = FACTION,
			key = "factionName",
			align = "CENTER",
			cell = function(character)
				return { text = CreateAtlasMarkup(format("questlog-questtypeicon-%s", character:GetFaction():lower()), 20, 20) }
			end,
		},
		{
			name = L["column_covenant"],
			key = "covenant",
			align = "CENTER",
			cell = function(character)
				return {
					text = character:GetCovenantName(),
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						GameTooltip:SetText(L["column_covenant"], YELLOW_FONT_COLOR:GetRGB())
						GameTooltip:AddLine(" ")

						if CharacterStore.IsCurrentPlayer(character) then
							character:UpdateCovenant(true)
						end
						if character.covenantSanctum then
							Util:AddCovenantSanctumUpgradeToTooltip(GameTooltip, character.covenant, character.covenantSanctum)
						elseif character.covenant ~= 0 then
							GameTooltip:AddLine(L["covenant_sanctum_unknown"], RED_FONT_COLOR:GetRGB())
							GameTooltip:AddLine(" ")
							GameTooltip:AddLine(L["table_alts_collect_hint"], GREEN_FONT_COLOR:GetRGB())
						else
							GameTooltip:AddLine(L["covenant_not_joined"])
						end

						GameTooltip:Show()
					end,
					onLeave = function()
						GameTooltip:Hide()
					end,
				}
			end,
		},
		{
			name = L["column_location"],
			key = "location",
			align = "CENTER",
			cell = function(character)
				return {
					text = character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(character.location) or character.location,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						GameTooltip:SetText(character.location, HIGHLIGHT_FONT_COLOR:GetRGB())

						local instruction = "|A:NPE_LeftClick:16:16|a|cnGREEN_FONT_COLOR:(" .. INVITE .. ")|r"
						character:AddPartyToTooltip(GameTooltip, CharacterStore.IsCurrentPlayer(character) and instruction or "")

						GameTooltip:Show()
					end,
					onLeave = GameTooltip_Hide,
					onClick = function()
						if CharacterStore.IsCurrentPlayer(character) then
							character:InviteLastParty()
						end
					end,
				}
			end,
		},
		{
			name = L["column_last_update"],
			key = "lastUpdate",
			align = "CENTER",
			cell = function(character)
				local text = Util.FormatLastUpdateTime(character.lastUpdate)
				return { text = character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(text) or text }
			end,
		},
	}

	for _, column in ipairs(columns) do
		column.onEnter = function(cellFrame)
			GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
			GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
			GameTooltip:Show()
		end
		column.onLeave = function()
			GameTooltip:Hide()
		end
		table.insert(self.columns, column)
	end
end

function Main:AddRewardColumns()
	for _, reward in ipairs(ActiveRewards.Get()) do
		-- cache
		reward:ForEachItem(type)

		local column = {
			name = reward.name,
			reward = reward,
			onEnter = function(cellFrame)
				local function updateTooltip()
					GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
					self:AddRewardToGameTooltip(reward)
					GameTooltip:Show()
				end
				cellFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
				cellFrame:SetScript("OnEvent", updateTooltip)
				updateTooltip()
			end,
			onLeave = function(cellFrame)
				cellFrame:UnregisterEvent("MODIFIER_STATE_CHANGED")
				cellFrame:SetScript("OnEvent", nil)
				GameTooltip:Hide()
			end,
			toggleHidden = true,
			align = "CENTER",
			cell = function(character)
				local progress = character.progress[reward.id]

				if progress == nil and reward:PlayerMeetsRequiredLevel(character.level) then
					return ""
				end

				local text
				if progress == nil then
					text = reward:PlayerMeetsRequiredLevel(character.level) and " " or "-"
				elseif progress.total == 0 then
					text = "-"
				elseif progress.claimedAt and progress:IsExpired() then
					text = CreateAtlasMarkup("checkmark-minimal-disabled", 15, 15)
				else
					text = progress.total < 100 and format("%d / %d", progress.position, progress.total)
						or format("%.0f%%", progress.position / progress.total * 100)

					if progress:IsExpired() then
						text = GRAY_FONT_COLOR:WrapTextInColorCode(text)
					elseif progress.hasClaimed and progress:hasClaimed() then
						text = CreateAtlasMarkup("common-icon-checkmark", 15, 15)
					elseif progress.hasStarted and progress:hasStarted() then
						text = YELLOW_FONT_COLOR:WrapTextInColorCode(text)
					end
				end

				return {
					text = text,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						if progress == nil or progress:ObjectivesCount() == 0 then
							GameTooltip:AddLine(YELLOW_FONT_COLOR:WrapTextInColorCode(reward:GetDescription(true)))
							GameTooltip:AddLine(" ")
							GameTooltip:AddLine(
								progress and L["progress_not_started"]
									or ITEM_MIN_LEVEL:format(reward.maximumLevel or reward.minimumLevel)
							)
						else
							self:AddProgressToGameTooltip(progress)
							cellFrame.hasInstructions = nil
						end

						GameTooltip:Show()
					end,
					onLeave = function()
						GameTooltip:Hide()
					end,
					onClick = function(rowFrame, cellFrame)
						if not CharacterStore.IsCurrentPlayer(character) then
							return
						end

						if not cellFrame.hasInstructions then
							GameTooltip:AddLine(" ")
							GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_reset_progress_hint"]))
							GameTooltip:Show()
							cellFrame.hasInstructions = true
						end

						if IsControlKeyDown() then
							self:ResetCell(character, reward)
						end
					end,
				}
			end,
		}

		table.insert(self.columns, column)
	end
end

function Main:AddProgressToGameTooltip(progress)
	local questColor = progress:ObjectivesCount() == 1 and YELLOW_FONT_COLOR or WHITE_FONT_COLOR

	local status = ""
	if progress:IsExpired() then
		status = "|cnGRAY_FONT_COLOR:(" .. RAID_INSTANCE_EXPIRES_EXPIRED .. ")|r"
	end

	if progress.numObjectives > 1 then
		-- Show quests as high-level objectives
		GameTooltip:AddDoubleLine(YELLOW_FONT_COLOR:WrapTextInColorCode(progress.name), status)
		progress:ForEachObjective(function(objective, completed)
			GameTooltip:AddDoubleLine(
				WHITE_FONT_COLOR:WrapTextInColorCode("- " .. progress:GetCachedObjectiveName(objective)),
				CreateAtlasMarkup(completed and "common-icon-checkmark" or "common-icon-redx", 12, 12)
			)
		end)
	else
		local questName = QuestUtils_GetQuestName(progress:Quest()) or ""
		GameTooltip:AddDoubleLine(YELLOW_FONT_COLOR:WrapTextInColorCode(#questName > 0 and questName or progress.name), status)
		-- Show objectives of single quest
		progress:ForEachRecord(function(record, completed)
			GameTooltip:AddDoubleLine(
				WHITE_FONT_COLOR:WrapTextInColorCode("- " .. record.text or "Loading"),
				record.s or CreateAtlasMarkup(completed and "common-icon-checkmark" or "common-icon-redx", 12, 12)
			)
		end)
	end

	GameTooltip:AddLine(" ")

	if progress.claimedAt then
		local duration = progress.startedAt and format(" (%s used)", Util.FormatTimeDuration(progress.claimedAt - progress.startedAt, true)) or ""
		GameTooltip:AddDoubleLine(L["progress_rewards_received_at"], WHITE_FONT_COLOR:WrapTextInColorCode(date("%Y-%m-%d %H:%M", progress.claimedAt) .. duration))
	elseif progress.startedAt then
		GameTooltip:AddDoubleLine(L["progress_started_at"], WHITE_FONT_COLOR:WrapTextInColorCode(date("%Y-%m-%d %H:%M", progress.startedAt)))

		if progress.rewards then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["progress_rewards_received"])
		end
	else
		GameTooltip:AddLine(L["progress_not_started"])
	end

	progress:ForEachRewardItem(function(item)
		GameTooltip:AddLine(Util.FormatItem(item))
	end)

	if progress.drops and #progress.drops > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["progress_drops"])

		progress:ForEachRewardItem(function(item)
			GameTooltip:AddLine(Util.FormatItem(item))
		end, true)
	end
end

function Main:AddRewardToGameTooltip(reward)
	GameTooltip:AddDoubleLine(reward.name, "|A:NPE_LeftClick:16:16|a|cnGREEN_FONT_COLOR:(" .. (IsControlKeyDown() and HIDE or STABLE_FILTER_BUTTON_LABEL) .. ")|r")
	GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_reorder_hint"]))
	GameTooltip:AddLine(format("|cnNORMAL_FONT_COLOR:%s|r%s", reward.group and reward.group .. ": " or "", reward:GetDescription()), 1, 1, 1, true)

	GameTooltip:AddLine(" ")

	if reward.resetTime then
		GameTooltip:AddLine(L["reward_time_left"] .. WHITE_FONT_COLOR:WrapTextInColorCode(Util.FormatTimeDuration(reward.resetTime - GetServerTime())))
	end

	GameTooltip:AddLine(" ")
	RewardSummary:Create(reward.id):AddToTooltip(GameTooltip)
end

function Main:UpdateSortArrow()
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()

	local i = 0
	Main:ForEachColumn(function(column)
		i = i + 1

		local cellFrame = self.window.table.rows[1].columns[i]
		local characterField = column.key or column.reward.id

		cellFrame.columnKey = self:GetColumnKey(column)
		if column.reward then
			self:SetupColumnHeaderDrag(cellFrame)
		end

		cellFrame.data.onClick = function()
			if self.didColumnDrag then
				self.didColumnDrag = nil
				return
			end

			if IsControlKeyDown() then
				if column.reward then
					ActiveRewards.Get():ToggleExclusion(column.reward.id)
				else
					WeeklyRewards.db.global.main.hiddenColumns[column.name] = true
				end
			else
				CharacterStore.Get():SetSortOrder(characterField)
				local field, ascending = CharacterStore.Get():GetSortOrder()
				WeeklyRewards.db.global.main.sortColumn = field
				WeeklyRewards.db.global.main.sortAscending = ascending
			end

			self:Redraw()
		end

		if cellFrame.Arrow == nil then
			local t = cellFrame:CreateTexture()

			t:SetAtlas("auctionhouse-ui-sortarrow", true)

			cellFrame.Arrow = t
			cellFrame:SetHighlightTexture("auctionhouse-ui-row-highlight", "ADD")
		end

		if cellFrame.Arrow.text ~= cellFrame.text:GetText() then
			local offset = cellFrame.text:GetStringWidth() - cellFrame.text:GetWidth()
			if cellFrame.text:GetJustifyH() == "CENTER" then
				offset = offset / 2
			end

			cellFrame.Arrow:SetPoint("LEFT", cellFrame.text, "RIGHT", offset, 1)
			cellFrame.Arrow.text = cellFrame.text:GetText()
		end

		cellFrame.Arrow:SetShown(sortOrder == characterField)

		if sortOrder == characterField then
			if ascending then
				cellFrame.Arrow:SetTexCoord(0, 1, 0, 1)
			else
				cellFrame.Arrow:SetTexCoord(0, 1, 1, 0)
			end
		end
	end)
end

function Main:LayoutHeader(force)
	local header = self.window.table.rows[1]
	if not header then
		return
	end

	local anchor = header.columns[1] or nil
	local offset = anchor and -self.window.table.scrollFrame.scrollbarH:GetValue() - select(4, anchor:GetPointByName("TOPLEFT")) or 0

	if offset ~= 0 or force then
		for _, column in ipairs({ header:GetChildren() }) do
			AnchorUtil.AdjustPointByName(column, "TOPLEFT", offset, 0)
			AnchorUtil.AdjustPointByName(column, "BOTTOMLEFT", offset, 0)
		end
	end

	header:SetClipsChildren(true)
end

function Main:UpdateLayout()
	for _, row in ipairs(self.window.table.rows) do
		for _, cell in ipairs(row.columns) do
			cell.text:SetWordWrap(false)
		end
	end
end

function Main:MeasureTextWidth(text)
	if not self.measureText then
		self.measureText = self.window:CreateFontString("$parentMeasureText", "OVERLAY")
		self.measureText:SetFontObject("GameFontHighlightSmall")
		self.measureText:Hide()
	end
	self.measureText:SetText(text or "")
	return self.measureText:GetStringWidth()
end

function Main:GetColumnKey(column)
	return column.reward and column.reward.id or column.key
end

function Main:GetVisibleColumnAt(index)
	local i = 0
	local found
	self:ForEachColumn(function(column)
		i = i + 1
		if i == index then
			found = column
		end
	end)
	return found
end

function Main:ApplyColumnOrder()
	local order = WeeklyRewards.db.global.main.columnOrder
	if not order or #order == 0 then
		return
	end

	local byKey = {}
	for _, column in ipairs(self.columns) do
		byKey[self:GetColumnKey(column)] = column
	end

	local newColumns = {}
	local used = {}
	for _, key in ipairs(order) do
		local column = byKey[key]
		if column then
			table.insert(newColumns, column)
			used[key] = true
		end
	end
	for _, column in ipairs(self.columns) do
		local key = self:GetColumnKey(column)
		if not used[key] then
			table.insert(newColumns, column)
		end
	end
	self.columns = newColumns
end

function Main:EnsureColumnOrder()
	local main = WeeklyRewards.db.global.main
	main.columnOrder = main.columnOrder or {}
	local order = main.columnOrder
	local known = {}
	for _, column in ipairs(self.columns) do
		known[self:GetColumnKey(column)] = true
	end

	if #order == 0 then
		for _, column in ipairs(self.columns) do
			table.insert(order, self:GetColumnKey(column))
		end
		return order
	end

	for i = #order, 1, -1 do
		if not known[order[i]] then
			table.remove(order, i)
		end
	end

	local have = {}
	for _, key in ipairs(order) do
		have[key] = true
	end
	for _, column in ipairs(self.columns) do
		local key = self:GetColumnKey(column)
		if not have[key] then
			table.insert(order, key)
		end
	end
	return order
end

function Main:SyncRewardColumnOrder()
	local order = WeeklyRewards.db.global.main.columnOrder
	if not order or #order == 0 then
		return
	end

	self:EnsureColumnOrder()

	local rewardIds = {}
	local rewardSet = {}
	for _, reward in ipairs(ActiveRewards.Get()) do
		table.insert(rewardIds, reward.id)
		rewardSet[reward.id] = true
	end

	local ri = 1
	for i, key in ipairs(order) do
		if rewardSet[key] and ri <= #rewardIds then
			order[i] = rewardIds[ri]
			ri = ri + 1
		end
	end
	while ri <= #rewardIds do
		table.insert(order, rewardIds[ri])
		ri = ri + 1
	end
end

function Main:MoveColumn(fromKey, toKey, after)
	if fromKey == toKey then
		return false
	end

	local order = self:EnsureColumnOrder()
	local visible = {}
	self:ForEachColumn(function(column)
		table.insert(visible, self:GetColumnKey(column))
	end)

	local fromVis, toVis
	for i, key in ipairs(visible) do
		if key == fromKey then
			fromVis = i
		end
		if key == toKey then
			toVis = i
		end
	end
	if not fromVis or not toVis then
		return false
	end

	local destVis = after and (toVis + 1) or toVis
	table.remove(visible, fromVis)
	if fromVis < destVis then
		destVis = destVis - 1
	end
	if destVis < 1 then
		destVis = 1
	elseif destVis > #visible + 1 then
		destVis = #visible + 1
	end
	if destVis == fromVis then
		return false
	end

	table.insert(visible, destVis, fromKey)

	local visibleSet = {}
	for _, key in ipairs(visible) do
		visibleSet[key] = true
	end

	local vi = 1
	for i, key in ipairs(order) do
		if visibleSet[key] then
			order[i] = visible[vi]
			vi = vi + 1
		end
	end
	while vi <= #visible do
		table.insert(order, visible[vi])
		vi = vi + 1
	end

	return true
end

function Main:GetColumnDragGhost()
	if self.columnDragGhost then
		return self.columnDragGhost
	end

	local ghost = CreateFrame("Frame", addonName .. "ColumnDragGhost", UIParent)
	ghost:SetFrameStrata("TOOLTIP")
	ghost:SetFrameLevel(10000)
	ghost:SetSize(80, Constants.TABLE_HEADER_HEIGHT)
	Utils:SetBackgroundColor(ghost, 0, 0, 0, 0.85)
	ghost.text = ghost:CreateFontString("$parentText", "OVERLAY")
	ghost.text:SetFontObject("GameFontHighlightSmall")
	ghost.text:SetPoint("TOPLEFT", ghost, "TOPLEFT", Constants.TABLE_CELL_PADDING, 0)
	ghost.text:SetPoint("BOTTOMRIGHT", ghost, "BOTTOMRIGHT", -Constants.TABLE_CELL_PADDING, 0)
	ghost.text:SetJustifyH("CENTER")
	ghost.text:SetJustifyV("MIDDLE")
	ghost.text:SetWordWrap(false)
	ghost:Hide()
	self.columnDragGhost = ghost
	return ghost
end

function Main:GetColumnDropIndicator()
	if self.columnDropIndicator then
		return self.columnDropIndicator
	end

	local header = self.window.table.rows[1]
	local line = header:CreateTexture(nil, "OVERLAY")
	line:SetDrawLayer("OVERLAY", 7)
	line:SetColorTexture(1, 0.82, 0, 0.95)
	line:SetWidth(3)
	line:Hide()
	self.columnDropIndicator = line
	return line
end

function Main:GetHeaderDropTarget()
	local header = self.window.table.rows[1]
	if not header then
		return
	end

	local scale = header:GetEffectiveScale()
	local cursorX = GetCursorPosition() / scale
	local cells = header.columns
	local n = #cells

	for i, cell in ipairs(cells) do
		if cell:IsShown() then
			local left, right = cell:GetLeft(), cell:GetRight()
			if left and right and cursorX >= left and cursorX <= right then
				return i, cell, cursorX > (left + right) / 2
			end
		end
	end

	local first, last = cells[1], cells[n]
	if first and first:GetLeft() and cursorX < first:GetLeft() then
		return 1, first, false
	end
	if last and last:GetRight() and cursorX > last:GetRight() then
		return n, last, true
	end
end

function Main:NormalizeRewardDropTarget(index, cell, after)
	if not index then
		return
	end

	local target = self:GetVisibleColumnAt(index)
	if target and target.reward then
		return index, cell, after, target
	end

	local firstIndex, lastIndex, firstReward, lastReward
	local i = 0
	self:ForEachColumn(function(column)
		i = i + 1
		if column.reward then
			if not firstIndex then
				firstIndex = i
				firstReward = column
			end
			lastIndex = i
			lastReward = column
		end
	end)
	if not firstIndex then
		return
	end

	local header = self.window.table.rows[1]
	if index >= lastIndex then
		return lastIndex, header.columns[lastIndex], true, lastReward
	end
	return firstIndex, header.columns[firstIndex], false, firstReward
end

function Main:UpdateColumnDropIndicator()
	local index, cell, after = self:NormalizeRewardDropTarget(self:GetHeaderDropTarget())
	local indicator = self:GetColumnDropIndicator()
	if not index or not cell or not self.columnDrag then
		indicator:Hide()
		return
	end

	local target = self:GetVisibleColumnAt(index)
	if not target or self:GetColumnKey(target) == self.columnDrag.key then
		indicator:Hide()
		return
	end

	indicator:ClearAllPoints()
	if after then
		indicator:SetPoint("TOP", cell, "TOPRIGHT", 0, 0)
		indicator:SetPoint("BOTTOM", cell, "BOTTOMRIGHT", 0, 0)
	else
		indicator:SetPoint("TOP", cell, "TOPLEFT", 0, 0)
		indicator:SetPoint("BOTTOM", cell, "BOTTOMLEFT", 0, 0)
	end
	indicator:Show()
end

function Main:HideColumnDragVisuals()
	if self.columnDragGhost then
		self.columnDragGhost:SetScript("OnUpdate", nil)
		self.columnDragGhost:Hide()
	end
	if self.columnDropIndicator then
		self.columnDropIndicator:Hide()
	end
	if self.columnDrag and self.columnDrag.frame then
		Utils:SetBackgroundColor(self.columnDrag.frame, 1, 1, 1, 0)
	end
	ResetCursor()
end

function Main:SetupColumnHeaderDrag(cellFrame)
	if cellFrame.columnDragSetup then
		return
	end
	cellFrame.columnDragSetup = true
	cellFrame:RegisterForDrag("LeftButton")
	cellFrame:SetScript("OnDragStart", function(frame)
		self:OnColumnDragStart(frame)
	end)
	cellFrame:SetScript("OnDragStop", function(frame)
		self:OnColumnDragStop(frame)
	end)
end

function Main:OnColumnDragStart(frame)
	local key = frame.columnKey
	if not key then
		return
	end

	local column
	for _, candidate in ipairs(self.columns) do
		if self:GetColumnKey(candidate) == key then
			column = candidate
			break
		end
	end
	if not column or not column.reward then
		return
	end

	self.didColumnDrag = true
	self.columnDrag = { key = key, frame = frame }
	GameTooltip:Hide()
	Utils:SetBackgroundColor(frame, 1, 1, 1, 0.15)
	SetCursor("Interface/CURSOR/openhandglow")

	local ghost = self:GetColumnDragGhost()
	ghost.text:SetText(frame.text and frame.text:GetText() or key)
	ghost:SetWidth(math.max(frame:GetWidth(), 60))
	ghost:SetHeight(frame:GetHeight())
	ghost:SetScale(self.window:GetScale())
	ghost:Show()
	ghost:SetScript("OnUpdate", function(g)
		local x, y = GetCursorPosition()
		local scale = g:GetEffectiveScale()
		g:ClearAllPoints()
		g:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale + 16, y / scale - 8)
		self:UpdateColumnDropIndicator()
	end)
end

function Main:OnColumnDragStop()
	local fromKey = self.columnDrag and self.columnDrag.key
	local _, _, after, target = self:NormalizeRewardDropTarget(self:GetHeaderDropTarget())
	self:HideColumnDragVisuals()
	self.columnDrag = nil

	if not fromKey or not target then
		return
	end

	local toKey = self:GetColumnKey(target)
	if self:MoveColumn(fromKey, toKey, after) then
		Util:Debug("Reordered column:", fromKey, toKey, after)
		ActiveRewards.Get().sortBy = nil
		self:Redraw()
	end
end

function Main:ForEachColumn(callback, visibleOnly)
	local activeRewards = ActiveRewards.Get()

	visibleOnly = visibleOnly or true

	for _, column in ipairs(self.columns) do
		if not visibleOnly then
			callback(column)
			return
		end

		local reward = column.reward
		if reward and activeRewards.excluded[reward.id] ~= true then
			callback(column)
		elseif reward == nil and not WeeklyRewards.db.global.main.hiddenColumns[column.name] then
			callback(column)
		end
	end
end

function Main:Redraw()
	if not self.window then
		self:CreateWindow()
	end
	if not self.window:IsVisible() then
		return
	end

	local windowScale = WeeklyRewards.db.global.main.windowScale / 100
	self.window:SetScale(windowScale)

	local tableWidth = 0
	local tableHeight = 0
	local minWindowWidth = 300
	---@type WK_TableData
	local tableData = {
		columns = {},
		rows = {},
	}

	do -- Refresh
		self.columns = {}
		self:AddCharacterColumns()
		self:AddRewardColumns()
		self:ApplyColumnOrder()
	end

	do -- Table Header row
		---@type WK_TableDataRow
		local row = { columns = {} }
		Main:ForEachColumn(function(dataColumn)
			---@type WK_TableDataCell
			local cell = {
				text = NORMAL_FONT_COLOR:WrapTextInColorCode(dataColumn.name),
				onEnter = function(cellFrame)
					if self.columnDrag then
						return
					end
					if dataColumn.onEnter then
						dataColumn.onEnter(cellFrame)
					end
				end,
				onLeave = dataColumn.onLeave,
				onClick = dataColumn.onClick,
			}
			table.insert(row.columns, cell)
		end)
		table.insert(tableData.rows, row)
		tableHeight = tableHeight + self.window.table.config.header.height
	end

	do -- Table data
		CharacterStore.Get():ForEach(function(character)
			local row = { columns = {} }

			Main:ForEachColumn(function(dataColumn)
				table.insert(row.columns, dataColumn.cell(character))
			end)

			row.onEnter = function(data, columnFrame)
				local rowFrame = columnFrame:GetParent()
				if rowFrame.Highlight then
					rowFrame.Highlight:SetVertexColor(0.3, 0.3, 0.7, 0.2)
				end
			end

			table.insert(tableData.rows, row)
			tableHeight = tableHeight + self.window.table.config.rows.height
		end, function(character) -- filter
			return CharacterStore.IsCurrentPlayer(character) or character.enabled
		end)
	end

	do -- Auto column widths from header and cell text
		local padding = Constants.TABLE_CELL_PADDING * 2
		local col = 0
		Main:ForEachColumn(function(dataColumn)
			col = col + 1
			local headerWidth = self:MeasureTextWidth(dataColumn.name)
			local cellWidth = 0
			for rowIndex = 2, #tableData.rows do
				local cell = tableData.rows[rowIndex].columns[col]
				cellWidth = math.max(cellWidth, self:MeasureTextWidth(cell and cell.text))
			end

			---@type WK_TableDataColumn
			local column = {
				width = math.max(headerWidth, cellWidth) + padding,
				align = dataColumn.align or "LEFT",
			}
			table.insert(tableData.columns, column)
			tableWidth = tableWidth + column.width
		end)
	end

	local desiredTableHeight = WeeklyRewards.db.global.main.windowMaxRows * Constants.TABLE_ROW_HEIGHT + Constants.TABLE_HEADER_HEIGHT

	self.window.border:SetShown(WeeklyRewards.db.global.main.windowBorder)
	self.window.table:SetData(tableData)

	self.window:SetWidth(math.min(math.max(tableWidth, minWindowWidth), GetScreenWidth() * WeeklyRewards.db.global.main.windowMaxRelativeWidth / 100 / windowScale))
	self.window:SetHeight(math.min(GetScreenHeight() / windowScale, math.min(tableHeight, desiredTableHeight) + Constants.TITLEBAR_HEIGHT + 2))

	self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
	self.window.titlebar.title:SetShown(self.window:GetWidth() > (240 / windowScale))
	self.window.titlebar.season:SetShown(self.window:GetWidth() > (600 / windowScale))

	self:UpdateSortArrow()
	self:LayoutHeader(true)
	self:UpdateLayout()
end
