local _, ns = ...

local L = ns.L

local function FormatNodeLink(mapID, node)
	local position = node.position
	if not mapID or not position or not position.x or not position.y then
		return format("|cff71d5ff%s|r", node.name)
	end

	return format(
		"|cff71d5ff|Hworldmap:%d:%d:%d|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a%s]|h|r",
		mapID,
		math.floor(position.x * 10000 + 0.5),
		math.floor(position.y * 10000 + 0.5),
		node.name
	)
end

local AutoFlight = CreateFromMixins(ns.EventHandlerMixin, {
	Events = {
		"TAXIMAP_OPENED",
		"TAXIMAP_CLOSED",
	},
})

function AutoFlight:OnEnable()
	if not self.SaveTaxiNodeClosure then
		self.SaveTaxiNodeClosure = GenerateClosure(self.SaveTaxiNode, self)
		hooksecurefunc("TakeTaxiNode", self.SaveTaxiNodeClosure)
	end
end

function AutoFlight:HasRoutes()
	return self.db and self.db.taxiNodes and next(self.db.taxiNodes) ~= nil
end

function AutoFlight:ClearRoutes()
	if self.db and self.db.taxiNodes then
		wipe(self.db.taxiNodes)
	end
end

function AutoFlight:UpdateCache()
	local mapID = GetTaxiMapID()
	if not mapID or mapID == 0 then
		return false
	end

	local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes, mapID)
	if not ok or not nodes or #nodes == 0 then
		return false
	end

	local cache = { mapID = mapID, bySlot = {}, byID = {} }
	for _, node in ipairs(nodes) do
		if node.slotIndex then
			cache.bySlot[node.slotIndex] = node
		end
		if node.nodeID then
			cache.byID[node.nodeID] = node
		end
		if node.state == Enum.FlightPathState.Current then
			cache.currentNode = node
		end
	end

	if not cache.currentNode then
		return false
	end

	self.cache = cache
	return true
end

function AutoFlight:TAXIMAP_OPENED()
	if self:UpdateCache() then
		self:TakeSavedFlight()
		return
	end

	RunNextFrame(function()
		if self.isEnabled and self:UpdateCache() then
			self:TakeSavedFlight()
		end
	end)
end

function AutoFlight:TAXIMAP_CLOSED()
	local cache = self.cache
	RunNextFrame(function()
		if self.cache == cache then
			self.cache = nil
		end
	end)
end

function AutoFlight:TakeSavedFlight()
	local cache = self.cache
	local currentNode = cache and cache.currentNode
	if self.isAutoTaking or IsModifierKeyDown() or not currentNode or not currentNode.nodeID or not self.db or not self.db.taxiNodes then
		return
	end

	local targetNodeID = self.db.taxiNodes[currentNode.nodeID]
	local targetNode = targetNodeID and cache.byID[targetNodeID]
	if not targetNode or targetNode.state ~= Enum.FlightPathState.Reachable or not targetNode.slotIndex or targetNode.slotIndex < 1 then
		return
	end

	if TaxiNodeCost then
		local cost = TaxiNodeCost(targetNode.slotIndex)
		if cost and cost > GetMoney() then
			ns.debug("AutoFlight skipped, not enough money", currentNode.name, targetNode.name, cost)
			return
		end
	end

	ns.debug("AutoFlight take", currentNode.name, targetNode.name)
	self.isAutoTaking = true
	local ok, err = pcall(TakeTaxiNode, targetNode.slotIndex)
	self.isAutoTaking = false
	if not ok then
		geterrorhandler()(err)
	end
end

function AutoFlight:SaveTaxiNode(slotIndex)
	if not slotIndex or self.isAutoTaking or not self.isEnabled or not self.db or not self.db.taxiNodes then
		return
	end

	local cache = self.cache
	local currentNode = cache and cache.currentNode
	local targetNode = cache and cache.bySlot[slotIndex]
	local mapID = cache and cache.mapID

	if not currentNode or not targetNode then
		mapID = GetTaxiMapID()
		if not mapID or mapID == 0 then
			return
		end

		local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes, mapID)
		if not ok or not nodes then
			return
		end

		for _, node in ipairs(nodes) do
			if node.state == Enum.FlightPathState.Current then
				currentNode = node
			elseif node.slotIndex == slotIndex then
				targetNode = node
			end
		end
	end

	if not currentNode or not targetNode or not currentNode.nodeID or not targetNode.nodeID or currentNode.nodeID == targetNode.nodeID then
		return
	end

	if targetNode.state ~= Enum.FlightPathState.Reachable then
		return
	end

	if self.db.taxiNodes[currentNode.nodeID] == targetNode.nodeID then
		return
	end

	self.db.taxiNodes[currentNode.nodeID] = targetNode.nodeID
	ns.debug("AutoFlight saved", currentNode.name, targetNode.name)
	print(format(L["automation_auto_flight_saved"], FormatNodeLink(mapID, currentNode), targetNode.name))
end

ns.ModuleManager.RegisterModule("AutoFlight", AutoFlight, { taxiNodes = {} })
