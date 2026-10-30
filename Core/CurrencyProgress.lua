local _, namespace = ...

local CurrencyProgress = namespace.RewardProgress:New()
namespace.CurrencyProgress = CurrencyProgress

function CurrencyProgress:Update()
	if self:hasClaimed() then
		return
	end

	local currency = C_CurrencyInfo.GetCurrencyInfo((self.pendingObjectives[1] or self.fulfilledObjectives[1]).currency)

	if currency.maxWeeklyQuantity > 0 then
		self.position = currency.quantityEarnedThisWeek
		self.total = currency.maxWeeklyQuantity

		if self.total == self.position then
			self:SetClaimed()
		end
	else
		self.position = currency.totalEarned
		self.total = currency.maxQuantity
	end

	if self.position > 0 then
		self:SetStarted()
	end

	self.records = nil
	self.startedAt = nil
end

local Record = {}
function CurrencyProgress:ForEachRecord(callback)
	local currency = C_CurrencyInfo.GetCurrencyInfo((self.pendingObjectives[1] or self.fulfilledObjectives[1]).currency)

	if currency.maxWeeklyQuantity > 0 then
		Record.text = CURRENCY_THIS_WEEK:format(format("|T%d:13|t %s", currency.iconFileID, currency.name))
	else
		Record.text = format("|T%d:13|t %s", currency.iconFileID, currency.name)
	end

	Record.s = ("|cnYELLOW_FONT_COLOR:%d/%d|r"):format(self.position, currency.maxWeeklyQuantity > 0 and currency.maxWeeklyQuantity or self.total)
	Record.fullfiled = self.position
	Record.required = self.total

	callback(Record, false)
end

function CurrencyProgress:SetExpired()
	local currency = C_CurrencyInfo.GetCurrencyInfo((self.pendingObjectives[1] or self.fulfilledObjectives[1]).currency)

	if currency.maxQuantity > self.total and currency.maxWeeklyQuantity == 0 then
		self.total = currency.maxQuantity
		self.claimedAt = nil
		self:SetStarted()
	else
		namespace.RewardProgress.SetExpired(self)
	end
end
