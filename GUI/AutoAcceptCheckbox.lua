local _, namespace = ...

local L = namespace.L

-- The other addon reads WeeklyRewardsDB.global.autoAcceptQuests[questID] == true.

local ADVENTURE_MAPS = {
	-- [mapID] = true,
}

local PLAYER_CHOICES = {
	-- [choiceID] = true,
}

local function QuestIDFromAdventurePin(pin)
	return pin.questID
end

local function QuestIDFromPlayerChoiceOption(option)
	local info = option.optionInfo
	local button = info and info.buttons and info.buttons[1]
	return button and button.rewardQuestID
end

local HIDE_DELAY = 0.15

local checkbox = CreateFrame("CheckButton", nil, UIParent, "MinimalCheckboxTemplate")
checkbox:SetScale(0.7)
checkbox:SetFrameStrata("DIALOG")
checkbox:Hide()

local function AutoAcceptQuests()
	local weeklyRewards = WeeklyRewards
	local global = weeklyRewards and weeklyRewards.db and weeklyRewards.db.global
	if not global then
		return
	end

	global.autoAcceptQuests = global.autoAcceptQuests or {}
	return global.autoAcceptQuests
end

local function CancelHide()
	if checkbox.hideTimer then
		checkbox.hideTimer:Cancel()
		checkbox.hideTimer = nil
	end
end

local function HideCheckbox()
	CancelHide()
	checkbox.anchor = nil
	checkbox.questID = nil
	checkbox:Hide()
	if GameTooltip:GetOwner() == checkbox then
		GameTooltip:Hide()
	end
end

local function ScheduleHide()
	CancelHide()
	checkbox.hideTimer = C_Timer.NewTimer(HIDE_DELAY, function()
		checkbox.hideTimer = nil
		if checkbox:IsMouseOver() then
			return
		end

		HideCheckbox()
	end)
end

local function WatchAnchorHide(anchor)
	if anchor.wrAutoAcceptHideHook then
		return
	end

	anchor.wrAutoAcceptHideHook = true

	local function OnHide(self)
		if checkbox.anchor == self then
			HideCheckbox()
		end
	end

	if anchor:GetScript("OnHide") then
		anchor:HookScript("OnHide", OnHide)
	else
		anchor:SetScript("OnHide", OnHide)
	end
end

local function ShowAt(anchor, questID, point, relativePoint, x, y)
	local saved = AutoAcceptQuests()
	if not saved or not questID then
		return
	end

	CancelHide()
	checkbox.anchor = anchor
	checkbox.questID = questID
	checkbox:SetChecked(saved[questID] == true)
	checkbox:ClearAllPoints()
	checkbox:SetPoint(point, anchor, relativePoint, x, y)
	WatchAnchorHide(anchor)
	checkbox:Show()
end

local function OnPinEnter(pin)
	if pin.IsPin and not pin:IsPin() then
		return
	end
	if not pin.GetMap or pin:GetMap() ~= AdventureMapFrame then
		return
	end

	local mapID = C_AdventureMap.GetMapID()
	if not mapID or not ADVENTURE_MAPS[mapID] then
		return
	end

	local questID = QuestIDFromAdventurePin(pin)
	if not questID then
		return
	end

	ShowAt(pin, questID, "BOTTOMLEFT", "TOPRIGHT", -6, -6)
end

local function OnPinLeave(pin)
	if checkbox.anchor == pin then
		ScheduleHide()
	end
end

local function OnOptionEnter(option)
	local info = C_PlayerChoice.GetCurrentPlayerChoiceInfo()
	if not info or not info.choiceID or not PLAYER_CHOICES[info.choiceID] then
		return
	end

	local questID = QuestIDFromPlayerChoiceOption(option)
	if not questID then
		return
	end

	ShowAt(option, questID, "CENTER", "TOPRIGHT", -6, -6)
end

local function OnOptionLeave(option)
	if checkbox.anchor == option then
		ScheduleHide()
	end
end

local function BindScript(frame, script, handler)
	if frame:GetScript(script) then
		frame:HookScript(script, handler)
	else
		frame:SetScript(script, handler)
	end
end

local function BindOptionFrame(optionFrame, isGrid)
	if optionFrame.wrAutoAcceptHooked and not isGrid then
		return
	end

	BindScript(optionFrame, "OnEnter", OnOptionEnter)
	BindScript(optionFrame, "OnLeave", OnOptionLeave)
	optionFrame.wrAutoAcceptHooked = true
end

local adventureMapHooked = false

local function HookAdventureMap()
	if adventureMapHooked or not AdventureMap_QuestOfferPinMixin or not AdventureMap_QuestChoicePinMixin then
		return
	end

	adventureMapHooked = true
	hooksecurefunc(AdventureMap_QuestOfferPinMixin, "OnMouseEnter", OnPinEnter)
	hooksecurefunc(AdventureMap_QuestOfferPinMixin, "OnMouseLeave", OnPinLeave)
	hooksecurefunc(AdventureMap_QuestChoicePinMixin, "OnMouseEnter", OnPinEnter)
	hooksecurefunc(AdventureMap_QuestChoicePinMixin, "OnMouseLeave", OnPinLeave)
end

local playerChoiceHooked = false

local function HookPlayerChoice()
	if playerChoiceHooked or not PlayerChoiceFrameMixin then
		return
	end

	playerChoiceHooked = true
	hooksecurefunc(PlayerChoiceFrameMixin, "SetupOptions", function(self)
		if not self.optionFrameTemplate then
			return
		end

		local choiceInfo = self.choiceInfo
		local isGrid = choiceInfo and choiceInfo.playerChoiceLayout == Enum.PlayerChoiceLayout.Grid
		for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
			BindOptionFrame(optionFrame, isGrid)
		end
	end)
end

checkbox:SetScript("OnEnter", function(self)
	CancelHide()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(L["auto_accept_quest_tooltip"], 1, 1, 1, 1, true)
	GameTooltip:Show()
end)

checkbox:SetScript("OnLeave", function()
	if GameTooltip:GetOwner() == checkbox then
		GameTooltip:Hide()
	end
	ScheduleHide()
end)

checkbox:SetScript("OnClick", function(self)
	local saved = AutoAcceptQuests()
	local questID = self.questID
	if not saved or not questID then
		return
	end

	if self:GetChecked() then
		saved[questID] = true
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		saved[questID] = nil
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end
end)

checkbox:SetScript("OnEvent", function(_, event, name)
	if event == "ADDON_LOADED" then
		if name == "Blizzard_AdventureMap" then
			HookAdventureMap()
		elseif name == "Blizzard_PlayerChoice" then
			HookPlayerChoice()
		end
		return
	end

	HideCheckbox()
end)

checkbox:RegisterEvent("ADDON_LOADED")
checkbox:RegisterEvent("ADVENTURE_MAP_CLOSE")
checkbox:RegisterEvent("PLAYER_CHOICE_CLOSE")

if C_AddOns.IsAddOnLoaded("Blizzard_AdventureMap") then
	HookAdventureMap()
end

if C_AddOns.IsAddOnLoaded("Blizzard_PlayerChoice") then
	HookPlayerChoice()
end
