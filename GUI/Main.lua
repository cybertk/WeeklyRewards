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

local Dialogs = namespace.Dialogs
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
	if Settings:GetOption("windowPosition") then
		local pos = Settings:Get("windowPosition")
		self.window:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
	else
		self.window:SetPoint("CENTER")
	end

	self.window:SetUserPlaced(true)
	self.window:EnableMouse(true)
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
		if Settings:GetOption("windowPosition") then
			PlaySound(SOUNDKIT.UI_GARRISON_ARCHITECT_TABLE_BUILDING_PLACEMENT_ERROR)
			return
		end
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
		cells = {
			padding = Settings:Get("windowColumnSpacing"),
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
		elseif key == "windowColumnSpacing" then
			self.window.table.config.cells.padding = value
			self:Redraw()
		elseif key == "windowTutorials" then
			Tips:SetEnabled(value)
			Flags:Set("dragTip")
			self.window:Hide()
			self.window:Show()
			self:Redraw()
		elseif key == "windowPosition" then
			local position = Settings:Get("windowPosition")
			if position.enabled then
				position.point, _, position.relativePoint, position.x, position.y = self.window:GetPoint(1)
			end
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

local CharacterColumns
function Main:AddCharacterColumns()
	-- if CharacterColumns then return end

	local columns = {
		{
			name = "#",
			tooltip = "",
			align = "CENTER",
			cell = function(_, index)
				return { text = GRAY_FONT_COLOR:WrapTextInColorCode(index) }
			end,
		},
		{
			name = NAME,
			key = "name",
			align = "LEFT",
			cell = function(character)
				local note, tag = character:GetNote()

				tag = #tag > 0 and format(" |cnGOLD_FONT_COLOR:(%s)|r", #tag > 4 and "*" or tag) or tag

				local text = Util.WrapTextInClassColor(character.class, character.name)
				return {
					text = character:IsCurrent() and format("|T%s.tga:13:13|t%s%s", FRIENDS_TEXTURE_ONLINE, text, tag) or text .. tag,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						GameTooltip:SetText(Util.WrapTextInClassColor(character.class, format("%s-%s", character.name, character.realmName)))
						GameTooltip:AddLine(" ")
						if #note > 0 then
							GameTooltip:AddLine("|T131129:12|t" .. note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
							GameTooltip:AddLine(" ")
						end
						GameTooltip:AddLine(CLICK_TO_ENTER_COMMENT, GREEN_FONT_COLOR:GetRGB())
						GameTooltip:Show()
					end,
					onLeave = GameTooltip_Hide,
					onClick = function()
						Dialogs.ShowCharacterNote(character)
					end,
				}
			end,
		},
		{
			name = FRIENDS_LIST_REALM:match("^([^:]+)"),
			key = "realmName",
			cell = function(character)
				return { text = character.realmName }
			end,
		},
		{
			name = LEVEL,
			key = "level",
			align = "CENTER",
			cell = function(character)
				local _, timeToCharge = character:GetRestedXP()
				return {
					text = timeToCharge == 0 and GREEN_FONT_COLOR:WrapTextInColorCode(character.level) or character.level,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						character:AddXPToTooltip(GameTooltip)
						GameTooltip:Show()
					end,
					onLeave = GameTooltip_Hide,
				}
			end,
		},
		{
			name = ITEM_LEVEL_ABBR,
			key = "itemLevels",
			align = "CENTER",
			cell = function(character)
				local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = character:GetAverageItemLevel()
				return {
					text = avgItemLevel and floor(avgItemLevel) or "-",
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")

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
					end,
					onLeave = GameTooltip_Hide,
				}
			end,
		},
		{
			name = FACTION,
			key = "factionName",
			align = "CENTER",
			cell = function(character)
				return { text = CreateAtlasMarkup(format("questlog-questtypeicon-%s", character:GetFaction():lower()), 20, 20) }
			end,
		},
		{
			name = L["column_covenant"],
			key = "covenant",
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
			name = Util.Capitalize(SPELL_TARGET_TYPE6_DESC),
			key = "location",
			align = "CENTER",
			cell = function(character)
				return {
					text = character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(character.location) or character.location,
					onEnter = function(cellFrame)
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						GameTooltip:SetText(character.location, HIGHLIGHT_FONT_COLOR:GetRGB())

						local instruction = "|A:NPE_LeftClick:16:16|a|cnGREEN_FONT_COLOR:(" .. INVITE .. ")|r"
						character:AddPartyToTooltip(GameTooltip, CharacterStore.IsCurrentPlayer(character) and instruction or "")

						GameTooltip:Show()
					end,
					onLeave = GameTooltip_Hide,
					onClick = function()
						if CharacterStore.IsCurrentPlayer(character) then
							character:InviteLastParty()
						end
					end,
				}
			end,
		},
		{
			name = LASTONLINE,
			key = "lastUpdate",
			align = "CENTER",
			cell = function(character)
				local text = Util.FormatLastUpdateTime(character.lastUpdate)
				return { text = character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(FRIENDS_LIST_ONLINE) or text }
			end,
		},
	}

	CharacterColumns = columns
	self.columns = columns
end

-- function Main:AddRewardColumns()
-- 	for index, reward in ActiveRewards.Get():EnumerateSelected() do
-- 		-- cache
-- 		-- reward:ForEachItem(type)

-- 		local column = {
-- 			name = reward.name,
-- 			reward = reward,
-- 			selectedIndex = index,
-- 			-- onEnter = function(cellFrame)
-- 			-- 	local function updateTooltip()
-- 			-- 		GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
-- 			-- 		self:AddRewardToGameTooltip(reward)
-- 			-- 		GameTooltip:Show()
-- 			-- 	end
-- 			-- 	cellFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
-- 			-- 	cellFrame:SetScript("OnEvent", updateTooltip)
-- 			-- 	updateTooltip()
-- 			-- end,
-- 			-- onLeave = function(cellFrame)
-- 			-- 	cellFrame:UnregisterEvent("MODIFIER_STATE_CHANGED")
-- 			-- 	cellFrame:SetScript("OnEvent", nil)
-- 			-- 	GameTooltip:Hide()
-- 			-- end,
-- 			toggleHidden = true,
-- 			align = "CENTER",
-- 			cell = function(character)
-- 				local progress, isScanned = character:GetRewardProgress(reward.id)
-- 				local text

-- 				if not isScanned and reward:PlayerMeetsRequiredLevel(character.level) then
-- 					text = " "
-- 				elseif progress == nil then
-- 					text = reward:PlayerMeetsRequiredLevel(character.level) and CreateAtlasMarkup("PlayerRaidBlip", 13, 13) or "-"
-- 				else
-- 					text = progress:GetStatusLabel()
-- 				end

-- 				return {
-- 					text = text,
-- 					onEnter = function(cellFrame)
-- 						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
-- 						if progress == nil or progress:ObjectivesCount() == 0 then
-- 							if not reward:PlayerMeetsRequiredLevel(character.level) then
-- 								GameTooltip:AddLine(ITEM_MIN_LEVEL:format(reward.maximumLevel or reward.minimumLevel))
-- 							elseif isScanned then
-- 								GameTooltip_AddNormalLine(GameTooltip, character:GetNameInClassColor(true))
-- 								GameTooltip:AddLine(" ")
-- 								self:AddRewardObjectivesToGameTooltip(GameTooltip, reward)

-- 								GameTooltip:AddLine(" ")
-- 								GameTooltip_AddNormalLine(GameTooltip, L["progress_not_started"])
-- 							else
-- 								GameTooltip_AddNormalLine(GameTooltip, L["table_alts_collect_hint"])
-- 							end
-- 						elseif progress.total == 0 then
-- 							GameTooltip_AddNormalLine(GameTooltip, ERR_QUEST_NEED_PREREQS)
-- 						else
-- 							self:AddProgressToGameTooltip(progress)
-- 							cellFrame.hasInstructions = nil
-- 						end

-- 						GameTooltip:Show()
-- 					end,
-- 					onLeave = function()
-- 						GameTooltip:Hide()
-- 					end,
-- 					onClick = function(rowFrame, cellFrame)
-- 						if not CharacterStore.IsCurrentPlayer(character) then
-- 							return
-- 						end

-- 						if not cellFrame.hasInstructions then
-- 							GameTooltip:AddLine(" ")
-- 							GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_reset_progress_hint"]))
-- 							GameTooltip:Show()
-- 							cellFrame.hasInstructions = true
-- 						end

-- 						if IsControlKeyDown() then
-- 							self:ResetCell(character, reward)
-- 						end
-- 					end,
-- 				}
-- 			end,
-- 		}

-- 		table.insert(self.columns, column)
-- 	end
-- end

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
		GameTooltip:AddDoubleLine(L["progress_rewards_received_at"], WHITE_FONT_COLOR:WrapTextInColorCode(date("%Y-%m-%d %H:%M", progress.claimedAt) .. duration))
	elseif progress.startedAt then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["progress_started_at"], WHITE_FONT_COLOR:WrapTextInColorCode(date("%Y-%m-%d %H:%M", progress.startedAt)))
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
			-- column:SetHighlightTexture("auctionhouse-ui-row-highlight", "ADD")
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

local Cell = function(character, reward)
	local progress, isScanned = character:GetRewardProgress(reward.id)
	local text

	if not isScanned and reward:PlayerMeetsRequiredLevel(character.level) then
		text = " "
	elseif progress == nil then
		text = reward:PlayerMeetsRequiredLevel(character.level) and CreateAtlasMarkup("PlayerRaidBlip", 13, 13) or "-"
	else
		text = progress:GetStatusLabel()
	end

	return {
		text = text,
		onEnter = function(cellFrame)
			GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
			if progress == nil or progress:ObjectivesCount() == 0 then
				if not reward:PlayerMeetsRequiredLevel(character.level) then
					GameTooltip:AddLine(ITEM_MIN_LEVEL:format(reward.maximumLevel or reward.minimumLevel))
				elseif isScanned then
					GameTooltip_AddNormalLine(GameTooltip, character:GetNameInClassColor(true))
					GameTooltip:AddLine(" ")
					Main:AddRewardObjectivesToGameTooltip(GameTooltip, reward)

					GameTooltip:AddLine(" ")
					GameTooltip_AddNormalLine(GameTooltip, L["progress_not_started"])
				else
					GameTooltip_AddNormalLine(GameTooltip, L["table_alts_collect_hint"])
				end
			elseif progress.total == 0 then
				GameTooltip_AddNormalLine(GameTooltip, ERR_QUEST_NEED_PREREQS)
			else
				Main:AddProgressToGameTooltip(progress)
				cellFrame.hasInstructions = nil
			end

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
				Main:ResetCell(character, reward)
			end
		end,
	}
end

local function ResizeTable(t, len)
	t = t or {}
	for i = #t + 1, len do
		table.insert(t, {})
	end

	for i = #t, len + 1, -1 do
		t[i] = nil
	end

	return t
end

local Columns = {}
function Main:RefreshAllData()
	self.data = self.data or { columns = Columns, rows = { { columns = Columns } } }

	if not CharacterColumns then
		self:AddCharacterColumns()
	end

	local hiddenColumns = Settings:Get("hiddenColumns")

	-- Character Headers
	local numColumns = 0
	wipe(self.data.columns)

	for j = Settings:Get("windowRowNumbers") and 1 or 2, #CharacterColumns do
		--  def in ipairs(CharacterColumns) do
		local column = CharacterColumns[j]

		if not hiddenColumns[column.name] then
			numColumns = numColumns + 1

			-- if #self.data.columns < numColumns then
			table.insert(self.data.columns, {})
			-- end

			local header = self.data.columns[numColumns]
			-- wipe(header)
			header.key = column.key
			-- header.reward = nil
			header.text = column.name
			header.cell = column.cell
			header.align = column.align
			header.width = self:MeasureTextWidth(header.text)
			-- header.selectedIndex = nil
		end
	end

	-- Reward Headers
	for index, reward in ActiveRewards.Get():EnumerateSelected() do
		numColumns = numColumns + 1

		-- if #self.data.columns < numColumns then
		table.insert(self.data.columns, {})
		-- end

		local header = self.data.columns[numColumns]
		-- wipe(header)
		-- header.key = nil
		header.reward = reward
		header.text = reward.name
		header.align = "CENTER"
		header.width = self:MeasureTextWidth(header.text)
		header.width = 20
		header.selectedIndex = index
	end

	-- ResizeTable(self.data.columns, numColumns)

	-- Data Rows
	local numRows = CharacterStore.Get():GetNumEnabledCharacters() + 1
	ResizeTable(self.data.rows, numRows)

	for i, character in ipairs(CharacterStore.Get():ForEach(nop)) do
		local row = self.data.rows[i + 1]

		row.columns = ResizeTable(row.columns, numColumns)
		row.character = character

		for j, header in ipairs(self.data.columns) do
			local cell = row.columns[j]
			cell.character = character

			Mixin(cell, header.reward and Cell(character, header.reward) or header.cell(character, i))

			header.width = math.max(header.width, self:MeasureTextWidth(cell.text))
			print("width", header.width)
		end
	end

	print("DATA", #self.data.rows, #self.data.columns)
	_G.dd = self.data
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

	if true then
		self:RefreshAllData()

		local padding = Constants.TABLE_CELL_PADDING * 2
		local padding = Settings:Get("windowColumnSpacing") * 2

		tableHeight = (#self.data.rows - 1) * self.window.table.config.rows.height + self.window.table.config.header.height
		for _, header in ipairs(self.data.columns) do
			header.width = header.width + padding
			tableWidth = tableWidth + header.width
		end
	end

	local desiredTableHeight = Settings:Get("windowMaxRows") * Constants.TABLE_ROW_HEIGHT + Constants.TABLE_HEADER_HEIGHT

	self.window.border:SetShown(Settings:Get("windowBorder"))

	self.window:SetWidth(math.min(math.max(tableWidth, minWindowWidth), GetScreenWidth() * Settings:Get("windowMaxRelativeWidth") / windowScale))
	self.window:SetHeight(math.min(GetScreenHeight() / windowScale, math.min(tableHeight, desiredTableHeight) + Constants.TITLEBAR_HEIGHT + 2))

	self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
	self.window.titlebar.title:SetShown(self.window:GetWidth() > (240 / windowScale))
	self.window.titlebar.season:SetShown(self.window:GetWidth() > (600 / windowScale))

	-- self:UpdateSortArrow()
	self.window.table.data = self.data
	self.window.table:RenderTable()
	self:LayoutHeader(true)
	self:UpdateLayout()
end
