local addonName, namespace = ...

local L = namespace.L
local Constants = namespace.Constants
local Utils = namespace.Utils
local Settings = namespace.Settings

local TOOLTIP_MAX_WIDTH = 420
local CHANGE_BULLET = CreateAtlasMarkup("PlayerPartyBlip", 12, 12)

WeeklyRewardsVersionWindowMixin = {}
WeeklyRewardsVersionButtonMixin = {}

local function FormatChange(change)
	local text = "- " .. (change or ""):gsub("|n", "|n  ")
	text = text:gsub("^%- ", CHANGE_BULLET .. " ")
	return text:gsub("|n(%s*)%- ", "|n%1" .. CHANGE_BULLET .. " ")
end

local function FormatEntry(entry)
	local header = NORMAL_FONT_COLOR:WrapTextInColorCode(entry.v or "")
	if entry.date and entry.date > 0 then
		header = format("%s  |cff808080%s|r", header, date("%Y-%m-%d", entry.date))
	end

	local lines = { header }
	for _, change in ipairs(entry.changes or {}) do
		lines[#lines + 1] = FormatChange(change)
	end

	return table.concat(lines, "|n")
end

local function BuildChangelogText()
	local entries = _G.changelog
	if not entries then
		return ""
	end

	local parts = {}
	for _, entry in ipairs(entries) do
		parts[#parts + 1] = FormatEntry(entry)
	end

	return table.concat(parts, "|n|n")
end

local function ConstrainTooltipWidth(tooltip, maxWidth)
	for i = 1, tooltip:NumLines() do
		local line = _G[tooltip:GetName() .. "TextLeft" .. i]
		if line and line:GetStringWidth() > maxWidth then
			line:SetWidth(maxWidth)
		end
	end
end

function WeeklyRewardsVersionButtonMixin:OnLoad()
	local version = C_AddOns.GetAddOnMetadata(addonName, "Version")

	if version == "@project-version@" then
		version = "dev"
	end

	self:SetText(version)

	self:SetScale(0.8)
	self:SetWidth(self:GetTextWidth())
end

function WeeklyRewardsVersionButtonMixin:OnEnter()
	local entry = _G.changelog and _G.changelog[1]
	if not entry then
		return
	end

	namespace.GUIMain:SetTooltipOwner(GameTooltip, self)
	local r, g, b = NORMAL_FONT_COLOR:GetRGB()
	GameTooltip:SetText(entry.v or "", r, g, b, 1, true)

	if entry.date and entry.date > 0 then
		GameTooltip:AddLine(date("%Y-%m-%d", entry.date), GRAY_FONT_COLOR:GetRGB())
	end

	for _, change in ipairs(entry.changes or {}) do
		GameTooltip:AddLine(FormatChange(change), r, g, b, true)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["changelog_click_hint"], 1, 1, 1, true)
	GameTooltip:Show()
	ConstrainTooltipWidth(GameTooltip, TOOLTIP_MAX_WIDTH)
	GameTooltip:Show()
end

function WeeklyRewardsVersionButtonMixin:OnLeave()
	GameTooltip:Hide()
end

function WeeklyRewardsVersionButtonMixin:OnClick()
	GameTooltip:Hide()

	local entries = _G.changelog
	if not entries or not entries[1] then
		return
	end

	WeeklyRewardsVersionWindow:SetShown(not WeeklyRewardsVersionWindow:IsShown())
end

function WeeklyRewardsVersionWindowMixin:OnLoad()
	self:SetUserPlaced(true)
	self:RegisterForDrag("LeftButton")

	local backgroundColor = Settings:Get("windowBackgroundColor")
	Utils:SetBackgroundColor(self, backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)

	self.border:SetBackdrop({
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	self.border:SetBackdropBorderColor(0, 0, 0, 0.5)
	self.border:SetShown(Settings:Get("windowBorder"))

	local titlebarHeight = Constants.TITLEBAR_HEIGHT
	local titlebar = self.titlebar
	titlebar:SetHeight(titlebarHeight)
	titlebar:RegisterForDrag("LeftButton")
	titlebar:SetScript("OnDragStart", function()
		self:StartMoving()
	end)
	titlebar:SetScript("OnDragStop", function()
		self:StopMovingOrSizing()
	end)
	Utils:SetBackgroundColor(titlebar, 0, 0, 0, 0.5)
	titlebar.title:SetPoint("LEFT", titlebar.icon, "RIGHT", 4, 0)
	titlebar.title:SetText(L["changelog_title"])

	local closeButton = titlebar.closeButton
	closeButton:SetSize(titlebarHeight, titlebarHeight)
	closeButton:SetScript("OnClick", function()
		self:Hide()
	end)
	closeButton:SetScript("OnEnter", function()
		closeButton.Icon:SetVertexColor(1, 1, 1, 1)
		Utils:SetBackgroundColor(closeButton, 1, 0, 0, 0.2)
		GameTooltip:SetOwner(closeButton, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["close_button_tooltip"], 1, 1, 1, 1, true)
		GameTooltip:Show()
	end)
	closeButton:SetScript("OnLeave", function()
		closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
		Utils:SetBackgroundColor(closeButton, 1, 1, 1, 0)
		GameTooltip:Hide()
	end)

	local scrollFrame = self.scrollFrame
	scrollFrame:SetPoint("TOPLEFT", self, "TOPLEFT", 12, -(titlebarHeight + 8))
	scrollFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -26, 12)
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScrollChild(scrollFrame.child)
	scrollFrame:HookScript("OnSizeChanged", function()
		self:LayoutText()
	end)

	local text = scrollFrame.child.text
	text:SetWordWrap(true)
	text:SetSpacing(2)
	text:SetText(BuildChangelogText())

	Settings:RegisterCallback("^window", function(_, value, key)
		if key == "windowBackgroundColor" then
			Utils:SetBackgroundColor(self, value.r, value.g, value.b, value.a)
		elseif key == "windowBorder" then
			self.border:SetShown(value)
		end
	end, self)

	table.insert(UISpecialFrames, self:GetName())
	self:LayoutText()
end

function WeeklyRewardsVersionWindowMixin:OnDragStart()
	self:StartMoving()
end

function WeeklyRewardsVersionWindowMixin:OnDragStop()
	self:StopMovingOrSizing()
end

function WeeklyRewardsVersionWindowMixin:OnShow()
	self:LayoutText()
	local scrollFrame = self.scrollFrame
	scrollFrame:SetVerticalScroll(0)
	local scrollBar = scrollFrame.ScrollBar
	if scrollBar then
		if scrollBar.SetScrollPercentage then
			scrollBar:SetScrollPercentage(0)
		elseif scrollBar.SetValue then
			scrollBar:SetValue(0)
		end
	end
end

function WeeklyRewardsVersionWindowMixin:LayoutText()
	local scrollFrame = self.scrollFrame
	local child = scrollFrame.child
	local text = child.text
	local width = scrollFrame:GetWidth()
	if width <= 0 then
		return
	end

	text:SetWidth(width)
	child:SetWidth(width)

	local height = text:GetStringHeight()
	if height <= 0 and not self.layoutRetried then
		self.layoutRetried = true
		C_Timer.After(0, function()
			self:LayoutText()
		end)
		return
	end

	self.layoutRetried = nil
	child:SetHeight(math.max(height, 1) + 12)
	scrollFrame:UpdateScrollChildRect()
end
