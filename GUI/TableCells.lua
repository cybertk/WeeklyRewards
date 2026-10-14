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
	self.Text = self.text
	self:SetScript("OnShow", self.OnShow)
end

function TableCellMixin:OnShow()
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
	self:SetScript("OnClick", self.OnClick)
end

function TableCellMixin:OnEnter()
	print("OnEnter")

	self:UpdateTooltip()

	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", self.UpdateTooltip)
end

function TableCellMixin:OnLeave()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", nil)

	GameTooltip:Hide()
end

function TableCellMixin:UpdateTooltip()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	self:AddExtraStuffToTooltip(GameTooltip)
	GameTooltip:Show()
end

function TableCellMixin:AddExtraStuffToTooltip(tooltip) end

local TableHeaderCellMixin = CreateFromMixins(TableCellMixin)

WeeklyRewardsTableHeaderCellMixin = TableHeaderCellMixin

function TableHeaderCellMixin:OnLoad()
	TableCellMixin.OnLoad(self)

	self.Arrow = self:CreateTexture(nil, "ARTWORK")
	self.Arrow:SetAtlas("auctionhouse-ui-sortarrow", true)
	self.Arrow:SetPoint("LEFT", self.Text, "RIGHT", 1, 1)

	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:SetPoint("RIGHT", self.Text, "LEFT", 0, 0)

	self:SetHighlightTexture("auctionhouse-ui-row-highlight", "ADD")
end

function TableHeaderCellMixin:AddExtraStuffToTooltip(tooltip)
	print("OnEnter")

	if self.reward then
		self:AddRewardToGameTooltip(self.reward)
		-- local function updateTooltip()
		-- 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		-- 	self:AddRewardToGameTooltip(self.reward)
		-- 	GameTooltip:Show()
		-- end
		-- self:RegisterEvent("MODIFIER_STATE_CHANGED")
		-- self:SetScript("OnEvent", updateTooltip)
		-- updateTooltip()
	else
		tooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
		-- GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		-- GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
		-- GameTooltip:Show()
	end
end

-- function TableHeaderCellMixin:OnLeave()
-- 	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
-- 	self:SetScript("OnEvent", nil)
-- 	GameTooltip:Hide()
-- end

function TableHeaderCellMixin:OnClick()
	print("OnClick")
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()
	local hiddenColumns = Settings:Get("hiddenColumns")
	local characterField = self.key or self.reward.id

	if IsControlKeyDown() then
		if self.reward then
			ActiveRewards.Get():ToggleExclusion(self.reward:GetCandidateID())
		else
			hiddenColumns[self.name] = true
		end
	else
		CharacterStore.Get():SetSortOrder(characterField)
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

-- function TableCellMixin:OnClick()
-- 	print("OnClick")
-- end

function TableHeaderCellMixin:Layout()
	self.reward = self.data and self.data.reward or nil
	self.key = self.data and self.data.key or nil

	self.Icon:SetShown(true)
	-- self.Arrow:SetShown(true)
	self:UpdateSortArrow()

	self.Text:ClearAllPoints()
	self.Text:SetPoint("CENTER")
	-- self.Text:SetText()

	-- print("layu")
end

function TableHeaderCellMixin:UpdateSortArrow()
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()
	local characterField

	-- print("data", type(self.data), self.data and self.data.key, self.data and self.data.reward)
	if self.data then
		local reward = self.data.reward or {}
		characterField = self.data.key or reward.id
	end

	self.Arrow:SetShown(sortOrder == characterField)

	if sortOrder == characterField then
		if ascending then
			self.Arrow:SetTexCoord(0, 1, 0, 1)
		else
			self.Arrow:SetTexCoord(0, 1, 1, 0)
		end
	end
end

local TableHeaderDataMixin = CreateFromMixins(TableCellMixin)

function TableHeaderDataMixin:OnEnter()
	print("OnEnter")

	if self.reward then
		local function updateTooltip()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			self:AddRewardToGameTooltip(self.reward)
			GameTooltip:Show()
		end
		self:RegisterEvent("MODIFIER_STATE_CHANGED")
		self:SetScript("OnEvent", updateTooltip)
		updateTooltip()
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
		GameTooltip:Show()
	end
end

function TableHeaderDataMixin:OnLeave()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", nil)
	GameTooltip:Hide()
end

function TableHeaderDataMixin:OnClick()
	print("OnClick")
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()
	local hiddenColumns = Settings:Get("hiddenColumns")
	local characterField = self.key or self.reward.id

	if IsControlKeyDown() then
		if self.reward then
			ActiveRewards.Get():ToggleExclusion(self.reward:GetCandidateID())
		else
			hiddenColumns[self.name] = true
		end
	else
		CharacterStore.Get():SetSortOrder(characterField)
		local field, ascending = CharacterStore.Get():GetSortOrder()
		Settings:Set("sortColumn", field)
		Settings:Set("sortAscending", ascending)
	end

	namespace.GUIMain:Redraw()
end

WeeklyRewardsTableCellMixin = {}

function WeeklyRewardsTableCellMixin:OnEnter()
	local rowFrame = self:GetParent()
	if rowFrame.onEnterHandler then
		rowFrame:onEnterHandler(self)
	end
	if rowFrame.Highlight then
		rowFrame.Highlight:SetVertexColor(0.3, 0.3, 0.7, 0.2)
	end
end

function WeeklyRewardsTableCellMixin:OnLeave()
	local rowFrame = self:GetParent()
	if rowFrame.onLeaveHandler then
		rowFrame:onLeaveHandler(self)
	end
	GameTooltip:Hide()
end

function WeeklyRewardsTableCellMixin:OnClick() end

function WeeklyRewardsTableCellMixin:GetText() end

local CharacterColumnHeaderMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterColumnHeaderMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(self.tooltip or GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
	GameTooltip:Show()
end

function CharacterColumnHeaderMixin:OnClick()
	local data = self.data
	if not data.key and not data.reward then
		return
	end

	if IsControlKeyDown() then
		if data.reward then
			ActiveRewards.Get():ToggleExclusion(data.reward:GetCandidateID())
		else
			Settings:Get("hiddenColumns")[data.name] = true
		end
	else
		local characterField = data.key or data.reward.id
		CharacterStore.Get():SetSortOrder(characterField)
		local field, ascending = CharacterStore.Get():GetSortOrder()
		Settings:Set("sortColumn", field)
		Settings:Set("sortAscending", ascending)
	end

	namespace.GUIMain:Redraw()
end

local function CreateCharacterHeaderMixin(tooltip)
	local mixin = CreateFromMixins(CharacterColumnHeaderMixin)
	mixin.tooltip = tooltip
	return mixin
end

CharacterIndexHeaderMixin = CreateCharacterHeaderMixin("")
CharacterNameHeaderMixin = CreateCharacterHeaderMixin()
CharacterRealmHeaderMixin = CreateCharacterHeaderMixin()
CharacterLevelHeaderMixin = CreateCharacterHeaderMixin()
CharacterItemLevelHeaderMixin = CreateCharacterHeaderMixin()
CharacterFactionHeaderMixin = CreateCharacterHeaderMixin()
CharacterCovenantHeaderMixin = CreateCharacterHeaderMixin()
CharacterLocationHeaderMixin = CreateCharacterHeaderMixin()
CharacterLastUpdateHeaderMixin = CreateCharacterHeaderMixin()

CharacterIndexDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterIndexDataMixin:GetText(cellData)
	return GRAY_FONT_COLOR:WrapTextInColorCode(cellData.index)
end

CharacterNameDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterNameDataMixin:GetText(cellData)
	local character = cellData.character
	local _, tag = character:GetNote()

	tag = #tag > 0 and format(" |cnGOLD_FONT_COLOR:(%s)|r", #tag > 4 and "*" or tag) or tag

	local text = Util.WrapTextInClassColor(character.class, character.name)
	return character:IsCurrent() and format("|T%s.tga:13:13|t%s%s", FRIENDS_TEXTURE_ONLINE, text, tag) or text .. tag
end

function CharacterNameDataMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)

	local character = self.data.character
	local note = character:GetNote()

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(Util.WrapTextInClassColor(character.class, format("%s-%s", character.name, character.realmName)))
	GameTooltip:AddLine(" ")
	if #note > 0 then
		GameTooltip:AddLine("|T131129:12|t" .. note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:AddLine(" ")
	end
	GameTooltip:AddLine(CLICK_TO_ENTER_COMMENT, GREEN_FONT_COLOR:GetRGB())
	GameTooltip:Show()
end

function CharacterNameDataMixin:OnClick()
	Dialogs.ShowCharacterNote(self.data.character)
end

CharacterRealmDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterRealmDataMixin:GetText(cellData)
	return cellData.character.realmName
end

CharacterLevelDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterLevelDataMixin:GetText(cellData)
	local character = cellData.character
	local _, timeToCharge = character:GetRestedXP()
	return timeToCharge == 0 and GREEN_FONT_COLOR:WrapTextInColorCode(character.level) or character.level
end

function CharacterLevelDataMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	self.data.character:AddXPToTooltip(GameTooltip)
	GameTooltip:Show()
end

CharacterItemLevelDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterItemLevelDataMixin:GetText(cellData)
	local avgItemLevel = cellData.character:GetAverageItemLevel()
	return avgItemLevel and floor(avgItemLevel) or "-"
end

function CharacterItemLevelDataMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)

	local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = self.data.character:GetAverageItemLevel()

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
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
end

CharacterFactionDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterFactionDataMixin:GetText(cellData)
	return CreateAtlasMarkup(format("questlog-questtypeicon-%s", cellData.character:GetFaction():lower()), 20, 20)
end

CharacterCovenantDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterCovenantDataMixin:GetText(cellData)
	return cellData.character:GetCovenantName()
end

function CharacterCovenantDataMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)

	local character = self.data.character

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
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
end

CharacterLocationDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterLocationDataMixin:GetText(cellData)
	local character = cellData.character
	return character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(character.location) or character.location
end

function CharacterLocationDataMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)

	local character = self.data.character

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(character.location, HIGHLIGHT_FONT_COLOR:GetRGB())

	local instruction = "|A:NPE_LeftClick:16:16|a|cnGREEN_FONT_COLOR:(" .. INVITE .. ")|r"
	character:AddPartyToTooltip(GameTooltip, CharacterStore.IsCurrentPlayer(character) and instruction or "")

	GameTooltip:Show()
end

function CharacterLocationDataMixin:OnClick()
	local character = self.data.character
	if CharacterStore.IsCurrentPlayer(character) then
		character:InviteLastParty()
	end
end

CharacterLastUpdateDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function CharacterLastUpdateDataMixin:GetText(cellData)
	local character = cellData.character
	local text = Util.FormatLastUpdateTime(character.lastUpdate)
	return character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(text) or text
end

RewardHeaderMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function RewardHeaderMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)

	local cell = self
	local function updateTooltip()
		GameTooltip:SetOwner(cell, "ANCHOR_RIGHT")
		namespace.GUIMain:AddRewardToGameTooltip(cell.data.reward)
		GameTooltip:Show()
	end
	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", updateTooltip)
	updateTooltip()
end

function RewardHeaderMixin:OnLeave()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", nil)
	WeeklyRewardsTableCellMixin.OnLeave(self)
end

function RewardHeaderMixin:OnClick()
	CharacterColumnHeaderMixin.OnClick(self)
end

RewardDataMixin = CreateFromMixins(WeeklyRewardsTableCellMixin)

function RewardDataMixin:GetText(cellData)
	local character = cellData.character
	local reward = cellData.reward
	local progress, isScanned = character:GetRewardProgress(reward.id)
	local text

	if not isScanned and reward:PlayerMeetsRequiredLevel(character.level) then
		text = " "
	elseif progress == nil then
		text = reward:PlayerMeetsRequiredLevel(character.level) and CreateAtlasMarkup("PlayerRaidBlip", 13, 13) or "-"
	else
		text = progress:GetStatusLabel()
	end

	return text
end

function RewardDataMixin:OnEnter()
	WeeklyRewardsTableCellMixin.OnEnter(self)

	local character = self.data.character
	local reward = self.data.reward
	local progress, isScanned = character:GetRewardProgress(reward.id)

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if progress == nil or progress:ObjectivesCount() == 0 then
		if not reward:PlayerMeetsRequiredLevel(character.level) then
			GameTooltip:AddLine(ITEM_MIN_LEVEL:format(reward.maximumLevel or reward.minimumLevel))
		elseif isScanned then
			GameTooltip_AddNormalLine(GameTooltip, character:GetNameInClassColor(true))
			GameTooltip:AddLine(" ")
			namespace.GUIMain:AddRewardObjectivesToGameTooltip(GameTooltip, reward)

			GameTooltip:AddLine(" ")
			GameTooltip_AddNormalLine(GameTooltip, L["progress_not_started"])
		else
			GameTooltip_AddNormalLine(GameTooltip, L["table_alts_collect_hint"])
		end
	elseif progress.total == 0 then
		GameTooltip_AddNormalLine(GameTooltip, ERR_QUEST_NEED_PREREQS)
	else
		namespace.GUIMain:AddProgressToGameTooltip(progress)
		self.hasInstructions = nil
	end

	GameTooltip:Show()
end

function RewardDataMixin:OnClick()
	local character = self.data.character
	if not CharacterStore.IsCurrentPlayer(character) then
		return
	end

	if not self.hasInstructions then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_reset_progress_hint"]))
		GameTooltip:Show()
		self.hasInstructions = true
	end

	if IsControlKeyDown() then
		namespace.GUIMain:ResetCell(character, self.data.reward)
	end
end
