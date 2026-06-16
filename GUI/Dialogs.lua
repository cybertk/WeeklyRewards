local addonName, namespace = ...

local L = namespace.L
local Util = namespace.Util

local EditBoxNumLines
local function StaticPopup_MultiLineEditBoxOnShow(editBox)
	editBox:SetMultiLine(true)
	editBox:SetTextInsets(6, 6, 6, 24)

	EditBoxNumLines = -1
end

local function StaticPopup_MultiLineEditBoxOnTextChanged(editBox)
	local numLines = editBox:GetNumLines()

	if EditBoxNumLines == numLines then
		return
	end

	EditBoxNumLines = numLines
	StaticPopup_ResizeShownDialogs()
end

local function StaticPopup_MultiLineEditBoxOnEnterPressed(editBox)
	editBox:Insert("\n")
end

local CHARACTER_NOTE = {
	text = SET_FRIENDNOTE_LABEL,
	button1 = OKAY,
	button2 = CANCEL,
	hasEditBox = true,
	editBoxWidth = 350,
	maxLetters = 3000,
	OnShow = function(dialog, character)
		local editBox = dialog:GetEditBox()

		editBox:SetText(character:GetNote())
		editBox:SetFocus()

		StaticPopup_MultiLineEditBoxOnShow(editBox)
	end,
	OnAccept = function(dialog, character)
		character:SetNote(dialog:GetEditBox():GetText())
		namespace.GUIMain:Redraw()
	end,
	EditBoxOnTextChanged = StaticPopup_MultiLineEditBoxOnTextChanged,
	EditBoxOnEnterPressed = StaticPopup_MultiLineEditBoxOnEnterPressed,
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
