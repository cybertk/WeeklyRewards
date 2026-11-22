local _, namespace = ...

local L = namespace.L
local Settings = namespace.Settings
local Util = namespace.Util
local Dialogs = namespace.Dialogs
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards
local RewardSummary = namespace.RewardSummary

local TableCellMixin = {}

function TableCellMixin:OnLoad()
	self.text = self.Text
	self:SetScript("OnShow", self.OnShow)
end

function TableCellMixin:OnShow()
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
	self:SetScript("OnClick", self.OnClick)
end

function TableCellMixin:OnEnter()
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
		Settings:Set("windowSortColumn", field)
		Settings:Set("windowSortAscending", ascending)
	end
end

function TableHeaderCellMixin:Init(data)
	self.data = data

	if not self.disableIcon then
		local mode = Settings:Get("windowColumnLayout")
		self.Text:SetShown(mode ~= "MINIMAL")
		self.Icon:SetShown(mode ~= "COMPACT")
	end

	self:UpdateDesiredWidth()
end

function TableHeaderCellMixin:GetSortKey() end

function TableHeaderCellMixin:GetIconTexture() end

function TableHeaderCellMixin:GetIconAtlas() end

function TableHeaderCellMixin:HideColumn()
	self:OnHideColumn()
	namespace.GUIMain:Redraw()
end

function TableHeaderCellMixin:Layout()
	self:UpdateArrow()
	self:UpdateIcon()

	self.Icon:ClearAllPoints()
	self.Text:ClearAllPoints()

	if self.Icon:IsShown() and self.Text:IsShown() then
		self.Icon:SetPoint("RIGHT", self.Text, "LEFT")
		self.Text:SetPoint("CENTER", self.Icon:GetWidth() / 2, 0)
	elseif self.Icon:IsShown() then
		self.Icon:SetPoint("CENTER")
	elseif not self.data.align or self.data.align == "LEFT" then
		local mode = Settings:Get("windowColumnLayout")
		self.Text:SetPoint("LEFT", mode == "MINIMAL" and 2 or mode == "COMPACT" and 3 or 6, 0)
	else
		self.Text:SetPoint(self.data.align, 0, 0)
	end
end

function TableHeaderCellMixin:UpdateArrow()
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()
	local sortKey = self:GetSortKey()

	if sortOrder ~= sortKey then
		self.Arrow:Hide()
		return
	end

	self.Arrow:ClearAllPoints()
	if self.Text:IsShown() then
		self.Arrow:SetPoint("LEFT", self.Text, "RIGHT", 0, 0)
	else
		self.Arrow:SetPoint("TOP", self.Icon, "BOTTOM", -0, 2)
	end

	self.Arrow:Show()

	if ascending then
		self.Arrow:SetTexCoord(0, 1, 0, 1)
	else
		self.Arrow:SetTexCoord(0, 1, 1, 0)
	end
end

function TableHeaderCellMixin:UpdateIcon()
	if not self.Icon:IsShown() then
		return
	end

	self.Icon:SetScale(self.Text:IsShown() and 1 or 1.3)

	local texture, atlas = self:GetIconTexture(), self:GetIconAtlas()
	if texture then
		self.Icon:SetTexture(texture)
		if self.Icon:GetNumMaskTextures() == 0 then
			self.Icon:AddMaskTexture(self.CircleMask)
		end
	elseif atlas then
		self.Icon:SetAtlas(atlas)
		if self.Icon:GetNumMaskTextures() > 0 then
			self.Icon:RemoveMaskTexture(self.CircleMask)
		end
	end
end

function TableHeaderCellMixin:UpdateDesiredWidth(cellText)
	if not cellText then
		local width = 0
		if self.Icon:IsShown() then
			width = self.Icon:GetWidth()
		end

		if self.Text:IsShown() then
			self.Text:SetText(self.data.text or "")
			width = width + self.Text:GetUnboundedStringWidth() + 4
		end

		self.width = math.max(width, 18)
	else
		self.Text:SetText(cellText)
		self.width = math.max(self.width, self.Text:GetUnboundedStringWidth())
	end

	self.data.width = self.width
end

function TableHeaderCellMixin:AddRewardToGameTooltip(tooltip, reward)
	local hint = ("|A:NPE_LeftClick:16:16|a(%s)"):format(IsControlKeyDown() and HIDE or STABLE_FILTER_BUTTON_LABEL)

	GameTooltip_AddColoredDoubleLine(tooltip, reward.name, hint, WHITE_FONT_COLOR, GREEN_FONT_COLOR)
	GameTooltip_AddColoredLine(tooltip, reward:GetGroupName(), GREEN_FONT_COLOR)
	GameTooltip_AddNormalLine(tooltip, reward:GetDescription())

	tooltip:AddLine(" ")

	if reward.resetTime then
		local timeLeft = WHITE_FONT_COLOR:WrapTextInColorCode(Util.FormatTimeDuration(reward.resetTime - GetServerTime()))
		GameTooltip_AddNormalLine(tooltip, MAP_TOOLTIP_TIME_LEFT:format(timeLeft))
	end

	tooltip:AddLine(" ")
	RewardSummary:Create(reward.id):AddToTooltip(tooltip)
end

local TableHeaderCellCharacterMixin = CreateFromMixins(TableHeaderCellMixin)

function TableHeaderCellCharacterMixin:GetSortKey()
	return self.data.key
end

function TableHeaderCellCharacterMixin:GetText()
	return self.data.text
end

function TableHeaderCellCharacterMixin:OnHideColumn()
	Settings:Get("hiddenColumns")[self.data.text] = true
end

function TableHeaderCellCharacterMixin:AddExtraStuffToTooltip(tooltip)
	tooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
end

local TableHeaderCellRewardMixin = CreateFromMixins(TableHeaderCellMixin)

function TableHeaderCellRewardMixin:GetSortKey()
	return self.data.reward.id
end

function TableHeaderCellRewardMixin:GetText()
	return self.data.reward.name
end

function TableHeaderCellRewardMixin:GetIconTexture()
	return self.data.reward.texture
end

function TableHeaderCellRewardMixin:GetIconAtlas()
	return self.data.reward.atlas or "quest-recurring-available"
end

function TableHeaderCellRewardMixin:OnHideColumn()
	ActiveRewards.Get():ToggleExclusion(self.data.reward:GetCandidateID())
end

function TableHeaderCellRewardMixin:AddExtraStuffToTooltip(tooltip)
	self:AddRewardToGameTooltip(tooltip, self.data.reward)
end

WeeklyRewardsTableHeaderCellCharacterMixin = TableHeaderCellCharacterMixin
WeeklyRewardsTableHeaderCellRewardMixin = TableHeaderCellRewardMixin
WeeklyRewardsTableDataCellMixin = TableDataCellMixin
