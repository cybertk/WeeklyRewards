local _, namespace = ...

local NewItemsWatcher = CreateFrame("Frame")

NewItemsWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")

NewItemsWatcher:SetScript("OnEvent", function(self, event, ...)
	print(event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:Init()
	elseif event == "BAG_UPDATE_DELAYED" then
		self:CatchNewItems()
	elseif event == "ITEM_PUSH" then
		local bagSlot = ...

		if bagSlot == 0 then
			self.containerIndex = 0
		elseif bagSlot >= 31 and bagSlot <= 34 then
			self.containerIndex = bagSlot - 30
		end
	elseif event == "BAG_NEW_ITEMS_UPDATED" then
		self.hasNewItems = true
	end
end)

function NewItemsWatcher:Init()
	if self.seen then
		return
	end

	self.seen = {}
	self.watching = {}

	for containerIndex = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		for slotIndex = 1, C_Container.GetContainerNumSlots(containerIndex) do
			if C_NewItems.IsNewItem(containerIndex, slotIndex) then
				self.seen[C_Item.GetItemGUID(ItemLocation:CreateFromBagAndSlot(containerIndex, slotIndex))] = true
			end
		end
	end
end

function NewItemsWatcher:Start()
	self:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
	self:RegisterEvent("BAG_UPDATE_DELAYED")
	self:RegisterEvent("ITEM_PUSH")
end

function NewItemsWatcher:Stop()
	self:UnregisterEvent("BAG_NEW_ITEMS_UPDATED")
	self:UnregisterEvent("BAG_UPDATE_DELAYED")
	self:UnregisterEvent("ITEM_PUSH")
end

function NewItemsWatcher:CatchNewItems()
	print("CatchNewItems", #self.watching, self.hasNewItems, self.containerIndex)
	if #self.watching == 0 then
		self:Stop()
		return
	end

	if not self.hasNewItems or not self.containerIndex then
		return
	end

	for slotIndex = 1, C_Container.GetContainerNumSlots(self.containerIndex) do
		if C_NewItems.IsNewItem(self.containerIndex, slotIndex) then
			local itemLocation = ItemLocation:CreateFromBagAndSlot(self.containerIndex, slotIndex)
			local guid = C_Item.GetItemGUID(itemLocation)

			if guid and not self.seen[guid] then
				self.seen[guid] = true
				self.hasNewItems = false
				self:Notify(itemLocation)
			end
		end
	end
end

function NewItemsWatcher:Watch(item)
	if #self.watching == 0 then
		self:Start()
	end

	table.insert(self.watching, 1, item)
	print("Watching", item:GetItemLink(), #self.watching)
end

function NewItemsWatcher:Notify(itemLocation)
	local itemID = C_Item.GetItemID(itemLocation)

	for i = #self.watching, 1, -1 do
		local item = self.watching[i]

		if item:GetItemID() == itemID then
			item:SetItemLocation(itemLocation)
			item:FirePushedCallbacks()

			table.remove(self.watching, i)

			print("Removed", itemID, item:GetItemLink(), #self.watching)
			return
		end
	end
end

local NewItemMixin = {}

function NewItemMixin:ContinueOnItemPushed(callback)
	self.callback = callback
	NewItemsWatcher:Watch(self)
end

function NewItemMixin:HasLoot()
	local itemLocation = self:GetItemLocation()
	if not itemLocation or not itemLocation:IsBagAndSlot() then
		return
	end

	return C_Container.GetContainerItemInfo(itemLocation:GetBagAndSlot()).hasLoot
end

function NewItemMixin:FirePushedCallbacks()
	if not self.callback then
		return
	end

	self.callback(self)
	self.callback = nil
end

local NewItem = {}

function NewItem:CreateFromItemID(itemID)
	local item = CreateFromMixins(ItemMixin, NewItemMixin)
	item:SetItemID(itemID)

	return item
end

namespace.NewItem = NewItem
