local addonName, namespace = ...

local WeeklyRewards = LibStub("AceAddon-3.0"):NewAddon(namespace, addonName, "AceConsole-3.0", "AceEvent-3.0")

local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")
local AceDB = LibStub("AceDB-3.0")

local Archivist = namespace.Archivist

local L = namespace.L
local DB = namespace.DB
local Util = namespace.Util
local CharacterStore = namespace.CharacterStore
local ActiveRewards = namespace.ActiveRewards
local RewardSummary = namespace.RewardSummary
local Main = namespace.GUIMain

_G.WeeklyRewards = WeeklyRewards

WeeklyRewardsArchive = WeeklyRewardsArchive or {}

local defaultDB = {
	---@type WR_DefaultGlobal
	global = {
		activeRewards = {},
		characters = {},
		minimap = {
			minimapPos = 235,
			hide = false,
			lock = false,
		},
		main = {
			hiddenColumns = {},
			windowScale = 100,
			windowMaxRelativeWidth = 80,
			windowMaxRows = 20,
			windowBackgroundColor = { r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1 },
			windowBorder = true,
		},
		utils = {
			untrackQuests = false,
			broadcastRewards = false,
		},
		dbVersion = 8,
	},
}

function WeeklyRewards:MigrateDB() end

function WeeklyRewards:OnInitialize()
	_G["BINDING_NAME_WeeklyRewards"] = L["BINDING_NAME_WeeklyRewards"]
	self:RegisterChatCommand("wr", "ExecuteChatCommands")
	self:RegisterChatCommand("WeeklyRewards", "ExecuteChatCommands")

	self.db = AceDB:New("WeeklyRewardsDB", defaultDB, true)

	Util.debug = self.db.global.debug
	Util:Debug("Debug Mode:", Util.debug)

	local WRLDB = LibDataBroker:NewDataObject(addonName, {
		label = addonName,
		type = "launcher",
		icon = "Interface/AddOns/WeeklyRewards/Media/Icon.blp",
		OnClick = function(...)
			Main:ToggleWindow()
		end,
		OnTooltipShow = function(tooltip)
			tooltip:SetText(addonName, 1, 1, 1)
			tooltip:AddLine(L["minimap_tooltip_left_click"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			local dragText = L["minimap_tooltip_drag"]
			if self.db.global.minimap.lock then
				dragText = dragText .. L["minimap_tooltip_locked"]
			end
			tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		end,
	})
	LibDBIcon:Register(addonName, WRLDB, self.db.global.minimap)
	LibDBIcon:AddButtonToCompartment(addonName)

	self:MigrateDB()
end

function WeeklyRewards:OnEnable()
	CharacterStore:SetCharacterTemplate(namespace.Character)
	CharacterStore:SetFlatField("progress")

	local characterStore = CharacterStore.Load(self.db.global.characters)
	local character = characterStore:CurrentPlayer()
	local activeRewards = ActiveRewards:New(self.db.global.activeRewards)
	local archive = Archivist:Initialize(WeeklyRewardsArchive)

	RewardSummary:Init(characterStore)

	self.character = character
	self.activeRewards = activeRewards
	self.archive = archive

	EventRegistry:RegisterCallback("CK_LOOT_SCANNER_ITEM_LOOTED", function(self, source, quantity, itemID, currencyID)
		character:ReceiveDrop(source, quantity, itemID, currencyID)
	end)

	self:RegisterEvent("QUEST_CURRENCY_LOOT_RECEIVED", function(event, questId, currencyId, quantity)
		character:ReceiveReward(questId, quantity, nil, currencyId)
	end)
	self:RegisterEvent("QUEST_LOOT_RECEIVED", function(event, questId, itemLink, quantity)
		character:ReceiveReward(questId, quantity, itemLink)
	end)

	self:RegisterEvent("QUEST_TURNED_IN", function(event, questId, xp, money)
		if money and money > 0 then
			Util:Debug("Received money:", GetMoneyString(money))
			character:ReceiveReward(questId, money, nil, Util.MONEY_CURRENCY_ID)
		end
		-- C_QuestLog.IsQuestFlaggedCompleted() might returns false in this context
		self:UpdateProgress(questId)

		self:UpdateRewardsGUIDSafe(character, questId)
	end)

	self:RegisterEvent("LFG_COMPLETION_REWARD", function(event)
		local dungeon = select(10, GetInstanceInfo())
		local quest = Util:DungeonToQuest(dungeon)

		character:UpdateProgress(quest)
		for i = 1, select(6, GetLFGDungeonRewards(dungeon)) do
			local _, _, quantity, _, rewardType, item = GetLFGDungeonRewardInfo(dungeon, i)
			if rewardType == "item" then
				character:ReceiveReward(quest, quantity, item)
			end
		end

		self:UpdateRewardsGUIDSafe(character, quest)
	end)

	self:RegisterEvent("ZONE_CHANGED", function(event)
		character:UpdateLocation()
	end)

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", function(event)
		character:UpdateLocation()
	end)

	self:RegisterEvent("COVENANT_CHOSEN", function(event)
		character:UpdateCovenant(true)
	end)

	self:RegisterEvent("GARRISON_TALENT_COMPLETE", function(event)
		character:UpdateCovenant(true)
	end)

	self:RegisterEvent("PLAYER_ENTERING_WORLD", function(event, isInitialLogin, isReloadingUi)
		if isInitialLogin == false and isReloadingUi == false then
			return
		end

		if self.db.global.utils.untrackQuests then
			character:RemoveQuestsWatch()
		end

		self:UpdateActiveRewards()
	end)

	self:RegisterEvent("PLAYER_LEVEL_CHANGED", function()
		character:Scan(activeRewards)
	end)

	self:RegisterEvent("QUEST_LOG_UPDATE", function()
		Util:InvokeAfter(5, character.UpdateProgress, character)
	end)

	self:RegisterEvent("ITEM_PUSH", function()
		Util:InvokeAfter(5, character.UpdateProgress, character)
	end)

	self:RegisterEvent("QUEST_ACCEPTED", function()
		self:UpdateActiveRewards()
	end)
end

function WeeklyRewards:OnDisable()
	self:UnregisterAllEvents()
	self:UnregisterAllBuckets()
end

function WeeklyRewards:ExecuteChatCommands(command)
	if command == "debug" then
		-- Toggle Debug Mode
		self.db.global.debug = not self.db.global.debug
		Util.debug = self.db.global.debug
		print("Debug Mode:", self.db.global.debug)
		return
	end

	Main:ToggleWindow()
end

function WeeklyRewards:UpdateActiveRewards()
	self.activeRewards:Reset(function(outdatedReward)
		CharacterStore.Get():ForEach(function(x)
			local outdatedProgress = x:ResetProgress(outdatedReward)
			if outdatedProgress then
				local store = self.archive:Load("RawData", x.GUID)
				table.insert(store, outdatedProgress)
			end
		end, next)
	end)

	self.activeRewards:Update(DB:GetAllCandidates())
	self.character:Scan(self.activeRewards)
	self.character:UpdateRewardsGUID()
end

function WeeklyRewards:UpdateRewardsGUIDSafe(character, quest, attempts)
	if attempts == nil then
		attempts = 60
	end

	C_Timer.NewTicker(0.5, function(timer)
		attempts = attempts - 1
		if character:UpdateRewardsGUID(quest) or attempts < 0 then
			Util:Debug("canceled")
			timer:Cancel()
		end
	end)
end

function WeeklyRewards:UpdateProgress(quest)
	local completion = self.character:UpdateProgress(quest)

	if self.db.global.utils.broadcastRewards ~= true then
		return
	end

	local lastClaimed
	for rewardID, _ in pairs(completion) do
		self:Broadcast(rewardID)
		lastClaimed = rewardID
	end

	self.lastClaimed = lastClaimed or self.lastClaimed
end

function WeeklyRewards:Broadcast(rewardID, channel)
	rewardID = rewardID or self.lastClaimed

	if rewardID == nil then
		return
	end
	RewardSummary:Create(rewardID):Broadcast(channel)
end
