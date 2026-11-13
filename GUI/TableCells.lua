local _, namespace = ...

local L = namespace.L
local Settings = namespace.Settings
local Util = namespace.Util
local Dialogs = namespace.Dialogs
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards
local RewardSummary = namespace.RewardSummary

local TableCellMixin = { padding = 8 }

function TableCellMixin:OnLoad()
	-- self.Text = self.text
	if self.text then
		self.text:Hide()
	end
	self:SetScript("OnShow", self.OnShow)
end

function TableCellMixin:OnShow()
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
	self:SetScript("OnClick", self.OnClick)
end

function TableCellMixin:OnEnter()
	print("OnEnter")

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	self:AddExtraStuffToTooltip(GameTooltip)
	GameTooltip:Show()

	if not self:IsEventRegistered("MODIFIER_STATE_CHANGED") then
		self:RegisterEvent("MODIFIER_STATE_CHANGED")
		self:SetScript("OnEvent", self.OnModifierStateChanged)
	end
end

function TableCellMixin:OnLeave()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", nil)

	GameTooltip:Hide()
end

function TableCellMixin:AddExtraStuffToTooltip(tooltip) end

local TableHeaderCellMixin = CreateFromMixins(TableCellMixin)

function TableHeaderCellMixin:OnLoad()
	TableCellMixin.OnLoad(self)

	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:SetSize(20, 20)

	self.Text = self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFontObject("GameFontHighlightSmall")
	self.Text:SetPoint("LEFT", self.Icon, "RIGHT", 5, 0)
	self.Text:SetText(self.data.text)
	self.Text:SetTextColor(NORMAL_FONT_COLOR:GetRGB())

	self.Arrow = self:CreateTexture(nil, "ARTWORK")
	self.Arrow:SetAtlas("auctionhouse-ui-sortarrow", true)
	self.Arrow:SetPoint("LEFT", self.Text, "RIGHT", 1, 1)

	self:SetHighlightTexture("auctionhouse-ui-row-highlight", "ADD")

	self:SetScript("OnEnable", self.OnEnable)
	self:SetScript("OnDisable", self.OnDisable)
end

function TableHeaderCellMixin:OnEnable()
	self:UpdateArrow()
end

function TableHeaderCellMixin:OnDisable()
	self.Arrow:Hide()
end

function TableHeaderCellMixin:OnClick()
	local sortKey = self:GetSortKey()

	if not sortKey then
		return
	end

	if IsControlKeyDown() then
		self:HideColumn()
	else
		CharacterStore.Get():SetSortOrder(sortKey)

		local field, ascending = CharacterStore.Get():GetSortOrder()
		Settings:Set("sortColumn", field)
		Settings:Set("sortAscending", ascending)
	end

	namespace.GUIMain:Redraw()

	local mainWindow = namespace.GUIMain.window
	if namespace.GUITable and namespace.GUITable:IsShown() and not (mainWindow and mainWindow:IsVisible()) then
		namespace.GUITable:Refresh()
	end
end

local function DragTableBuilderWindow()
	if namespace.GUITable then
		namespace.GUITable:DragStart()
	end
end

local function StopDragTableBuilderWindow()
	if namespace.GUITable then
		namespace.GUITable:DragStop()
	end
end

function TableHeaderCellMixin:Init(data)
	self.data = data
	if not self.Arrow then
		self:OnLoad()
	else
		self.Text:SetText(data.text)
	end
	self.Text:SetWordWrap(false)
	self:Layout()

	self:RegisterForDrag("RightButton")
	self:SetScript("OnDragStart", DragTableBuilderWindow)
	self:SetScript("OnDragStop", StopDragTableBuilderWindow)
end

function TableHeaderCellMixin:AddRewardToGameTooltip(reward)
	local tooltip = GameTooltip

	GameTooltip:AddDoubleLine(reward.name, "|A:NPE_LeftClick:16:16|a|cnGREEN_FONT_COLOR:(" .. (IsControlKeyDown() and HIDE or STABLE_FILTER_BUTTON_LABEL) .. ")|r")
	GameTooltip_AddColoredLine(tooltip, reward:GetGroupName(), GREEN_FONT_COLOR)
	GameTooltip_AddNormalLine(tooltip, reward:GetDescription())

	GameTooltip:AddLine(" ")

	if reward.resetTime then
		GameTooltip:AddLine(L["reward_time_left"] .. WHITE_FONT_COLOR:WrapTextInColorCode(Util.FormatTimeDuration(reward.resetTime - GetServerTime())))
	end

	GameTooltip:AddLine(" ")
	RewardSummary:Create(reward.id):AddToTooltip(GameTooltip)
end

function TableHeaderCellMixin:GetSortKey() end

function TableHeaderCellMixin:Layout()
	self:UpdateArrow()

	if self.Icon:IsShown() then
		self:UpdateIcon()
		-- self.Icon:SetPoint("CENTER", self.Text:IsShown() and -self.Text:GetWidth() / 2 or 0, 0)
	end

	self.Icon:ClearAllPoints()
	self.Text:ClearAllPoints()
	if self.Icon:IsShown() and self.Text:IsShown() then
		self.Icon:SetPoint("RIGHT", self.Text, "LEFT")
		self.Text:SetPoint("CENTER", self.Icon:GetWidth() / 2, 0)
	elseif self.Icon:IsShown() then
		self.Icon:SetPoint("CENTER")
	else
		self.Text:SetPoint(self.data.align or "LEFT", self.data.align == "LEFT" and self.padding or 0, 0)
	end

	-- if self.Text:IsShown() then
	-- 	local iconWidth = self.Icon:IsShown() and self.Icon:GetWidth() or 0
	-- 	self.Text:SetPoint(self.data.align or "CENTER", self.data.align == "LEFT" and self.padding + iconWidth or 0, 0)
	-- end

	-- self.Text:SetWidth(self.showIconOnly and 0 or 1)
	-- -- self.Text:Hide()
	-- self.Icon:SetWidth(self:GetIconAtlas() and 20 or 0)
	-- -- self.Text:SetWidth(self.showIconOnly and 0 or self.data.width)
	-- self.Text:SetWidth(self.showIconOnly and 0 or 1)

	-- print("width", self.Text:GetWidth(), "icon width", self.Icon:GetWidth())

	-- if self.data.align == "LEFT" then
	-- 	self.Icon:SetPoint("LEFT", self.padding)
	-- else
	-- 	self.Icon:SetPoint("CENTER", 0, 0)
	-- 	-- self.Icon:SetPoint("CENTER", -self.Text:GetWidth() / 2, 0)
	-- end

	-- self.Text:ClearAllPoints()
	-- print("align", self.data.align)
	-- self.Text:SetPoint(self.data.align or "CENTER")
	-- -- self.Text:SetText()

	-- print("layu")
end

function TableHeaderCellMixin:UpdateArrow()
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()
	local sortKey = self:GetSortKey()

	self.Arrow:SetShown(sortOrder == sortKey)

	if sortOrder == sortKey then
		if ascending then
			self.Arrow:SetTexCoord(0, 1, 0, 1)
		else
			self.Arrow:SetTexCoord(0, 1, 1, 0)
		end
	end
end

local TableHeaderCellCharacterMixin = CreateFromMixins(TableHeaderCellMixin)

function TableHeaderCellCharacterMixin:OnLoad()
	TableHeaderCellMixin.OnLoad(self)
	self.Icon:Hide()
	self.Text:Show()
end

function TableHeaderCellCharacterMixin:GetSortKey()
	return self.data.key
end

function TableHeaderCellCharacterMixin:HideColumn()
	print("HideColumn", self.data.key)
	Settings:Get("hiddenColumns")[self.data.text] = true
end

function TableHeaderCellCharacterMixin:AddExtraStuffToTooltip(tooltip)
	print("AddExtraStuffToTooltip")

	tooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
end

local TableHeaderCellRewardMixin = CreateFromMixins(TableHeaderCellMixin)

function TableHeaderCellRewardMixin:GetSortKey()
	return self.data.reward.id
end

function TableHeaderCellRewardMixin:UpdateIcon()
	if self.data.reward.texture then
		self.Icon:SetTexture(self.data.reward.texture)
		self.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	else
		self.Icon:SetAtlas(GetRandomArrayEntry({
			"poi-prey",
			"worldquest-Capstone-questmarker-epic-Toast",
			"worldquest-icon-boss",
			"vignettekillboss",
			"quest-wrapper-available",
			"UI-EventPoi-abundancebountiful-2x",
			"UI-EventPoi-stormarionassault",
			"UI-EventPoi-legendsoftheharanir",
			"UI-EventPoi-venomoustides",
			"UI-eventpoi-ulatekminor",
			"UI-EventPoi-venomoustides",
			"UI-EventPoi-ecodome",
			"UI-EventPoi-AqirInvasion",
			"ui-eventpoi-saltherilssoiree",
		}))
	end
end

function TableHeaderCellRewardMixin:HideColumn()
	ActiveRewards.Get():ToggleExclusion(self.data.reward:GetCandidateID())
end

function TableHeaderCellRewardMixin:AddExtraStuffToTooltip(tooltip)
	print("AddExtraStuffToTooltip")
	self:AddRewardToGameTooltip(self.data.reward)
end

local TableDataCellMixin = CreateFromMixins(TableCellMixin)

function TableDataCellMixin:Init(column)
	self.column = column
	self.Text:SetWordWrap(false)

	self:RegisterForDrag("RightButton")
	self:SetScript("OnDragStart", DragTableBuilderWindow)
	self:SetScript("OnDragStop", StopDragTableBuilderWindow)
end

function TableDataCellMixin:Populate(rowData, columnIndex)
	local cell = rowData.columns and rowData.columns[columnIndex]
	self.cellData = cell

	local align = self.column and self.column.align or "CENTER"
	self.Text:SetJustifyH(align)
	self.Text:ClearAllPoints()
	local pad = align == "LEFT" and self.padding or 0
	self.Text:SetPoint(align, self, align, pad, 0)

	local text = ""
	if cell and cell.text ~= nil then
		text = type(cell.text) == "string" and cell.text or tostring(cell.text)
	end
	self.Text:SetText(text)
end

function TableDataCellMixin:OnEnter()
	local cell = self.cellData
	if cell and cell.onEnter then
		cell.onEnter(self)
	end
end

function TableDataCellMixin:OnLeave()
	local cell = self.cellData
	if cell and cell.onLeave then
		cell.onLeave(self)
	end
end

function TableDataCellMixin:OnClick()
	local cell = self.cellData
	if cell and cell.onClick then
		cell.onClick(self:GetParent(), self)
	end
end

WeeklyRewardsTableHeaderCellCharacterMixin = TableHeaderCellCharacterMixin
WeeklyRewardsTableHeaderCellRewardMixin = TableHeaderCellRewardMixin
WeeklyRewardsTableDataCellMixin = TableDataCellMixin
