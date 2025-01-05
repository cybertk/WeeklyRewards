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

function Util:Filter(t, pattern, inplace)
	local tableToReturn = inplace == true and t or {}

	if inplace then
		for k, v in pairs(t) do
			if pattern(v) == false then
				t[k] = nil
			end
		end
		return t
	end

	local newTable = {}

	for k, v in pairs(t) do
		if pattern(v) == true then
			newTable[k] = v
		end
	end

	return newTable
end

function Util.FormatTimeDuration(seconds, useAbbreviation)
	local minutes = seconds / 60
	local hours = minutes / 60
	local days = hours / 24

	useAbbreviation = useAbbreviation or false

	local unitD, unitH, unitM = useAbbreviation and "d" or " Days", useAbbreviation and "h" or " Hours", useAbbreviation and "m" or " Minutes"

	if hours < 1 then
		-- Round up to 1 min
		return format("%d%s", minutes >= 1 and minutes or 1, unitM)
	end

	if days < 1 then
		return format("%d%s", hours % 24, unitH)
	end

	return format("%d%s %d%s", days, unitD, hours % 24, unitH)
end

function Util.FormatItem(item)
	local s = CreateSimpleTextureMarkup(item.texture or 0, 13, 13) -- There is hidden item, i.e. spark drops
		.. ITEM_QUALITY_COLORS[item.quality].color:WrapTextInColorCode(format(" [%s]", item.name))

	if item.quantity > 1 then
		s = s .. format(" x%d", item.quantity)
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
