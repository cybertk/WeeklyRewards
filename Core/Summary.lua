local _, namespace = ...

local L = namespace.L
local Util = namespace.Util

local RewardSummary = {}
RewardSummary.__index = RewardSummary

function RewardSummary:Init(store)
	self.charactersStore = store
	self.character = store:CurrentPlayer()
end

function RewardSummary:_AggregateObjects(aggregated, objects)
	for _, o in ipairs(objects) do
		local uniqueObject

		if o.currency == 0 then
			self.money = self.money + o.quantity
		elseif o.currency then
			if aggregated[o.currency] == nil then
				aggregated[o.currency] = { currency = o.currency, quantity = 0 }
			end
			uniqueObject = aggregated[o.currency]

			if self.currencies[o.currency] == nil then
				self.currencies[o.currency] = { currency = o.currency, quantity = 0 }
			end
			self.currencies[o.currency].quantity = self.currencies[o.currency].quantity + o.quantity
		elseif o.item then
			local slot = select(4, C_Item.GetItemInfoInstant(o.item))
			if slot and slot ~= "INVTYPE_NON_EQUIP_IGNORE" then
				table.insert(self.gears, o.item)
			else
				if self.items[o.item] == nil then
					self.items[o.item] = { item = o.item, quantity = 0 }
				end
				self.items[o.item].quantity = self.items[o.item].quantity + o.quantity
			end

			if aggregated[o.item] == nil then
				aggregated[o.item] = { item = o.item, quantity = 0 }
			end
			uniqueObject = aggregated[o.item]
		end

		if uniqueObject then
			uniqueObject.quantity = uniqueObject.quantity + o.quantity
		end
	end
end

function RewardSummary:Create(rewardID)
	local o = {
		count = 0,
		rewards = {},
		drops = {},
		items = {},
		gears = {},
		currencies = {},
		money = 0,
	}

	setmetatable(o, RewardSummary)

	self.charactersStore:ForEach(function(character)
		local progress = character.progress[rewardID]

		if progress then
			if progress:hasClaimed() then
				o.count = o.count + 1
			end

			o:_AggregateObjects(o.rewards, progress.rewards or {})
			o:_AggregateObjects(o.drops, progress.drops or {})
		end
	end)

	do
		local progress = self.character.progress[rewardID]

		o.name = progress:ObjectivesCount() == 1 and GetQuestLink(progress:Quest()) or format("<%s>", progress.name)
	end

	Util:Debug("Created summary", rewardID, o.name, self.character.progress[rewardID]:ObjectivesCount())

	return o
end

function RewardSummary:GetReportChannel()
	return IsInRaid() and "RAID" or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInGroup() and "PARTY" or nil
end

function RewardSummary:GetPrinter(channel)
	if channel == nil then
		return print
	end

	return function(text)
		SendChatMessage(text, channel)
	end
end

function RewardSummary:Broadcast(channel)
	channel = channel or self:GetReportChannel()

	local output = self:GetPrinter(channel)

	local messages = {}
	for _, o in pairs(self.currencies) do
		if C_CurrencyInfo.IsAccountTransferableCurrency(o.currency) then
			table.insert(messages, format("%sx%d", C_CurrencyInfo.GetCurrencyLink(o.currency), o.quantity))
		end
	end

	local header = L["summary_completed_count"]:format(self.name, self.count)
	do
		local r = {}

		table.insert(r, #self.gears > 0 and RESISTANCE_TEMPLATE:format(#self.gears, BAG_FILTER_EQUIPMENT) or nil)
		table.insert(r, self.money >= COPPER_PER_GOLD and GOLD_AMOUNT:format(math.floor(self.money / COPPER_PER_GOLD)) or nil)
		table.insert(r, #messages > 0 and ACCOUNT_LEVEL_CURRENCY .. ": " or nil)

		if #r > 0 then
			header = header .. ". " .. L["summary_rewards_received"] .. r[1]
		end

		for i = 2, #r do
			header = header .. ", " .. r[i]
		end
	end

	local brand = channel and "#WeeklyRewards# " or "|cff00ff80WeeklyRewards|r: "
	table.insert(messages, 1, brand .. header)

	if #messages <= 3 then
		output(messages[1] .. (messages[2] or "") .. (messages[3] or ""))
	else
		for i, message in ipairs(messages) do
			C_Timer.After((i - 1) * 0.5, function()
				output(message)
			end)
		end
	end

	Util:Debug("Broadcast done", #messages, channel)
end

function RewardSummary:AddToTooltip(tooltip)
	local total = self.charactersStore:GetNumEnabledCharacters()
	GameTooltip_AddColoredDoubleLine(
		tooltip,
		L["summary_progress"],
		format("%d/%d", self.count, total),
		NORMAL_FONT_COLOR,
		self.count == total and GREEN_FONT_COLOR or YELLOW_FONT_COLOR
	)

	if self.count == 0 then
		return
	end

	GameTooltip_AddColoredDoubleLine(
		tooltip,
		L["summary_rewards_received"],
		#self.gears > 0 and format("|cnLIGHTBLUE_FONT_COLOR:%s:|r %d", BAG_FILTER_EQUIPMENT, #self.gears) or nil,
		NORMAL_FONT_COLOR,
		WHITE_FONT_COLOR
	)

	for _, o in pairs(self.items) do
		local item = Item:CreateFromItemID(o.item)
		GameTooltip_AddColoredDoubleLine(
			tooltip,
			item:IsItemDataCached() and format("|T%d:12|t %s", item:GetItemIcon(), item:GetItemName()) or LFG_LIST_LOADING,
			o.quantity,
			C_ColorOverrides.GetColorForQuality(item:GetItemQuality() or Enum.ItemQuality.Common),
			WHITE_FONT_COLOR
		)
	end

	for _, o in pairs(self.currencies) do
		local currency = C_CurrencyInfo.GetCurrencyInfo(o.currency)
		local type = C_CurrencyInfo.IsAccountTransferableCurrency(o.currency) and CreateAtlasMarkup("warbands-icon") or ""
		GameTooltip_AddColoredDoubleLine(
			tooltip,
			(currency and format("|T%d:12|t %s", currency.iconFileID, currency.name) or LFG_LIST_LOADING) .. type,
			o.quantity,
			currency and C_ColorOverrides.GetColorForQuality(currency.quality) or WHITE_FONT_COLOR,
			WHITE_FONT_COLOR
		)
	end

	if self.money > 0 then
		tooltip:AddLine(GetMoneyString(math.floor(self.money / COPPER_PER_GOLD) * COPPER_PER_GOLD))
	end
end

namespace.RewardSummary = RewardSummary
