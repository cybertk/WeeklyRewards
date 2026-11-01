local _, ns = ...

local L = ns.L

local AutoFlight = CreateFromMixins(ns.EventHandlerMixin, { Events = {
	"TAXIMAP_OPENED",
	"TAXIMAP_CLOSED",
}, IsEventFiltered = IsModifierKeyDown })

local function FormatTaxiNodeLink(node, mapID)
	local mapID = mapID or GetTaxiMapID()
	local position = node.position

	if not mapID or not position then
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

function AutoFlight:TAXIMAP_OPENED(system)
	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(GetTaxiMapID())

	local currentNode
	for _, node in ipairs(taxiNodes) do
		if node.state == Enum.FlightPathState.Current then
			currentNode = node
			break
		end
	end

	if not currentNode or not self.db.taxiNodes[currentNode.nodeID] then
		return
	end

	local targetNodeID = self.db.taxiNodes[currentNode.nodeID]
	for _, node in ipairs(taxiNodes) do
		if node.nodeID == targetNodeID then
			self.nodeToTake = node
			C_Timer.After(0, self.TakeSavedFlightClosure)
			break
		end
	end
end

function AutoFlight:TAXIMAP_CLOSED()
	self.nodeToTake = nil
end

function AutoFlight:OnEnable()
	if not self.SaveTaxiNodeClosure then
		self.SaveTaxiNodeClosure = GenerateClosure(self.SaveTaxiNode, self)
		self.TakeSavedFlightClosure = GenerateClosure(self.TakeSavedFlight, self)

		hooksecurefunc("TakeTaxiNode", self.SaveTaxiNodeClosure)
	end
end

function AutoFlight:TakeSavedFlight()
	if not self.nodeToTake then
		return
	end

	self.isAutoTaking = true
	TakeTaxiNode(self.nodeToTake.slotIndex)
	self.isAutoTaking = false

	C_Timer.After(0.2, self.TakeSavedFlightClosure)
end

function AutoFlight:SaveTaxiNode(index)
	if not self.isEnabled or self.isAutoTaking or IsModifierKeyDown() then
		return
	end

	local currentNode, targetNode
	for _, node in ipairs(C_TaxiMap.GetAllTaxiNodes(GetTaxiMapID())) do
		if node.state == Enum.FlightPathState.Current then
			currentNode = node
		elseif node.slotIndex == index then
			targetNode = node
		end
	end

	if not currentNode or not targetNode then
		return
	end

	ns.message(L["automation_auto_flight_saved"]:format(FormatTaxiNodeLink(currentNode), FormatTaxiNodeLink(targetNode)))
	if self.db.taxiNodes[currentNode.nodeID] and self.db.taxiNodes[currentNode.nodeID] ~= targetNode.nodeID then
		ns.message(L["automation_reset_hint"])
	end

	self.db.taxiNodes[currentNode.nodeID] = targetNode.nodeID
end

ns.ModuleManager.RegisterModule("AutoFlight", AutoFlight, { taxiNodes = {} })
