local _, namespace = ...

local L = namespace.L
local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards

local Dialogs = namespace.Dialogs

namespace.ColumnHeaderMixin = {}

local function ApplySort(header)
	local store = CharacterStore.Get()
	store:SetSortOrder(header.key)
	local field, ascending = store:GetSortOrder()
	WeeklyRewards.db.global.main.sortColumn = field
	WeeklyRewards.db.global.main.sortAscending = ascending
end

function namespace.ColumnHeaderMixin:New()
	return {
		name = self.label,
		key = self.key,
		align = self.align,
		reward = self.reward,
		cell = self.cell,
		onEnter = function(cellFrame)
			self:OnEnter(cellFrame)
		end,
		onLeave = function(cellFrame)
			self:OnLeave(cellFrame)
		end,
		onClick = function(_, cellFrame)
			self:OnClick(cellFrame)
		end,
	}
end

function namespace.ColumnHeaderMixin:OnEnter(cellFrame)
	GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
	GameTooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_sort_hint"]))
	GameTooltip:Show()
end

function namespace.ColumnHeaderMixin:OnLeave()
	GameTooltip:Hide()
end

function namespace.ColumnHeaderMixin:OnClick()
	if IsControlKeyDown() then
		WeeklyRewards.db.global.main.hiddenColumns[self.label] = true
	else
		ApplySort(self)
	end
	namespace.GUIMain:Redraw()
end

namespace.CharacterNameHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterNameHeaderMixin.label = NAME
namespace.CharacterNameHeaderMixin.key = "name"
function namespace.CharacterNameHeaderMixin.cell(character)
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
end

namespace.CharacterRealmHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterRealmHeaderMixin.label = L["column_realm"]
namespace.CharacterRealmHeaderMixin.key = "realmName"
function namespace.CharacterRealmHeaderMixin.cell(character)
	return { text = character.realmName }
end

namespace.CharacterLevelHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterLevelHeaderMixin.label = LEVEL
namespace.CharacterLevelHeaderMixin.key = "level"
namespace.CharacterLevelHeaderMixin.align = "CENTER"
function namespace.CharacterLevelHeaderMixin.cell(character)
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
end

namespace.CharacterItemLevelHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterItemLevelHeaderMixin.label = ITEM_LEVEL_ABBR
namespace.CharacterItemLevelHeaderMixin.key = "itemLevels"
namespace.CharacterItemLevelHeaderMixin.align = "CENTER"
function namespace.CharacterItemLevelHeaderMixin.cell(character)
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
end

namespace.CharacterFactionHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterFactionHeaderMixin.label = FACTION
namespace.CharacterFactionHeaderMixin.key = "factionName"
namespace.CharacterFactionHeaderMixin.align = "CENTER"
function namespace.CharacterFactionHeaderMixin.cell(character)
	return { text = CreateAtlasMarkup(format("questlog-questtypeicon-%s", character:GetFaction():lower()), 20, 20) }
end

namespace.CharacterCovenantHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterCovenantHeaderMixin.label = L["column_covenant"]
namespace.CharacterCovenantHeaderMixin.key = "covenant"
namespace.CharacterCovenantHeaderMixin.align = "CENTER"
function namespace.CharacterCovenantHeaderMixin.cell(character)
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
end

namespace.CharacterLocationHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterLocationHeaderMixin.label = L["column_location"]
namespace.CharacterLocationHeaderMixin.key = "location"
namespace.CharacterLocationHeaderMixin.align = "CENTER"
function namespace.CharacterLocationHeaderMixin.cell(character)
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
end

namespace.CharacterLastUpdateHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)
namespace.CharacterLastUpdateHeaderMixin.label = L["column_last_update"]
namespace.CharacterLastUpdateHeaderMixin.key = "lastUpdate"
namespace.CharacterLastUpdateHeaderMixin.align = "CENTER"
function namespace.CharacterLastUpdateHeaderMixin.cell(character)
	local text = Util.FormatLastUpdateTime(character.lastUpdate)
	return { text = character:IsCurrent() and GREEN_FONT_COLOR:WrapTextInColorCode(text) or text }
end

namespace.CharacterHeaderMixins = {
	namespace.CharacterNameHeaderMixin,
	namespace.CharacterRealmHeaderMixin,
	namespace.CharacterLevelHeaderMixin,
	namespace.CharacterItemLevelHeaderMixin,
	namespace.CharacterFactionHeaderMixin,
	namespace.CharacterCovenantHeaderMixin,
	namespace.CharacterLocationHeaderMixin,
	namespace.CharacterLastUpdateHeaderMixin,
}

namespace.RewardHeaderMixin = CreateFromMixins(namespace.ColumnHeaderMixin)

function namespace.RewardHeaderMixin:OnEnter(cellFrame)
	local reward = self.reward
	local function updateTooltip()
		GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
		namespace.GUIMain:AddRewardToGameTooltip(reward)
		GameTooltip:Show()
	end
	cellFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
	cellFrame:SetScript("OnEvent", updateTooltip)
	updateTooltip()
end

function namespace.RewardHeaderMixin:OnLeave(cellFrame)
	cellFrame:UnregisterEvent("MODIFIER_STATE_CHANGED")
	cellFrame:SetScript("OnEvent", nil)
	GameTooltip:Hide()
end

function namespace.RewardHeaderMixin:OnClick()
	if IsControlKeyDown() then
		ActiveRewards.Get():ToggleExclusion(self.reward:GetCandidateID())
	else
		ApplySort(self)
	end
	namespace.GUIMain:Redraw()
end

function namespace.RewardHeaderMixin:Collect()
	local headers = {}
	for _, reward in ipairs(ActiveRewards.Get()) do
		-- cache
		reward:ForEachItem(type)

		local header = CreateFromMixins(self)
		header.label = reward.name
		header.key = reward.id
		header.reward = reward
		header.align = "CENTER"
		header.cell = function(character)
			local progress, isScanned = character:GetRewardProgress(reward.id)
			local text

			if not isScanned and reward:PlayerMeetsRequiredLevel(character.level) then
				text = " "
			elseif progress == nil then
				text = reward:PlayerMeetsRequiredLevel(character.level) and CreateAtlasMarkup("PlayerRaidBlip", 13, 13) or "-"
			elseif progress.total == 0 then
				text = "-"
			elseif progress.claimedAt and progress:IsExpired() then
				text = CreateAtlasMarkup("checkmark-minimal-disabled", 15, 15)
			else
				text = progress.total < 100 and format("%d / %d", progress.position, progress.total)
					or format("%.0f%%", progress.position / progress.total * 100)

				if progress:IsExpired() then
					text = GRAY_FONT_COLOR:WrapTextInColorCode(text)
				elseif progress.hasClaimed and progress:hasClaimed() then
					text = CreateAtlasMarkup("common-icon-checkmark", 15, 15)
				elseif progress.hasStarted and progress:hasStarted() then
					text = YELLOW_FONT_COLOR:WrapTextInColorCode(text)
				end
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
						namespace.GUIMain:ResetCell(character, reward)
					end
				end,
			}
		end
		table.insert(headers, header)
	end
	return headers
end
