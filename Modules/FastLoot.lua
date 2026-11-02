local _, ns = ...

local FastLoot = CreateFromMixins(ns.EventHandlerMixin, {
	Events = {
		"LOOT_READY",
		"LOOT_CLOSED",
		"LOOT_SLOT_CHANGED",
		"LOOT_SLOT_CLEARED",
	},
	SlotsCache = {},
})

function FastLoot:LOOT_READY(isAutoLoot)
	if isAutoLoot then
		self:Go()
	end
end

function FastLoot:LOOT_CLOSED()
	self.slots = nil

	if self.retryTimer then
		self.retryTimer:Cancel()
		self.retryTimer = nil
	end
end

function FastLoot:LOOT_SLOT_CHANGED(lootSlot)
	self:SetSlotLooted(lootSlot, false)
end

function FastLoot:LOOT_SLOT_CLEARED(lootSlot)
	self:SetSlotLooted(lootSlot, true)
end

function FastLoot:OnEnable()
	self.Retry = GenerateClosure(self.Go, self)
	C_CVar.SetCVar("autoLootDefault", "1")
end

function FastLoot:Go()
	if not self.slots then
		self.slots = self.SlotsCache
		wipe(self.slots)
	end

	local numItems = GetNumLootItems()
	for slot = 1, numItems do
		if LootSlotHasItem(slot) then
			if not self.slots[slot] then
				self.slots[slot] = true
				LootSlot(slot)
			end
		end
	end
end

function FastLoot:SetSlotLooted(slot, looted)
	if self.slots then
		self.slots[slot] = looted
		if not looted then
			self:RetryAfterDelay(0.4)
		end
	end
end

function FastLoot:RetryAfterDelay(seconds)
	if self.retryTimer then
		return
	end

	self.retryTimer = C_Timer.NewTicker(seconds, self.Retry)
end

ns.ModuleManager.RegisterModule("FastLoot", FastLoot)
