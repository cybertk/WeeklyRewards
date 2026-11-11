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
	self.text:Hide()
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
	self.Icon:SetAtlas(self:GetIconAtlas() or "")

	self.Text = self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFontObject("GameFontHighlightSmall")
	self.Text:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
	self.Text:SetPoint("LEFT", self.Icon, "RIGHT", 5, 0)
	self.Text:SetText(self.data.text)

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

function TableHeaderCellMixin:GetIconAtlas() end

function TableHeaderCellMixin:Layout()
	-- self.reward = self.data and self.data.reward or nil
	-- self.key = self.data and self.data.key or nil

	-- self.Icon:SetShown(true)

	-- self.Arrow:SetShown(true)
	self:UpdateArrow()

	self.Text:Hide()
	self.Icon:SetWidth(self:GetIconAtlas() and 20 or 0)
	-- self.Text:SetWidth(self.showIconOnly and 0 or self.data.width)
	self.Text:SetWidth(self.showIconOnly and 0 or 1)

	print("width", self.Text:GetWidth(), "icon width", self.Icon:GetWidth())

	if self.data.align == "LEFT" then
		self.Icon:SetPoint("LEFT", self.padding)
	else
		self.Icon:SetPoint("CENTER", 0, 0)
		-- self.Icon:SetPoint("CENTER", -self.Text:GetWidth() / 2, 0)
	end

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

function TableHeaderCellRewardMixin:GetIconAtlas()
	return GetRandomArrayEntry({
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
	})
end

function TableHeaderCellRewardMixin:HideColumn()
	ActiveRewards.Get():ToggleExclusion(self.data.reward:GetCandidateID())
end

function TableHeaderCellRewardMixin:AddExtraStuffToTooltip(tooltip)
	print("AddExtraStuffToTooltip")
	self:AddRewardToGameTooltip(self.data.reward)
end

WeeklyRewardsTableHeaderCellCharacterMixin = TableHeaderCellCharacterMixin
WeeklyRewardsTableHeaderCellRewardMixin = TableHeaderCellRewardMixin
