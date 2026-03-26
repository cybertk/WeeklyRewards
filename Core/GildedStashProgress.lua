local _, namespace = ...

local Util = namespace.Util

local GildedStashProgress = namespace.RewardProgress:New()
namespace.GildedStashProgress = GildedStashProgress

local GILDED_STASH_SPELL_ID = 7591

function GildedStashProgress:hasStarted()
	return self.total == 4
end

function GildedStashProgress:_UpdateRecords()
	local widget = C_UIWidgetManager.GetSpellDisplayVisualizationInfo(GILDED_STASH_SPELL_ID)

	if widget == nil or widget.spellInfo == nil or widget.spellInfo.tooltip == nil then
		if self.records == nil then
			self.records = {}
			table.insert(self.records, {
				text = RED_FONT_COLOR:WrapTextInColorCode("Go to Silvermoon City to update the progress"),
				fulfilled = 0,
				required = 1,
			})
		end
		return
	end

	local record, fulfilled = widget.spellInfo.tooltip:match("COLOR:([^%d]*(%d)/4)")

	fulfilled = tonumber(fulfilled) or 0

	self.records = { {
		text = record or "",
		fulfilled = fulfilled,
		required = 4,
	} }
	self.position = fulfilled
	self.total = 4
end
