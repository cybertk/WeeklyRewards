local _, namespace = ...

local Util = {
	debug = false,
}

namespace.Util = Util
namespace.debug = function(...)
	Util:Debug(...)
end

function Util:Debug(...)
	if self.debug ~= true then
		return
	end

	if type(select(1, ...)) == "function" then
		-- Delayed print
		print(RED_FONT_COLOR:WrapTextInColorCode("Debug:"), select(1, ...)())
	else
		print(RED_FONT_COLOR:WrapTextInColorCode("Debug:"), ...)
	end
end

function Util:DebugQuest(questID)
	if self.debug ~= true or questID == nil or questID == 0 then
		return
	end

	local s = format(
		"(%d)[%s]: IsOn=%s Completed=%s TimeLeft=%s Objectives:",
		questID,
		QuestUtils_GetQuestName(questID),
		C_QuestLog.IsOnQuest(questID) == true and "YES" or "NO",
		C_QuestLog.IsQuestFlaggedCompleted(questID) == true and "YES" or "NO",
		C_TaskQuest.GetQuestTimeLeftSeconds(questID) or "unknown"
	)

	for i, objective in ipairs(C_QuestLog.GetQuestObjectives(questID) or {}) do
		if objective then
			s = s .. format("[%d] = ", i) .. objective.text
		end
	end

	print(RED_FONT_COLOR:WrapTextInColorCode("DebugQuest:"), s)
end

function Util:Filter(t, pattern, inplace, asList)
	asList = asList or true

	if inplace then
		for i = #t, 1, -1 do
			if pattern(t[i]) == false then
				table.remove(t, i)
			end
		end

		if not asList then
			for k, v in pairs(t) do
				if pattern(v) == false then
					t[k] = nil
				end
			end
		end
		return t
	end

	local newTable = {}
	local indicesProcessed = {}

	for i, v in ipairs(t) do
		if pattern(v) == true then
			table.insert(newTable, v)
			indicesProcessed[i] = true
		end
	end

	if not asList then
		for k, v in pairs(t) do
			if indicesProcessed[k] == nil and pattern(v) == true then
				newTable[k] = v
			end
		end
	end

	return newTable
end

function Util:GetCalendarActiveEvents(calendarType)
	local now = C_DateAndTime.GetCurrentCalendarTime()
	local events = {}

	calendarType = calendarType or "HOLIDAY"

	for i = 1, C_Calendar.GetNumDayEvents(0, now.monthDay) do
		local event = C_Calendar.GetDayEvent(0, now.monthDay, i)
		if
			event.calendarType == calendarType
			and C_DateAndTime.CompareCalendarTime(event.startTime, now) >= 0
			and C_DateAndTime.CompareCalendarTime(event.endTime, now) < 0
		then
			events[event.eventID] = event
		end
	end

	return events
end

function Util:GetTimestampFromCalendarTime(calendarTime)
	return time({
		year = calendarTime.year,
		month = calendarTime.month,
		day = calendarTime.monthDay,
		hour = calendarTime.hour,
		min = calendarTime.minute,
		sec = 0,
	})
end

-- Return whether the current character has learned the given profession
---@param skillLineID number The profession SkillLine IDs, see https://warcraft.wiki.gg/wiki/TradeSkillLineID
---@param useCache? boolean Use the cache by default
---@return boolean
function Util:IsProfessionLearned(skillLineID, useCache)
	useCache = useCache or true

	if self.professions == nil or not useCache then
		local professions = {}
		local tabIndices = { GetProfessions() }

		for i = 1, 5 do
			if tabIndices[i] ~= nil then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, _ = GetProfessionInfo(tabIndices[i])
				professions[skillLine] = { id = skillLine, icon = icon }
			end
		end

		self.professions = professions
	end

	return self.professions[skillLineID] ~= nil
end

-- Return the icon of given profession
---@param skillLineID number
---@return number The icon ID
function Util:GetProfessionIcon(skillLineID)
	local professionSpells = {
		[171] = 423321, -- Alchemy
		[794] = 278910, -- Archaeology
		[164] = 423332, -- Blacksmithing
		[185] = 2550, -- Cooking
		[333] = 423334, -- Enchanting
		[202] = 423335, -- Engineering
		[356] = 131474, -- Fishing
		[182] = 441327, -- Herbalism
		[773] = 423338, -- Inscription
		[755] = 423339, -- Jewelcrafting
		[165] = 423340, -- Leatherworking
		[186] = 423341, -- Mining
		[393] = 423342, -- Skinning
		[197] = 423343, -- Tailoring
	}

	return select(1, C_Spell.GetSpellTexture(professionSpells[skillLineID]))
end

function Util:DungeonToQuest(dungeonID)
	return dungeonID + 9000000
end

local equipLocToInvSlot = {
	INVTYPE_HEAD = { INVSLOT_HEAD },
	INVTYPE_NECK = { INVSLOT_NECK },
	INVTYPE_SHOULDER = { INVSLOT_SHOULDER },
	INVTYPE_BODY = { INVSLOT_BODY },
	INVTYPE_CHEST = { INVSLOT_CHEST },
	INVTYPE_ROBE = { INVSLOT_CHEST },
	INVTYPE_WAIST = { INVSLOT_WAIST },
	INVTYPE_LEGS = { INVSLOT_LEGS },
	INVTYPE_FEET = { INVSLOT_FEET },
	INVTYPE_WRIST = { INVSLOT_WRIST },
	INVTYPE_HAND = { INVSLOT_HAND },
	INVTYPE_FINGER = { INVSLOT_FINGER1, INVSLOT_FINGER2 },
	INVTYPE_TRINKET = { INVSLOT_TRINKET1, INVSLOT_TRINKET2 },
	INVTYPE_CLOAK = { INVSLOT_BACK },
	INVTYPE_WEAPON = { INVSLOT_MAINHAND, INVSLOT_OFFHAND },
	INVTYPE_2HWEAPON = { INVSLOT_MAINHAND },
	INVTYPE_WEAPONMAINHAND = { INVSLOT_MAINHAND },
	INVTYPE_WEAPONOFFHAND = { INVSLOT_OFFHAND },
	INVTYPE_HOLDABLE = { INVSLOT_OFFHAND },
	INVTYPE_SHIELD = { INVSLOT_OFFHAND },
	INVTYPE_RANGED = { INVSLOT_RANGED },
	INVTYPE_RANGEDRIGHT = { INVSLOT_RANGED },
	INVTYPE_THROWN = { INVSLOT_RANGED },
	INVTYPE_RELIC = { INVSLOT_RANGED },
	INVTYPE_TABARD = { INVSLOT_TABARD },
}
function Util:FindEquippedItem(itemIDs)
	local slots, items = {}, {}

	for _, itemID in ipairs(itemIDs) do
		for _, slot in ipairs(equipLocToInvSlot[select(4, C_Item.GetItemInfoInstant(itemID))]) do
			slots[slot] = true
		end

		items[itemID] = true
	end

	for slot in pairs(slots) do
		if items[GetInventoryItemID("player", slot)] then
			return Item:CreateFromEquipmentSlot(slot)
		end
	end

	Util:Debug("GetItemLevelByItemID: Cannot find the item")
end

Util.SavedInstances = {}
function Util.SavedInstances:Init()
	self.frame = CreateFrame("Frame")

	self.frame:SetScript("OnEvent", function(self, event, ...)
		if event == "ENCOUNTER_END" then
			local _, bossName, difficultyID, _, success = ...
			if not success then
				return
			end

			local instanceID = select(8, GetInstanceInfo())

			Util.SavedInstances:Add(instanceID, bossName, difficultyID)
		end
	end)

	self.frame:RegisterEvent("ENCOUNTER_END")

	self.claimed = {}
end

function Util.SavedInstances:Add(instanceID, bossName, difficultyID)
	self.claimed[instanceID] = self.claimed[instanceID] or {}
	self.claimed[instanceID][bossName] = self.claimed[instanceID][bossName] or {}

	table.insert(self.claimed[instanceID][bossName], difficultyID)
end

function Util.SavedInstances:Update()
	for i = 1, GetNumSavedInstances() do
		local _, _, reset, difficultyID, _, _, _, _, _, _, numEncounters, _, _, instanceID = GetSavedInstanceInfo(i)
		if reset ~= 0 then
			for j = 1, numEncounters do
				local bossName, _, isKilled = GetSavedInstanceEncounterInfo(i, j)
				if isKilled then
					self:Add(instanceID, bossName, difficultyID)
				end
			end
		end
	end
end

function Util.SavedInstances:FindByBossName(name, instanceID)
	if not self.claimed then
		self:Init()
		self:Update()
	end

	if not self.claimed[instanceID] then
		return
	end

	return self.claimed[instanceID][name]
end

function Util.FormatTimeDuration(seconds, useAbbreviation)
	return WorldQuestsSecondsFormatter:Format(seconds, useAbbreviation and SecondsFormatter.Abbreviation.OneLetter)
end

function Util.FormatLastUpdateTime(time)
	local seconds = GetServerTime() - time
	local minutes = seconds / 60
	local hours = minutes / 60
	local days = hours / 24

	if minutes < 1 then
		return LASTONLINE_SECS
	end

	if hours < 1 then
		-- Round up to 1 min
		return LASTONLINE_MINUTES:format(minutes)
	end

	if days < 1 then
		return LASTONLINE_HOURS:format(hours)
	end

	return LASTONLINE_DAYS:format(days)
end

-- item: name, texture, quality, quantity/amount
Util.MONEY_CURRENCY_ID = 0
function Util.FormatItem(item)
	if item.id == Util.MONEY_CURRENCY_ID then
		return GetMoneyString(item.quantity or item.amount)
	end

	local s = CreateSimpleTextureMarkup(item.texture or 0, 13, 13) -- There is hidden item, i.e. spark drops

	if item.quality then
		s = s .. ITEM_QUALITY_COLORS[item.quality].color:WrapTextInColorCode(format(" [%s]", item.name))
	else
		s = s .. " " .. item.name
	end

	local quantity = item.quantity or item.amount or 0
	if quantity > 1 then
		s = s .. format(" x%d", quantity)
	end
	return WHITE_FONT_COLOR:WrapTextInColorCode(s)
end

function Util.WrapTextInClassColor(classFile, ...)
	local color = C_ClassColor.GetClassColor(classFile)
	if color then
		return color:WrapTextInColorCode(...)
	end

	return ...
end

Util.TagCache = {}
function Util:ResolveTags(s)
	local resolvedString = s:gsub("{(%l+):(%d+)(%l*)}", function(type, id, suffix)
		id = tonumber(id)
		if self.TagCache[id] then
			return self.TagCache[id]
		end

		local name

		if type == "npc" then
			local tooltipData = C_TooltipInfo.GetHyperlink("unit:Creature-0-0-0-0-" .. id .. "-0")
			if tooltipData and tooltipData.lines and tooltipData.lines[1] then
				name = tooltipData.lines[1].leftText
			else
				name = UNKNOWN
			end
		elseif type == "currency" then
			local info = C_CurrencyInfo.GetCurrencyInfo(id)
			if info then
				name = info.name
			end
		elseif type == "map" then
			name = C_Map.GetMapInfo(id).name
		elseif type == "area" then
			name = C_Map.GetAreaInfo(id)
		elseif type == "quest" then
			name = C_QuestLog.GetTitleForQuestID(id)
		end

		self.TagCache[id] = name

		return self.TagCache[id]
	end)

	return resolvedString
end
