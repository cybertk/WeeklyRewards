local addonName, Addon = ...

local AtomicContainerLootScanner = Addon:NewModule("AtomicContainerLootScanner", {
	session = nil, -- Currennt active loot session
}, "AceEvent-3.0")

function AtomicContainerLootScanner:OnEnable()
	self:RegisterEvent("ITEM_LOCKED")
	self:RegisterEvent("ITEM_UNLOCKED")
	self:RegisterEvent("SHOW_LOOT_TOAST")
	self:RegisterEvent("LOOT_CLOSED")
end

function AtomicContainerLootScanner:ITEM_LOCKED(event, containerIndex, slotIndex)
	self:Debug("ITEM_LOCKED", containerIndex, slotIndex)
	self:Start(containerIndex, slotIndex)
end

function AtomicContainerLootScanner:ITEM_UNLOCKED()
	self:Debug("ITEM_UNLOCKED")
	self:Stop()
end

function AtomicContainerLootScanner:SHOW_LOOT_TOAST(event, ...)
	self:Debug("SHOW_LOOT_TOAST", ...)
	self:UpdateLoot(...)
end

function AtomicContainerLootScanner:LOOT_CLOSED()
	self:Debug("LOOT_CLOSED")
	self:Stop()
end

function AtomicContainerLootScanner:Debug(...)
	if type(Addon.debug) == "function" then
		return Addon.debug(...)
	end

	if Addon.debug == true then
		print(...)
	end
end

function AtomicContainerLootScanner:Start(containerIndex, slotIndex)
	if containerIndex == nil or slotIndex == nil then
		return
	end

	local containerItemInfo = C_Container.GetContainerItemInfo(containerIndex, slotIndex)
	if containerItemInfo == nil or not containerItemInfo.hasLoot then
		return
	end

	self.session = Item:CreateFromBagAndSlot(containerIndex, slotIndex):GetItemGUID()

	self:Debug("<<<<< Container Loot Session Start", self.session)
end

function AtomicContainerLootScanner:Stop()
	self:Debug("<<<<< Container Loot Session Stop")

	self.session = nil
end

function AtomicContainerLootScanner:UpdateLoot(typeIdentifier, itemLink, quantity, specID, sex, isPersonal, toastMethod, lessAwesome, upgraded, corrupted)
	if self.session == nil or toastMethod ~= 3 then
		self:Debug("no active container loot session", toastMethod)
		return
	end

	local item = { source = self.session, quantity = quantity }
	if typeIdentifier == "item" then
		item.item = select(1, C_Item.GetItemInfoInstant(itemLink))
	elseif typeIdentifier == "currency" then
		item.currency = C_CurrencyInfo.GetCurrencyInfoFromLink(itemLink).currencyID
	elseif typeIdentifier == "money" then
		item.currency = 0
	end

	self:Debug(RED_FONT_COLOR:WrapTextInColorCode("=== LOOTED:"), item.source, itemLink, item.quantity, item.item, item.currency)

	self:SendMessage("WR_LOOT_SCANNER_ITEM_LOOTED", item.source, item.quantity, item.item, item.currency)
end
