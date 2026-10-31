local addonName, namespace = ...

local Main = {}
namespace.GUIMain = Main

-- Imported by Embeds/WeeklyKnowledge
local Constants = namespace.Constants
local UI = namespace.UI
local Utils = namespace.Utils

local L = namespace.L
local Flags = namespace.Flags
local Settings = namespace.Settings
local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards
local RewardSummary = namespace.RewardSummary

local Tips = namespace.Tips

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

function Main:AddVersionButton()
	WeeklyRewardsVersionButton:SetParent(self.window.titlebar)
	WeeklyRewardsVersionButton:SetPoint("LEFT", self.window.titlebar.title, "RIGHT", 5, -1)
	WeeklyRewardsVersionButton:Show()
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
	self.window.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", self.window.titlebar, "WeeklyRewardsSettingsButtonTemplate")
	self.window.titlebar.SettingsButton:SetPoint("RIGHT", self.window.titlebar.closeButton, "LEFT", 0, 0)
end

function Main:AddCharactersButton()
	self.window.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", self.window.titlebar, "WeeklyRewardsCharactersButtonTemplate")
	self.window.titlebar.CharactersButton:SetPoint("RIGHT", self.window.titlebar.SettingsButton, "LEFT", 0, 0)
end

function Main:AddRewardsFilterButton()
	self.window.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.window.titlebar, "WeeklyRewardsTrackingButtonTemplate")
	self.window.titlebar.ColumnsButton:SetPoint("RIGHT", self.window.titlebar.CharactersButton, "LEFT", 0, 0)
end

function Main:AddAutomationButton()
	self.window.titlebar.AutomationButton = CreateFrame("DropdownButton", "$parentAutomationButton", self.window.titlebar, "WeeklyRewardsAutomationButtonTemplate")
	self.window.titlebar.AutomationButton:SetPoint("RIGHT", self.window.titlebar.ColumnsButton, "LEFT", 0, 0)
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
	local backgroundColor = Settings:Get("windowBackgroundColor")
	Utils:SetBackgroundColor(self.window, backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)

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
	self.window.titlebar.title:SetPoint("LEFT", self.window.titlebar.icon, "RIGHT", 4, 0)
	self.window.titlebar.title:SetJustifyH("LEFT")
	self.window.titlebar.title:SetJustifyV("MIDDLE")
	self.window.titlebar.title:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"))
	self:AddVersionButton()

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
	self:AddAutomationButton()

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

	-- Sticky header is parented outside the scroll child, so follow horizontal scroll from both the wheel and the scrollbar.
	hooksecurefunc(self.window.table.scrollFrame, "SetHorizontalScroll", function()
		self:LayoutHeader()
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

	Tips:SetEnabled(Settings:Get("windowTutorials"))
	Tips:SetOwner(self.window)
	Tips:SetupVerticalScrollBarHelpTip(self.window.table.scrollFrame.scrollbarV)
	Tips:SetupHorizontalScrollBarHelpTip(self.window.table.scrollFrame.scrollbarH)

	Settings:RegisterCallback("^window", function(_, value, key)
		if key == "windowBackgroundColor" then
			Utils:SetBackgroundColor(self.window, value.r, value.g, value.b, value.a)
		elseif key == "windowPlayerRowColor" then
			for _, row in ipairs(self.window.table.rows) do
				if row.data.character and row.data.character:IsCurrent() then
					row:UpdateBackgroundColor(value)
					break
				end
			end
		elseif key == "windowTutorials" then
			Tips:SetEnabled(value)
			Flags:Set("dragTip")
			self.window:Hide()
			self.window:Show()
			self:Redraw()
		elseif self.window and self.window:IsVisible() then
			self:Redraw()
		end
	end, self)

	table.insert(UISpecialFrames, frameName)
end

function Main:ResetCell(character, reward)
	Util:Debug("Reseting cell:", character.name, reward.id)

	local text = CONFIRM_DESTROY_CHARACTER_COMMUNITY:gsub(CLUB_FINDER_COMMUNITY_TYPE:lower(), PVP_PROGRESS_REWARDS_HEADER:lower())

	StaticPopup_ShowGenericConfirmation(text:gsub("|n.*$", ""):format(reward.name), function()
		character:ResetProgress(reward, true)
		character:Scan({ reward }, true)
		character:UpdateProgress()
		self:Redraw()
	end)
end

local function VisibleCharacter(character)
	return CharacterStore.IsCurrentPlayer(character) or character.enabled
end

function Main:AddCharacterColumns()
	if self.columns then
		return self.columns
	end

	self.columns = {
		{
			name = "#",
			tooltip = "",
			align = "CENTER",
			dataMixin = CharacterIndexDataMixin,
		},
		{
			name = NAME,
			key = "name",
			dataMixin = CharacterNameDataMixin,
		},
		{
			name = FRIENDS_LIST_REALM:match("^([^:]+)"),
			key = "realmName",
			dataMixin = CharacterRealmDataMixin,
		},
		{
			name = LEVEL,
			key = "level",
			align = "CENTER",
			dataMixin = CharacterLevelDataMixin,
		},
		{
			name = ITEM_LEVEL_ABBR,
			key = "itemLevels",
			align = "CENTER",
			dataMixin = CharacterItemLevelDataMixin,
		},
		{
			name = FACTION,
			key = "factionName",
			align = "CENTER",
			dataMixin = CharacterFactionDataMixin,
		},
		{
			name = L["column_covenant"],
			key = "covenant",
			align = "CENTER",
			dataMixin = CharacterCovenantDataMixin,
		},
		{
			name = Util.Capitalize(SPELL_TARGET_TYPE6_DESC),
			key = "location",
			align = "CENTER",
			dataMixin = CharacterLocationDataMixin,
		},
		{
			name = LASTONLINE,
			key = "lastUpdate",
			align = "CENTER",
			dataMixin = CharacterLastUpdateDataMixin,
		},
	}
	return self.columns
end

function Main:AddRewardColumns(columns, numColumns)
	for index, reward in ActiveRewards.Get():EnumerateSelected() do
		numColumns = numColumns + 1

		if #columns < numColumns then
			table.insert(columns, {})
		end

		local header = columns[numColumns]
		header.name = reward.name
		header.key = nil
		header.reward = reward
		header.text = reward.name
		header.align = "CENTER"
		header.dataMixin = RewardDataMixin
		header.tooltip = nil
		header.selectedIndex = index
		header.width = self:MeasureTextWidth(header.text)
	end

	return numColumns
end

function Main:AddRewardObjectivesToGameTooltip(tooltip, reward)
	local redx = CreateAtlasMarkup("common-icon-redx", 12, 12)

	for _, objective in ipairs(reward.objectives) do
		local text, isMultiline = objective:GetDescription()
		GameTooltip_AddColoredDoubleLine(tooltip, text, isMultiline and "" or redx, WHITE_FONT_COLOR, WHITE_FONT_COLOR, false)
	end
end

function Main:AddProgressToGameTooltip(progress)
	local questColor = progress:ObjectivesCount() == 1 and YELLOW_FONT_COLOR or WHITE_FONT_COLOR

	local tooltip = GameTooltip
	local expired = progress:IsExpired()
	local status = expired and ("|cnGRAY_FONT_COLOR:(%s)|r"):format(RAID_INSTANCE_EXPIRES_EXPIRED) or ""
	local redx, checkmark = CreateAtlasMarkup("common-icon-redx", 12, 12), CreateAtlasMarkup("common-icon-checkmark", 12, 12)

	if progress.numObjectives > 1 then
		-- Show quests as high-level objectives
		GameTooltip:AddDoubleLine(YELLOW_FONT_COLOR:WrapTextInColorCode(progress.name), status)
		progress:ForEachObjective(function(objective, completed)
			local color = (expired or completed) and GRAY_FONT_COLOR or WHITE_FONT_COLOR
			local text = progress:GetCachedObjectiveName(objective)

			GameTooltip_AddColoredDoubleLine(tooltip, text, completed and checkmark or redx, color, WHITE_FONT_COLOR, false)
		end)
	else
		local questName = QuestUtils_GetQuestName(progress:Quest()) or ""
		GameTooltip:AddDoubleLine(YELLOW_FONT_COLOR:WrapTextInColorCode(#questName > 0 and questName or progress.name), status)
		-- Show objectives of single quest
		progress:ForEachRecord(function(record, completed)
			local color = (expired or completed) and GRAY_FONT_COLOR or WHITE_FONT_COLOR
			local text = Util:ResolveTags(record.text or UNKNOWN, true)

			GameTooltip_AddColoredDoubleLine(tooltip, text, record.s or completed and checkmark or redx, color, WHITE_FONT_COLOR, false)
		end)
	end

	if progress.claimedAt then
		local duration = progress.startedAt and format(" (%s used)", Util.FormatTimeDuration(progress.claimedAt - progress.startedAt, true)) or ""
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["progress_rewards_received_at"], WHITE_FONT_COLOR:WrapTextInColorCode(date("%m-%d %H:%M", progress.claimedAt) .. duration))
	elseif progress.startedAt then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["progress_started_at"], WHITE_FONT_COLOR:WrapTextInColorCode(date("%m-%d %H:%M", progress.startedAt)))
	elseif progress:IsNotStarted() then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["progress_not_started"])
	end

	if progress.rewards then
		if not progress.claimedAt then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["progress_rewards_received"])
		end
		RewardSummary.AddRewardsToTooltip(progress.rewards)
	end

	if progress.drops then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["progress_drops"])
		RewardSummary.AddRewardsToTooltip(progress.drops)
	end
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
	for i, row in ipairs(self.window.table.rows) do
		if i == 1 then
			Mixin(row, WeeklyRewardsTableHeaderRowMixin)
		elseif i > 1 then
			Mixin(row, WeeklyRewardsTableDataRowMixin)
			row.index = i
		end

		row.window = self.window
		row:OnLoad()

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

function Main:ForEachColumn(callback, visibleOnly)
	local activeRewards = ActiveRewards.Get()
	local hiddenColumns = Settings:Get("hiddenColumns")

	visibleOnly = visibleOnly or true

	for _, column in ipairs(self.columns) do
		if not visibleOnly then
			callback(column)
			return
		end

		local reward = column.reward
		if reward and not activeRewards:IsCandidateExcluded(reward:GetCandidateID()) then
			callback(column)
		elseif reward == nil and not hiddenColumns[column.name] then
			callback(column)
		end
	end
end

local Columns = {}
function Main:Allocate()
	self:AddCharacterColumns()
	self.data = self.data or { columns = Columns, rows = { { columns = Columns } } }

	local hiddenColumns = Settings:Get("hiddenColumns")
	local showRowNumbers = Settings:Get("windowRowNumbers")
	local numColumns = 0

	for _, def in ipairs(self.columns) do
		local hideRowNumber = def.name == "#" and not showRowNumbers
		if not hideRowNumber and not hiddenColumns[def.name] then
			numColumns = numColumns + 1

			if #self.data.columns < numColumns then
				table.insert(self.data.columns, {})
			end

			local header = self.data.columns[numColumns]
			header.name = def.name
			header.key = def.key
			header.reward = nil
			header.text = def.name
			header.align = def.align
			header.dataMixin = def.dataMixin
			header.tooltip = def.tooltip
			header.selectedIndex = nil
			header.width = self:MeasureTextWidth(header.text)
		end
	end

	numColumns = self:AddRewardColumns(self.data.columns, numColumns)

	if #self.data.columns > numColumns then
		for j = #self.data.columns, numColumns + 1, -1 do
			table.remove(self.data.columns, j)
		end
	end

	self.shownCharacters = {}
	for _, character in ipairs(CharacterStore.Get():ForEach(nop, VisibleCharacter)) do
		table.insert(self.shownCharacters, character)
	end

	local numRows = #self.shownCharacters + 1
	for i = 2, numRows do
		if #self.data.rows < i then
			table.insert(self.data.rows, { columns = {} })
		end

		local row = self.data.rows[i]
		if #row.columns > numColumns then
			for j = #row.columns, numColumns + 1, -1 do
				table.remove(row.columns, j)
			end
		elseif #row.columns < numColumns then
			for j = #row.columns, numColumns do
				table.insert(row.columns, {})
			end
		end
	end

	while #self.data.rows > numRows do
		table.remove(self.data.rows)
	end
end

function Main:Columns()
	for i, character in ipairs(self.shownCharacters) do
		local row = self.data.rows[i + 1]
		row.character = character

		for j, header in ipairs(self.data.columns) do
			local cell = row.columns[j]
			cell.character = character
			cell.reward = header.reward
			cell.index = i
			cell.onEnter = nil
			cell.onLeave = nil
			cell.onClick = nil
			cell.text = header.dataMixin:GetText(cell)
			header.width = math.max(header.width, self:MeasureTextWidth(cell.text))
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

	local windowScale = Settings:Get("windowScale")
	self.window:SetScale(windowScale)

	local tableWidth = 0
	local tableHeight = 0
	local minWindowWidth = 300

	self:Allocate()
	self:Columns()

	local padding = Constants.TABLE_CELL_PADDING * 2
	tableHeight = (#self.data.rows - 1) * self.window.table.config.rows.height + self.window.table.config.header.height
	for _, header in ipairs(self.data.columns) do
		header.width = header.width + padding
		tableWidth = tableWidth + header.width
	end

	local desiredTableHeight = Settings:Get("windowMaxRows") * Constants.TABLE_ROW_HEIGHT + Constants.TABLE_HEADER_HEIGHT

	self.window.border:SetShown(Settings:Get("windowBorder"))
	self.window.table:SetData(self.data)

	self.window:SetWidth(math.min(math.max(tableWidth, minWindowWidth), GetScreenWidth() * Settings:Get("windowMaxRelativeWidth") / windowScale))
	self.window:SetHeight(math.min(GetScreenHeight() / windowScale, math.min(tableHeight, desiredTableHeight) + Constants.TITLEBAR_HEIGHT + 2))

	self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
	self.window.titlebar.title:SetShown(self.window:GetWidth() > (240 / windowScale))
	self.window.titlebar.season:SetShown(self.window:GetWidth() > (600 / windowScale))

	self:LayoutHeader(true)
	self:UpdateLayout()
end
