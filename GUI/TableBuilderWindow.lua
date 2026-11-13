local addonName, namespace = ...

local Constants = namespace.Constants
local Utils = namespace.Utils
local Settings = namespace.Settings

local GUITable = {}
namespace.GUITable = GUITable

local VBAR_WIDTH = 25
local HBAR_HEIGHT = 25

local function ColumnSignature(columns)
	local parts = {}
	for index, header in ipairs(columns) do
		parts[index] = string.format(
			"%s\1%s\1%d\1%s\1%s",
			header.key or "",
			header.text or "",
			math.floor((header.width or 0) + 0.5),
			header.align or "",
			tostring(header.selectedIndex or "")
		)
	end
	return table.concat(parts, "\2")
end

function GUITable:IsShown()
	return self.window ~= nil and self.window:IsShown()
end

function GUITable:DragStart()
	if self.window then
		self.window:StartMoving()
	end
end

function GUITable:DragStop()
	if self.window then
		self.window:StopMovingOrSizing()
	end
end

function GUITable:SetHeaderOffset(offset)
	self.headerContainer:ClearAllPoints()
	self.headerContainer:SetPoint("TOPLEFT", self.headerClip, "TOPLEFT", -offset, 0)
end

function GUITable:ApplyHorizontalOffset()
	local clipWidth = self.headerClip:GetWidth()
	local contentWidth = math.max(self.contentWidth or 0, clipWidth)
	local maxOffset = math.max(0, contentWidth - clipWidth)
	local percentage = maxOffset > 0 and self.hScrollBar:GetScrollPercentage() or 0
	local offset = maxOffset * percentage

	self.headerContainer:SetSize(contentWidth, self.headerClip:GetHeight())
	self.scrollBox:SetSize(contentWidth, self.bodyClip:GetHeight())
	self.hScroll:SetHorizontalScroll(offset)
	self:SetHeaderOffset(offset)
end

function GUITable:UpdateHorizontalRange()
	local clipWidth = self.headerClip:GetWidth()
	local contentWidth = self.contentWidth or 0
	local visible = 1
	if contentWidth > 0 then
		visible = math.min(1, clipWidth / contentWidth)
	end

	self.hScrollBar:SetVisibleExtentPercentage(visible)
	self.hScrollBar:SetScrollAllowed(contentWidth - clipWidth > 1)
	if contentWidth - clipWidth <= 1 then
		self.hScrollBar:SetScrollPercentage(0)
	end
	self:ApplyHorizontalOffset()
end

function GUITable:UpdateSize(contentWidth, rowCount)
	local windowScale = Settings:Get("windowScale")
	self.window:SetScale(windowScale)

	local visibleCap = GetScreenWidth() * Settings:Get("windowMaxRelativeWidth") / windowScale
	local windowWidth = math.min(math.max(contentWidth + VBAR_WIDTH, 300), visibleCap)
	local visibleWidth = windowWidth - VBAR_WIDTH

	local rowHeight = Constants.TABLE_ROW_HEIGHT
	local headerHeight = Constants.TABLE_HEADER_HEIGHT
	local bodyHeight = math.min(math.max(rowCount, 1) * rowHeight, Settings:Get("windowMaxRows") * rowHeight)
	local windowHeight = math.min(GetScreenHeight() / windowScale, headerHeight + bodyHeight + HBAR_HEIGHT)
	bodyHeight = windowHeight - headerHeight - HBAR_HEIGHT

	self.window:SetSize(windowWidth, windowHeight)
	self.headerClip:SetSize(visibleWidth, headerHeight)
	self.bodyClip:SetSize(visibleWidth, bodyHeight)
end

function GUITable:RebuildColumns(columns)
	if self.scrollBox:HasDataProvider() then
		self.scrollBox:RemoveDataProvider()
	end
	self.tableBuilder:Reset()

	local padding = (Constants.TABLE_CELL_PADDING or 0) * 2
	local totalWidth = 0

	for _, header in ipairs(columns) do
		local column = self.tableBuilder:AddColumn()
		local width = (header.width or 0) + padding
		column:SetFixedConstraints(width, 0)
		totalWidth = totalWidth + width

		local headerTemplate = header.selectedIndex and "WeeklyRewardsTableHeaderCellRewardTemplate" or "WeeklyRewardsTableHeaderCellCharacterTemplate"
		column:ConstructHeader("Button", headerTemplate, header)
		column:ConstructCells("Button", "WeeklyRewardsTableDataCellTemplate", header)
	end

	self.headerContainer:SetWidth(math.max(totalWidth, 1))
	self.tableBuilder:SetTableWidth(math.max(totalWidth, 1))
	self.tableBuilder:Arrange()
	return totalWidth
end

function GUITable:SetRowData(rows)
	local list = {}
	for index = 2, #rows do
		list[#list + 1] = rows[index]
	end
	self.scrollBox:SetDataProvider(CreateDataProvider(list), ScrollBoxConstants.RetainScrollPosition)
end

function GUITable:Refresh(dataReady)
	if not self:IsShown() then
		return
	end

	local main = namespace.GUIMain
	if not dataReady then
		main:RefreshAllData()
	end

	local data = main.data
	if not data then
		return
	end

	local signature = ColumnSignature(data.columns)
	if signature ~= self.columnSignature then
		self.contentWidth = self:RebuildColumns(data.columns)
		self.columnSignature = signature
	end

	local color = Settings:Get("windowBackgroundColor")
	Utils:SetBackgroundColor(self.window, color.r, color.g, color.b, color.a)

	self:UpdateSize(self.contentWidth or 0, math.max(#data.rows - 1, 0))
	self:UpdateHorizontalRange()
	self:SetRowData(data.rows)
end

function GUITable:CreateWindow()
	local frameName = addonName .. "TableBuilderWindow"
	local window = CreateFrame("Frame", frameName, UIParent)
	self.window = window

	window:SetFrameStrata("MEDIUM")
	window:SetToplevel(true)
	window:SetClampedToScreen(true)
	window:SetMovable(true)
	window:EnableMouse(true)
	window:SetPoint("CENTER", UIParent, "CENTER", 40, -40)
	window:RegisterForDrag("RightButton")
	window:SetScript("OnDragStart", function()
		self:DragStart()
	end)
	window:SetScript("OnDragStop", function()
		self:DragStop()
	end)
	window:Hide()

	local color = Settings:Get("windowBackgroundColor")
	Utils:SetBackgroundColor(window, color.r, color.g, color.b, color.a)

	self.headerClip = CreateFrame("Frame", nil, window)
	self.headerClip:SetPoint("TOPLEFT", window, "TOPLEFT", 0, 0)
	self.headerClip:SetClipsChildren(true)

	self.bodyClip = CreateFrame("Frame", nil, window)
	self.bodyClip:SetPoint("TOPLEFT", self.headerClip, "BOTTOMLEFT", 0, 0)
	self.bodyClip:SetClipsChildren(true)

	self.headerContainer = CreateFrame("Frame", nil, self.headerClip)
	self.headerContainer:SetSize(300, Constants.TABLE_HEADER_HEIGHT)

	self.hScroll = CreateFrame("ScrollFrame", nil, self.bodyClip)
	self.hScroll:SetAllPoints(self.bodyClip)
	self.hScroll:EnableMouseWheel(false)
	self.hScroll:SetScript("OnHorizontalScroll", function(_, offset)
		self:SetHeaderOffset(offset)
	end)
	self.hScroll:SetScript("OnScrollRangeChanged", function(frame)
		if not self.hScrollBar then
			return
		end

		local clipWidth = self.headerClip:GetWidth()
		local maxOffset = math.max(0, (self.contentWidth or 0) - clipWidth)
		local percentage = maxOffset > 0 and self.hScrollBar:GetScrollPercentage() or 0
		local offset = maxOffset * percentage
		if math.abs(frame:GetHorizontalScroll() - offset) > 0.5 then
			frame:SetHorizontalScroll(offset)
		end
	end)

	self.scrollBox = CreateFrame("Frame", nil, self.hScroll, "WowScrollBoxList")
	self.hScroll:SetScrollChild(self.scrollBox)

	self.vScrollBar = CreateFrame("EventFrame", nil, window, "WowTrimScrollBar")
	self.vScrollBar:SetWidth(VBAR_WIDTH)
	self.vScrollBar:SetPoint("TOPLEFT", self.bodyClip, "TOPRIGHT", 0, 0)
	self.vScrollBar:SetPoint("BOTTOMLEFT", self.bodyClip, "BOTTOMRIGHT", 0, 0)

	self.hScrollBar = CreateFrame("EventFrame", nil, window, "WowTrimHorizontalScrollBar")
	self.hScrollBar:SetHeight(HBAR_HEIGHT)
	self.hScrollBar:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", 0, 0)
	self.hScrollBar:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -VBAR_WIDTH, 0)
	self.hScrollBar:RegisterCallback("OnScroll", function()
		self:ApplyHorizontalOffset()
	end, self)

	local view = CreateScrollBoxListLinearView()
	view:SetElementExtent(Constants.TABLE_ROW_HEIGHT)
	view:SetElementInitializer("WeeklyRewardsTableDataRowTemplate", function(row, elementData)
		row.data = elementData
	end)
	ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.vScrollBar, view)

	self.tableBuilder = CreateTableBuilder()
	self.tableBuilder:SetHeaderContainer(self.headerContainer)
	self.tableBuilder:SetTableMargins(0, 0)
	self.tableBuilder:SetColumnHeaderOverlap(0)
	self.tableBuilder:SetDataProvider(function(rowData)
		return rowData
	end)
	ScrollUtil.RegisterTableBuilder(self.scrollBox, self.tableBuilder, function(elementData)
		return elementData
	end)

	ScrollUtil.RegisterAlternateRowBehavior(self.scrollBox, function(row, alternate)
		local character = row.data and row.data.character
		if character and character:IsCurrent() then
			row:UpdateBackgroundColor(Settings:Get("windowPlayerRowColor"))
			return
		end

		row:UpdateBackgroundColor(nil)
		if row.Background then
			row.Background:SetColorTexture(1, 1, 1, alternate and 0.08 or 0.04)
		end
	end)

	self:UpdateSize(300, 1)
	table.insert(UISpecialFrames, frameName)
end

function GUITable:Toggle()
	if not self.window then
		self:CreateWindow()
	end

	if self.window:IsShown() then
		self.window:Hide()
	else
		self.window:Show()
		self:Refresh()
	end
end
