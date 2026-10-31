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
	if self:IsShown() then
		self:OnShow()
	end
end

function TableCellMixin:OnShow()
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
	self:SetScript("OnClick", self.OnClick)
end

function TableCellMixin:OnEnter()
	local rowFrame = self:GetParent()
	if rowFrame.onEnterHandler then
		rowFrame:onEnterHandler(self)
	end

	self:UpdateTooltip()
	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", self.UpdateTooltip)
end

function TableCellMixin:OnLeave()
	local rowFrame = self:GetParent()
	if rowFrame.onLeaveHandler then
		rowFrame:onLeaveHandler(self)
	end

	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	self:SetScript("OnEvent", nil)
	GameTooltip:Hide()
end

function TableCellMixin:OnClick() end

function TableCellMixin:GetText() end

function TableCellMixin:UpdateTooltip()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if self:AddExtraStuffToTooltip(GameTooltip) then
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end
end

function TableCellMixin:AddExtraStuffToTooltip() end

local TableHeaderCellMixin = CreateFromMixins(TableCellMixin)

WeeklyRewardsTableHeaderCellMixin = TableHeaderCellMixin

function TableHeaderCellMixin:OnLoad()
	if not self.Arrow then
		self.Arrow = self:CreateTexture(nil, "ARTWORK")
		self.Arrow:SetAtlas("auctionhouse-ui-sortarrow", true)

		self.Icon = self:CreateTexture(nil, "ARTWORK")
		self.Icon:SetPoint("RIGHT", self.text, "LEFT", 0, 0)
		self.Icon:Hide()

		self:SetHighlightTexture("auctionhouse-ui-row-highlight", "ADD")
	end

	TableCellMixin.OnLoad(self)
end

function TableHeaderCellMixin:Layout()
	local data = self.data or {}
	self.reward = data.reward
	self.key = data.key
	self:UpdateSortArrow()
end

function TableHeaderCellMixin:UpdateSortArrow()
	local sortOrder, ascending = CharacterStore.Get():GetSortOrder()
	local reward = self.data and self.data.reward or {}
	local characterField = self.data and (self.data.key or reward.id)
	local text = self.Text or self.text

	if text then
		local offset = text:GetStringWidth() - text:GetWidth()
		if text:GetJustifyH() == "CENTER" then
			offset = offset / 2
		end
		self.Arrow:ClearAllPoints()
		self.Arrow:SetPoint("LEFT", text, "RIGHT", offset, 1)
	end

	self.Arrow:SetShown(characterField ~= nil and sortOrder == characterField)

	if characterField and sortOrder == characterField then
		if ascending then
			self.Arrow:SetTexCoord(0, 1, 0, 1)
		else
			self.Arrow:SetTexCoord(0, 1, 1, 0)
		end
	end
end

function TableHeaderCellMixin:AddExtraStuffToTooltip(tooltip)
	if self.reward then
		self:AddRewardToGameTooltip(self.reward)
		return true
	end

	if self.data and self.data.tooltip == "" then
		return false
	end

	tooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
	return true
end

function TableHeaderCellMixin:OnClick()
	if not self.key and not self.reward then
		return
	end

	if IsControlKeyDown() then
		if self.reward then
			ActiveRewards.Get():ToggleExclusion(self.reward:GetCandidateID())
		else
			Settings:Get("hiddenColumns")[self.data.text] = true
		end
	else
		local characterField = self.key or self.reward.id
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

CharacterIndexDataMixin = CreateFromMixins(TableCellMixin)

function CharacterIndexDataMixin:GetText(cellData)
	return GRAY_FONT_COLOR:WrapTextInColorCode(cellData.index)
end

CharacterNameDataMixin = CreateFromMixins(TableCellMixin)

function CharacterNameDataMixin:GetText(cellData)
	local character = cellData.character
	local _, tag = character:GetNote()

	tag = #tag > 0 and format(" |cnGOLD_FONT_COLOR:(%s)|r", #tag > 4 and "*" or tag) or tag

	local text = Util.WrapTextInClassColor(character.class, character.name)
	return character:IsCurrent() and format("|T%s.tga:13:13|t%s%s", FRIENDS_TEXTURE_ONLINE, text, tag) or text .. tag
end

function CharacterNameDataMixin:AddExtraStuffToTooltip()
	local character = self.data.character
	local note = character:GetNote()

	GameTooltip:SetText(Util.WrapTextInClassColor(character.class, format("%s-%s", character.name, character.realmName)))
	GameTooltip:AddLine(" ")
	if #note > 0 then
		GameTooltip:AddLine("|T131129:12|t" .. note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:AddLine(" ")
	end
	GameTooltip:AddLine(CLICK_TO_ENTER_COMMENT, GREEN_FONT_COLOR:GetRGB())
	return true
end

function CharacterNameDataMixin:OnClick()
	Dialogs.ShowCharacterNote(self.data.character)
end

CharacterRealmDataMixin = CreateFromMixins(TableCellMixin)

function CharacterRealmDataMixin:GetText(cellData)
	return cellData.character.realmName
end

CharacterLevelDataMixin = CreateFromMixins(TableCellMixin)

function CharacterLevelDataMixin:GetText(cellData)
	local character = cellData.character
	local _, timeToCharge = character:GetRestedXP()
	return timeToCharge == 0 and GREEN_FONT_COLOR:WrapTextInColorCode(character.level) or character.level
end

function CharacterLevelDataMixin:AddExtraStuffToTooltip()
	self.data.character:AddXPToTooltip(GameTooltip)
	return true
end

CharacterItemLevelDataMixin = CreateFromMixins(TableCellMixin)

function CharacterItemLevelDataMixin:GetText(cellData)
	local avgItemLevel = cellData.character:GetAverageItemLevel()
	return avgItemLevel and floor(avgItemLevel) or "-"
end

function CharacterItemLevelDataMixin:AddExtraStuffToTooltip()
	local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = self.data.character:GetAverageItemLevel()

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
	return true
end

CharacterFactionDataMixin = CreateFromMixins(TableCellMixin)

function CharacterFactionDataMixin:GetText(cellData)
	return CreateAtlasMarkup(format("questlog-questtypeicon-%s", cellData.character:GetFaction():lower()), 20, 20)
end

CharacterCovenantDataMixin = CreateFromMixins(TableCellMixin)

function CharacterCovenantDataMixin:GetText(cellData)
	return cellData.character:GetCovenantName()
end

function CharacterCovenantDataMixin:AddExtraStuffToTooltip()
	local character = self.data.character

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

	return true
end

CharacterLocationDataMixin = CreateFromMixins(TableCellMixin)

function CharacterLocationDataMixin:GetText(cellData)
	local character = cellData.character
	return character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(character.location) or character.location
end

function CharacterLocationDataMixin:AddExtraStuffToTooltip()
	local character = self.data.character

	GameTooltip:SetText(character.location, HIGHLIGHT_FONT_COLOR:GetRGB())

	local instruction = "|A:NPE_LeftClick:16:16|a|cnGREEN_FONT_COLOR:(" .. INVITE .. ")|r"
	character:AddPartyToTooltip(GameTooltip, CharacterStore.IsCurrentPlayer(character) and instruction or "")
	return true
end

function CharacterLocationDataMixin:OnClick()
	local character = self.data.character
	if CharacterStore.IsCurrentPlayer(character) then
		character:InviteLastParty()
	end
end

CharacterLastUpdateDataMixin = CreateFromMixins(TableCellMixin)

function CharacterLastUpdateDataMixin:GetText(cellData)
	local character = cellData.character
	local text = Util.FormatLastUpdateTime(character.lastUpdate)
	return character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(FRIENDS_LIST_ONLINE) or text
end

RewardDataMixin = CreateFromMixins(TableCellMixin)

function RewardDataMixin:GetText(cellData)
	local character = cellData.character
	local reward = cellData.reward
	local progress, isScanned = character:GetRewardProgress(reward.id)

	if not isScanned and reward:PlayerMeetsRequiredLevel(character.level) then
		return " "
	elseif progress == nil then
		return reward:PlayerMeetsRequiredLevel(character.level) and CreateAtlasMarkup("PlayerRaidBlip", 13, 13) or "-"
	end

	return progress:GetStatusLabel()
end

function RewardDataMixin:AddExtraStuffToTooltip(tooltip)
	local character = self.data.character
	local reward = self.data.reward
	local progress, isScanned = character:GetRewardProgress(reward.id)

	if progress == nil or progress:ObjectivesCount() == 0 or #(progress.records or {}) == 0 then
		if not reward:PlayerMeetsRequiredLevel(character.level) then
			tooltip:AddLine(ITEM_MIN_LEVEL:format(reward.maximumLevel or reward.minimumLevel))
		elseif isScanned then
			GameTooltip_AddNormalLine(tooltip, character:GetNameInClassColor(true))
			tooltip:AddLine(" ")
			namespace.GUIMain:AddRewardObjectivesToGameTooltip(tooltip, reward)

			tooltip:AddLine(" ")
			GameTooltip_AddNormalLine(tooltip, L["progress_not_started"])
		else
			GameTooltip_AddNormalLine(tooltip, L["table_alts_collect_hint"])
		end
	elseif progress.total == 0 then
		GameTooltip_AddNormalLine(tooltip, ERR_QUEST_NEED_PREREQS)
	else
		namespace.GUIMain:AddProgressToGameTooltip(progress)
		self.hasInstructions = nil
	end

	return true
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
