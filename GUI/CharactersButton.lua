local _, namespace = ...

local L = namespace.L
local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local Settings = namespace.Settings

WeeklyRewardsCharactersButtonMixin = CreateFromMixins(namespace.TitleBarButtonMixin)

function WeeklyRewardsCharactersButtonMixin:OnLoad()
	namespace.TitleBarButtonMixin.OnLoad(self)

	self.tooltip = L["characters_button_title"]
	self.tooltipText = L["characters_button_description"]

	Settings:SetupPagedMenu(self, function(_, rootMenu)
		local characterStore = CharacterStore.Get()
		rootMenu:CreateTitle():AddInitializer(function(frame)
			frame.fontString:SetText(
				format(
					"|cnWHITE_FONT_COLOR:%s (%d/%d)|r",
					L["characters_button_title"],
					characterStore:GetNumEnabledCharacters(),
					characterStore:GetNumCharacters()
				)
			)
		end)

		local pageSize = 30
		Settings:CreatePagedMenu(rootMenu, characterStore:ForEach(nop, CharacterStore.IsNotCurrentPlayer), function(character)
			local checkbox = rootMenu:CreateCheckbox(character:GetNameInClassColor(), function()
				return character.enabled or false
			end)

			checkbox:SetResponder(function()
				if IsControlKeyDown() then
					self:RemoveCharacter(character)
				else
					character.enabled = not character.enabled
					namespace.GUIMain:Redraw()
				end
				return MenuResponse.Refresh
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
