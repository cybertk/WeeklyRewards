local addonName, namespace = ...

local L = namespace.L
local Constants = namespace.Constants
local Utils = namespace.Utils
local Settings = namespace.Settings

local TOOLTIP_MAX_WIDTH = 420

WeeklyRewardsVersionButtonMixin = {}

local function FormatChange(change)
	return "- " .. (change or ""):gsub("|n", "|n  ")
end

local function FormatEntry(entry)
	local header = format("|cffffd100%s|r", entry.v or "")
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
	GameTooltip:SetText(entry.v or "", 1, 1, 1, 1, true)

	if entry.date and entry.date > 0 then
		GameTooltip:AddLine(date("%Y-%m-%d", entry.date), GRAY_FONT_COLOR:GetRGB())
	end

	for _, change in ipairs(entry.changes or {}) do
		local r, g, b = HIGHLIGHT_FONT_COLOR:GetRGB()
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

	if not self.changelogWindow then
		self:CreateChangelogWindow()
	end

	self.changelogWindow:SetShown(not self.changelogWindow:IsShown())
end

function WeeklyRewardsVersionButtonMixin:LayoutChangelogText()
	local window = self.changelogWindow
	if not window then
		return
	end

	local scrollFrame = window.scrollFrame
	local child = scrollFrame.child
	local text = child.text
	local width = scrollFrame:GetWidth()
	if width <= 0 then
		return
	end

	text:SetWidth(width)
	child:SetWidth(width)

	local height = text:GetStringHeight()
	if height <= 0 and not window.layoutRetried then
		window.layoutRetried = true
		C_Timer.After(0, function()
			self:LayoutChangelogText()
		end)
		return
	end

	window.layoutRetried = nil
	child:SetHeight(math.max(height, 1) + 12)
	scrollFrame:UpdateScrollChildRect()
end

function WeeklyRewardsVersionButtonMixin:CreateChangelogWindow()
	local frameName = addonName .. "ChangelogFrame"
	local window = CreateFrame("Frame", frameName, UIParent)
	self.changelogWindow = window

	window:SetSize(460, 480)
	window:SetFrameStrata("DIALOG")
	window:SetToplevel(true)
	window:SetClampedToScreen(true)
	window:SetMovable(true)
	window:SetPoint("CENTER")
	window:SetUserPlaced(true)
	window:EnableMouse(true)
	window:RegisterForDrag("LeftButton")
	window:SetScript("OnDragStart", function()
		window:StartMoving()
	end)
	window:SetScript("OnDragStop", function()
		window:StopMovingOrSizing()
	end)
	window:Hide()

	local backgroundColor = Settings:Get("windowBackgroundColor")
	Utils:SetBackgroundColor(window, backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)

	window.border = CreateFrame("Frame", nil, window, "BackdropTemplate")
	window.border:SetPoint("TOPLEFT", window, "TOPLEFT", -3, 3)
	window.border:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 3, -3)
	window.border:SetBackdrop({
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	window.border:SetBackdropBorderColor(0, 0, 0, 0.5)
	window.border:SetShown(Settings:Get("windowBorder"))

	window.titlebar = CreateFrame("Frame", nil, window)
	window.titlebar:SetPoint("TOPLEFT", window, "TOPLEFT")
	window.titlebar:SetPoint("TOPRIGHT", window, "TOPRIGHT")
	window.titlebar:SetHeight(Constants.TITLEBAR_HEIGHT)
	window.titlebar:EnableMouse(true)
	window.titlebar:RegisterForDrag("LeftButton")
	window.titlebar:SetScript("OnDragStart", function()
		window:StartMoving()
	end)
	window.titlebar:SetScript("OnDragStop", function()
		window:StopMovingOrSizing()
	end)
	Utils:SetBackgroundColor(window.titlebar, 0, 0, 0, 0.5)

	window.titlebar.icon = window.titlebar:CreateTexture(nil, "ARTWORK")
	window.titlebar.icon:SetPoint("LEFT", window.titlebar, "LEFT", 6, 0)
	window.titlebar.icon:SetSize(20, 20)
	window.titlebar.icon:SetTexture("Interface/AddOns/WeeklyRewards/Media/Icon.blp")

	window.titlebar.title = window.titlebar:CreateFontString(nil, "OVERLAY", "SystemFont_Med2")
	window.titlebar.title:SetPoint("LEFT", window.titlebar.icon, "RIGHT", 4, 0)
	window.titlebar.title:SetJustifyH("LEFT")
	window.titlebar.title:SetText(L["changelog_title"])

	local closeButton = CreateFrame("Button", nil, window.titlebar)
	window.titlebar.closeButton = closeButton
	closeButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
	closeButton:SetPoint("RIGHT", window.titlebar, "RIGHT", 0, 0)
	closeButton:SetScript("OnClick", function()
		window:Hide()
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

	closeButton.Icon = closeButton:CreateTexture(nil, "ARTWORK")
	closeButton.Icon:SetPoint("CENTER", closeButton, "CENTER")
	closeButton.Icon:SetSize(16, 16)
	closeButton.Icon:SetAtlas("uitools-icon-close")
	closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)

	local scrollFrame = CreateFrame("ScrollFrame", nil, window, "ScrollFrameTemplate")
	window.scrollFrame = scrollFrame
	scrollFrame:SetPoint("TOPLEFT", window, "TOPLEFT", 12, -(Constants.TITLEBAR_HEIGHT + 8))
	scrollFrame:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -26, 12)
	scrollFrame:EnableMouse(true)
	scrollFrame:EnableMouseWheel(true)

	local child = CreateFrame("Frame", nil, scrollFrame)
	scrollFrame.child = child
	child:SetSize(1, 1)
	scrollFrame:SetScrollChild(child)

	child.text = child:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	child.text:SetPoint("TOPLEFT", child, "TOPLEFT", 0, 0)
	child.text:SetJustifyH("LEFT")
	child.text:SetJustifyV("TOP")
	child.text:SetWordWrap(true)
	child.text:SetSpacing(2)
	child.text:SetText(BuildChangelogText())

	scrollFrame:HookScript("OnSizeChanged", function()
		self:LayoutChangelogText()
	end)
	window:SetScript("OnShow", function()
		self:LayoutChangelogText()
		scrollFrame:SetVerticalScroll(0)
		local scrollBar = scrollFrame.ScrollBar
		if scrollBar then
			if scrollBar.SetScrollPercentage then
				scrollBar:SetScrollPercentage(0)
			elseif scrollBar.SetValue then
				scrollBar:SetValue(0)
			end
		end
	end)

	Settings:RegisterCallback("^window", function(_, value, key)
		if key == "windowBackgroundColor" then
			Utils:SetBackgroundColor(window, value.r, value.g, value.b, value.a)
		elseif key == "windowBorder" then
			window.border:SetShown(value)
		end
	end, self)

	table.insert(UISpecialFrames, frameName)
	self:LayoutChangelogText()
end
