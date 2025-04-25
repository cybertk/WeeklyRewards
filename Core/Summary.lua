local _, namespace = ...

local Util = namespace.Util

local RewardSummary = {}

RewardSummary.__index = RewardSummary

function RewardSummary:Init(store)
	self.charactersStore = store
end

_G.RewardSummary = RewardSummary

function RewardSummary:D()
	RewardSummary:Init(namespace.CharacterStore.Get())
	-- local s = RewardSummary:Create("tww-sa:82852")
	-- s:Broadcast()

	RewardSummary:Create("tww-nightfall"):Broadcast()
	-- self:Broadcast()
end

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
			end

			if aggregated[o.item] == nil then
				aggregated[o.item] = { item = o.item, quantity = 0 }
				table.insert(self.items, o.item)
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

		o.name = progress:ObjectivesCount() == 1 and Util:GetQuestLink(progress:Quest()) or format("<%s>", progress.name)

		local x = "x"
		if progress:ObjectivesCount() == 1 then
			-- GetQuestLink(91173)  C_QuestLog.GetTitleForQuestID(91173)
			x = GetQuestLink(progress:Quest())
		end

		print(
			" name",
			x,
			o.name,
			progress:ObjectivesCount() == 1,
			progress:ObjectivesCount() == 1 and GetQuestLink(progress:Quest()) or format("<%s>", progress.name)
		)
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
			table.insert(messages, format("%s x%d", C_CurrencyInfo.GetCurrencyLink(o.currency), o.quantity))
		end
	end

	local header = format("本周%s已完成%d次", self.name, self.count)
	do
		local r = {}

		table.insert(r, #self.gears > 0 and format("装备%d件", #self.gears) or nil)
		table.insert(r, self.money >= COPPER_PER_GOLD and format("%d金", math.floor(self.money / COPPER_PER_GOLD)) or nil)
		table.insert(r, #messages > 0 and "战团货币: " or nil)

		if #r > 0 then
			header = header .. ", 累计获取" .. r[1]
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

namespace.RewardSummary = RewardSummary
