local _, namespace = ...

local CurrencyProgress = namespace.RewardProgress:New()
namespace.CurrencyProgress = CurrencyProgress

function CurrencyProgress:_UpdateRecords()
	self.position = 0
	self.total = 0
	self.records = {}

	local currency = C_CurrencyInfo.GetCurrencyInfo(self.pendingObjectives[1].currency)

	local text = CURRENCY_THIS_WEEK:format(format("|T%d:13|t %s", currency.iconFileID, currency.name))

	if currency.maxWeeklyQuantity > 0 then
		text = text .. format(": %d/%d", currency.quantityEarnedThisWeek, currency.maxWeeklyQuantity)
	end

	self:_AddRecord({ text = text, fulfilled = currency.quantityEarnedThisWeek, required = currency.maxWeeklyQuantity > 0 and currency.maxWeeklyQuantity or 1 })
end
