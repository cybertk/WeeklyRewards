local _, namespace = ...

local L = namespace.L
local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local Settings = namespace.Settings
local Constants = namespace.Constants
local Utils = namespace.Utils

WeeklyRewardsCharactersButtonMixin = {}

function WeeklyRewardsCharactersButtonMixin:OnLoad()
	self:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)

	Settings:SetupPagedMenu(self, function(_, rootMenu)
		rootMenu:CreateTitle():AddInitializer(function(frame)
			frame.fontString:SetText(format("|cnWHITE_FONT_COLOR:%s (%d)|r", L["characters_button_title"], CharacterStore.Get():GetNumEnabledCharacters()))
		end)

		local function CharactersFilter(character)
			return not CharacterStore.IsCurrentPlayer(character)
		end

		local characterStore = CharacterStore.Get()
		local characters = characterStore:ForEach(function() end, CharactersFilter)

		local pageSize = 20
		Settings:CreatePagedMenu(rootMenu, characters, function(character)
			local checkbox = rootMenu:CreateCheckbox(character:GetNameInClassColor(), function()
				return character.enabled or false
			end)

			checkbox:SetResponder(function()
				if IsControlKeyDown() then
					self:RemoveCharacter(character)
					return MenuResponse.CloseAll
				else
					character.enabled = not character.enabled
					namespace.GUIMain:Redraw()
					return MenuResponse.Refresh
				end
			end)
		end, self, pageSize)

		rootMenu:CreateSpacer()
		rootMenu:CreateTitle(GREEN_FONT_COLOR:WrapTextInColorCode(L["characters_button_remove_hint"]))
	end)
end

function WeeklyRewardsCharactersButtonMixin:RemoveCharacter(character)
	Util:Debug("Removing character:", character.name)

	StaticPopup_ShowGenericConfirmation(CONFIRM_COMPACT_UNIT_FRAME_PROFILE_DELETION:format(character:GetNameInClassColor()), function()
		CharacterStore.Get():RemoveCharacter(character.GUID)
		namespace.GUIMain:Redraw()
	end)
end

function WeeklyRewardsCharactersButtonMixin:OnEnter()
	self.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
	Utils:SetBackgroundColor(self, 1, 1, 1, 0.05)
	namespace.GUIMain:SetTooltipOwner(GameTooltip, self)
	GameTooltip:SetText(L["characters_button_title"], 1, 1, 1, 1, true)
	GameTooltip:AddLine(L["characters_button_description"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:Show()
end

function WeeklyRewardsCharactersButtonMixin:OnLeave()
	self.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
	Utils:SetBackgroundColor(self, 1, 1, 1, 0)
	GameTooltip:Hide()
end
