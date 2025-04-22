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
