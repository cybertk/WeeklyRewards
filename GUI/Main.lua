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
	self.window.titlebar.closeButton.Icon:SetSize(10, 10)
	self.window.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyRewards/Embeds/WeeklyKnowledge/Media/Icon_Close.blp")
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
	self.window.titlebar.SettingsButton.Icon:SetSize(12, 12)
	self.window.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyRewards/Embeds/WeeklyKnowledge/Media/Icon_Settings.blp")
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
	self.window.titlebar.CharactersButton.Icon:SetSize(14, 14)
	self.window.titlebar.CharactersButton.Icon:SetTexture("Interface/AddOns/WeeklyRewards/Embeds/WeeklyKnowledge/Media/Icon_Characters.blp")
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

		local groupButtons = {}

		for _, column in ipairs(self.columns) do
			if column.reward == nil then
				rootMenu:CreateCheckbox(column.name, function()
					return not hidden[column.name]
				end, function(columnName)
					hidden[columnName] = not hidden[columnName]
					self:Redraw()
				end, column.name)
			else
				local reward = column.reward

				-- level 1
				if reward.group and groupButtons[reward.group] == nil then
					groupButtons[reward.group] = rootMenu:CreateCheckbox(reward.group, function()
						return not activeRewards:IsGroupExcluded(reward.group)
					end, function(columnName)
						activeRewards:ToggleExclusionByGroup(reward.group)
						self:Redraw()
					end, column.name)
				end

				local groupButton = reward.group and groupButtons[reward.group] or rootMenu

				-- level 2
				groupButton:CreateCheckbox(reward.name, function()
					return not activeRewards:IsExcluded(reward.id)
				end, function()
					activeRewards:ToggleExclusion(reward.id)
					self:Redraw()
				end, column.name)
			end
		end
	end)

	self.window.titlebar.ColumnsButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
	self.window.titlebar.ColumnsButton.Icon:SetPoint("CENTER", self.window.titlebar.ColumnsButton, "CENTER")
	self.window.titlebar.ColumnsButton.Icon:SetSize(12, 12)
	self.window.titlebar.ColumnsButton.Icon:SetTexture("Interface/AddOns/WeeklyRewards/Embeds/WeeklyKnowledge/Media/Icon_Columns.blp")
	self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
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
				self:Redraw()
			end)
		end
		-- end
	end)

	self.window.titlebar.SortButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.SortButton:GetName() .. "Icon", "ARTWORK")
	self.window.titlebar.SortButton.Icon:SetPoint("CENTER", self.window.titlebar.SortButton, "CENTER")
	self.window.titlebar.SortButton.Icon:SetSize(14, 14)
	self.window.titlebar.SortButton.Icon:SetTexture("Interface/AddOns/WeeklyRewards/Embeds/WeeklyKnowledge/Media/Icon_Toggle.blp")
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
			width = 90,
			cell = function(character)
				return { text = Util.WrapTextInClassColor(character.class, character.name) }
			end,
		},
		{
			name = L["column_realm"],
			key = "realmName",
			width = 90,
			cell = function(character)
				return { text = character.realmName }
			end,
		},
		{
			name = LEVEL,
			key = "level",
			width = 50,
			align = "CENTER",
			cell = function(character)
				return { text = character.level }
			end,
		},
		{
			name = FACTION,
			key = "factionName",
			width = 60,
			align = "CENTER",
			cell = function(character)
				return { text = character.factionName }
			end,
		},
		{
			name = L["column_covenant"],
			key = "covenant",
			width = 70,
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
			width = 90,
			align = "CENTER",
			cell = function(character)
				return { text = character.location }
			end,
		},
		{
			name = L["column_last_update"],
			key = "lastUpdate",
			width = 60,
			align = "CENTER",
			cell = function(character)
				return { text = Util.FormatLastUpdateTime(character.lastUpdate) }
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
			width = 70,
			toggleHidden = true,
			align = "CENTER",
			cell = function(character)
				local progress = character.progress[reward.id]
				if progress == nil then
					return ""
				end

				local text = format("%d / %d", progress.position, progress.total)
				if progress.hasClaimed and progress:hasClaimed() then
					text = CreateAtlasMarkup("common-icon-checkmark", 15, 15)
				elseif progress.hasStarted and progress:hasStarted() then
					text = YELLOW_FONT_COLOR:WrapTextInColorCode(text)
				end

				return {
					text = text,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						self:AddProgressToGameTooltip(progress)
						cellFrame.hasInstructions = nil
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

	if progress:ObjectivesCount() > 1 then
		-- Show quests as high-level objectives
		GameTooltip:AddLine(YELLOW_FONT_COLOR:WrapTextInColorCode(progress.name))
		progress:ForEachObjective(function(objective, completed)
			GameTooltip:AddDoubleLine(
				WHITE_FONT_COLOR:WrapTextInColorCode("- " .. progress:GetCachedObjectiveName(objective)),
				CreateAtlasMarkup(completed and "common-icon-checkmark" or "common-icon-redx", 12, 12)
			)
		end)
	else
		local questName = QuestUtils_GetQuestName(progress:Quest()) or ""
		GameTooltip:AddLine(YELLOW_FONT_COLOR:WrapTextInColorCode(#questName > 0 and questName or progress.name))
		-- Show objectives of single quest
		progress:ForEachRecord(function(record, completed)
			GameTooltip:AddDoubleLine(
				WHITE_FONT_COLOR:WrapTextInColorCode("- " .. record.text or "Loading"),
				CreateAtlasMarkup(completed and "common-icon-checkmark" or "common-icon-redx", 12, 12)
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
	if reward.group then
		GameTooltip:AddLine(reward.group .. ": " .. WHITE_FONT_COLOR:WrapTextInColorCode(reward.description))
	else
		GameTooltip:AddLine(WHITE_FONT_COLOR:WrapTextInColorCode(reward.description))
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["reward_rewards"])

	local items = reward:ForEachItem(function(item)
		GameTooltip:AddLine(Util.FormatItem(item))
	end)
	if #items == 0 then
		GameTooltip:AddLine(WHITE_FONT_COLOR:WrapTextInColorCode(LFG_LIST_LOADING))
	end

	GameTooltip:AddLine(" ")

	if reward.resetTime then
		GameTooltip:AddLine(L["reward_time_left"] .. WHITE_FONT_COLOR:WrapTextInColorCode(Util.FormatTimeDuration(reward.resetTime - GetServerTime())))
	end
end

function Main:UpdateSortArrow()
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()

	local i = 0
	Main:ForEachColumn(function(column)
		i = i + 1

		local cellFrame = self.window.table.rows[1].columns[i]
		local characterField = column.key or column.reward.id

		cellFrame.data.onClick = function()
			if IsControlKeyDown() then
				if column.reward then
					ActiveRewards.Get():ToggleExclusion(column.reward.id)
				else
					WeeklyRewards.db.global.main.hiddenColumns[column.name] = true
				end
			else
				CharacterStore.Get():SetSortOrder(characterField)
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
	end

	do -- Table Column config
		Main:ForEachColumn(function(dataColumn)
			local text = self.window:CreateFontString("$parentText", "OVERLAY")
			text:SetFontObject("GameFontHighlightSmall")
			text:SetText(dataColumn.name)

			---@type WK_TableDataColumn
			local column = {
				width = math.max(text:GetStringWidth() + 16, dataColumn.width),
				align = dataColumn.align or "LEFT",
			}
			table.insert(tableData.columns, column)
			tableWidth = tableWidth + column.width
		end)
	end

	do -- Table Header row
		---@type WK_TableDataRow
		local row = { columns = {} }
		Main:ForEachColumn(function(dataColumn)
			---@type WK_TableDataCell
			local cell = {
				text = NORMAL_FONT_COLOR:WrapTextInColorCode(dataColumn.name),
				onEnter = dataColumn.onEnter,
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

	local windowScale = WeeklyRewards.db.global.main.windowScale / 100
	local desiredTableHeight = WeeklyRewards.db.global.main.windowMaxRows * Constants.TABLE_ROW_HEIGHT + Constants.TABLE_HEADER_HEIGHT

	self.window.border:SetShown(WeeklyRewards.db.global.main.windowBorder)
	self.window.table:SetData(tableData)

	self.window:SetWidth(math.min(math.max(tableWidth, minWindowWidth), GetScreenWidth() * WeeklyRewards.db.global.main.windowMaxRelativeWidth / 100 / windowScale))
	self.window:SetHeight(math.min(GetScreenHeight() / windowScale, math.min(tableHeight, desiredTableHeight) + Constants.TITLEBAR_HEIGHT + 2))

	self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
	self.window:SetScale(windowScale)
	self.window.titlebar.title:SetShown(self.window:GetWidth() > (240 / windowScale))

	self:UpdateSortArrow()
	self:LayoutHeader(true)
end
