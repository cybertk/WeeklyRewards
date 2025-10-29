local _, ns = ...

local SelectableLootScanner = CreateFrame("Frame")

function SelectableLootScanner:OnEvent(...)
	local event = select(1, ...)

	if self[event] ~= nil then
		self[event](self, ...)
	end
end

function SelectableLootScanner:OnEnable()
	self:RegisterEvent("LOOT_READY")
	self:RegisterEvent("LOOT_OPENED")
	self:RegisterEvent("LOOT_SLOT_CHANGED")
	self:RegisterEvent("LOOT_SLOT_CLEARED")
	self:RegisterEvent("LOOT_CLOSED")

	self:SetScript("OnEvent", self.OnEvent)
end

function SelectableLootScanner:LOOT_READY()
	self:Debug("LOOT_READY")
	self:Start()
end

function SelectableLootScanner:LOOT_OPENED()
	self:Debug("LOOT_OPENED")
	self:Start()
end

function SelectableLootScanner:LOOT_SLOT_CHANGED(event, slot)
	self:Debug("LOOT_SLOT_CHANGED", slot)
	self:UpdateSlot(slot)
end

function SelectableLootScanner:LOOT_SLOT_CLEARED(event, slot)
	self:Debug("LOOT_SLOT_CLEARED", slot)
	self:UpdateSlot(slot)
end

function SelectableLootScanner:LOOT_CLOSED()
	self:Debug("LOOT_CLOSED")
	self:Stop()
end

function SelectableLootScanner:Debug(...)
	if type(ns.debug) == "function" and ns.verbose then
		return ns.debug(...)
	end

	if ns.debug == true then
		print(...)
	end
end

function SelectableLootScanner:Dump()
	self:Debug(RED_FONT_COLOR:WrapTextInColorCode("LOOT SESSION DUMP"))
	if self.session == nil or _G["WR_DEBUG"] ~= true then
		return
	end
	for slot, sources in pairs(self.session) do
		local count = 0
		for guid, item in pairs(sources) do
			count = count + 1
		end

		self:Debug(format("=== SLOT %d: %d sources", slot, count))

		for guid, item in pairs(sources) do
			self:Debug(format("%s: %s x %d", guid, item.link or "unknown", item.quantity))
		end
	end
end

function SelectableLootScanner:Start()
	if self.session then
		return
	end

	self.session = {}
	self:Debug("<<<<< Loot Session Start")

	for slot = 1, GetNumLootItems() do
		local texture, itemName, quantity, currencyID, quality, locked, isQuestItem, questID, isActive, isCoin = GetLootSlotInfo(slot)

		self:Debug("Slot infoinfo", texture, itemName, quantity, currencyID, quality, locked, isQuestItem, questID, isActive, isCoin)
		local itemLink = GetLootSlotLink(slot)
		local itemID = itemLink and select(1, C_Item.GetItemInfoInstant(itemLink)) or nil
		local slotType = GetLootSlotType(slot)
		local sources = { GetLootSourceInfo(slot) }

		local uniqueSources = {}

		for i = 1, #sources, 2 do
			uniqueSources[sources[i]] = { link = itemLink or format("%d coin?", quantity), quantity = sources[i + 1] }

			if slotType == Enum.LootSlotType.Currency then
				uniqueSources[sources[i]].currency = currencyID
			elseif slotType == Enum.LootSlotType.Item then
				uniqueSources[sources[i]].item = itemID
			elseif slotType == Enum.LootSlotType.Money then
				uniqueSources[sources[i]].currency = 0
			end
		end

		table.insert(self.session, uniqueSources)
	end

	if #self.session == 0 then -- There is empty loot sometimes, not sure a bug of wow
		print(RED_FONT_COLOR:WrapTextInColorCode("Failed to init loot cache, reset"))
		self.session = nil
	end

	self:Dump()
end

function SelectableLootScanner:Stop()
	if self.session == nil then
		return
	end

	self:Debug("<<<<< Loot Session Stop", GetNumLootItems())

	if GetNumLootItems() > 0 then
		for slot, _ in pairs(self.session) do
			self:Debug("Update remaining slot", slot)
			self:UpdateSlot(slot)
		end
	end

	self.session = nil
end

function SelectableLootScanner:UpdateSlot(slot)
	if self.session == nil or self.session[slot] == nil then -- self.session[slot] is nil sometimes due to unkown reason
		self:Debug("no active loot session", slot)
		return
	end

	local remainingSources = {}

	local sources = { GetLootSourceInfo(slot) }
	for i = 1, #sources, 2 do
		local guid = sources[i]
		remainingSources[guid] = true
	end

	local itemBySource = self.session[slot]
	local lootedItems = {}

	for guid, item in pairs(itemBySource) do
		if remainingSources[guid] == nil then
			item.source = guid
			table.insert(lootedItems, item)

			itemBySource[guid] = nil
		end
	end

	-- Remove empty slot
	if next(itemBySource) == nil then
		self.session[slot] = nil
	end

	for _, item in ipairs(lootedItems) do
		self:Debug(
			RED_FONT_COLOR:WrapTextInColorCode(format("=== LOOTED<%d-%d>:", slot, #sources / 2)),
			item.source,
			item.link,
			item.quantity,
			item.item,
			item.currency
		)
		EventRegistry:TriggerEvent("CK_LOOT_SCANNER_ITEM_LOOTED", item.source, item.quantity, item.item, item.currency)
	end
end

if _G["SelectableLootScanner"] == nil then
	_G["SelectableLootScanner"] = SelectableLootScanner
	SelectableLootScanner:OnEnable()
end
