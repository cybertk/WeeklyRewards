local addonName, namespace = ...

local L = namespace.L
local Util = namespace.Util

local CHARACTER_NOTE = {
	text = SET_FRIENDNOTE_LABEL,
	button1 = OKAY,
	button2 = CANCEL,
	hasEditBox = true,
	editBoxWidth = 350,
	maxLetters = 48,
	OnShow = function(dialog, character)
		local editBox = dialog:GetEditBox()
		editBox:SetText(character:GetNote())
		editBox:SetFocus()
	end,
	OnAccept = function(dialog, character)
		character:SetNote(dialog:GetEditBox():GetText())
		namespace.GUIMain:Redraw()
	end,
	EditBoxOnEnterPressed = function(editBox, data)
		editBox:GetParent():GetButton1():Click()
	end,
	EditBoxOnEscapePressed = StaticPopup_StandardEditBoxOnEscapePressed,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

local Dialogs = {}

function Dialogs.ShowCharacterNote(character)
	local tag = addonName .. "_CharacterNote"

	if not StaticPopupDialogs[tag] then
		StaticPopupDialogs[tag] = CHARACTER_NOTE
	end

	StaticPopup_Show(tag, Util.WrapTextInClassColor(character.class, character.name), nil, character)
end

namespace.Dialogs = Dialogs
