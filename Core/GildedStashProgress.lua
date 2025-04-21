local _, namespace = ...

local Util = namespace.Util

local GildedStashProgress = namespace.RewardProgress:New()
namespace.GildedStashProgress = GildedStashProgress

local GILDED_STASH_SPELL_ID = 6659

function GildedStashProgress:hasStarted()
	return self.total == 3
end

function GildedStashProgress:_UpdateRecords()
	local widget = C_UIWidgetManager.GetSpellDisplayVisualizationInfo(GILDED_STASH_SPELL_ID)

	if widget == nil or widget.spellInfo == nil or widget.spellInfo.tooltip == nil then
		if self.records == nil then
			self.records = {}
			table.insert(self.records, {
				text = RED_FONT_COLOR:WrapTextInColorCode("Go to Khaz Algar to update the progress"),
				fulfilled = 0,
				required = 1,
			})
		end
		return
	end

	local record, fulfilled = widget.spellInfo.tooltip:match("COLOR:([^%d]*(%d)/3)")

	fulfilled = tonumber(fulfilled) or 0

	self.records = { {
		text = record or "",
		fulfilled = fulfilled,
		required = 3,
	} }
	self.position = fulfilled
	self.total = 3

	if self.position == 3 then
		self.fulfilledObjectives = self.pendingObjectives
		self.pendingObjectives = {}
	end
end
