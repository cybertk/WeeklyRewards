local _, ns = ...

local EntranceSelector =
	CreateFromMixins(ns.EventHandlerMixin, { Events = {
		"PLAYER_INTERACTION_MANAGER_FRAME_SHOW",
		"GOSSIP_SHOW",
	}, IsEventFiltered = IsModifierKeyDown })

EntranceSelector.WhitelistedMaps = tInvert({
	3047, -- Val
	3075, -- Naigtal
})

EntranceSelector.WhitelistedGossips = tInvert({
	140132, -- teleport to Silvermoon from Val/Naigtal
})

function EntranceSelector:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(type)
	if not DelvesDifficultyPickerFrame or type ~= Enum.PlayerInteractionType.TieredEntrance then
		return
	end

	if not self.WhitelistedMaps[C_DelvesUI.GetDelveEntranceMapID()] then
		return
	end

	DelvesDifficultyPickerFrame.EnterDelveButton:Click()
	DelvesDifficultyPickerFrame:Hide()
end

function EntranceSelector:GOSSIP_SHOW()
	for _, option in ipairs(C_GossipInfo.GetOptions()) do
		if self.WhitelistedGossips[option.gossipOptionID] then
			C_GossipInfo.SelectOption(option.gossipOptionID)
			break
		end
	end
end

ns.ModuleManager.RegisterModule("AutoEnter", EntranceSelector)

do -- AutoNav
	-- local AutoNav = CreateFrame("Frame")
	local AutoNav = CreateFromMixins(EventHandlerMixin, { Events = {
		"TAXIMAP_OPENED",
	}, IsEventFiltered = IsModifierKeyDown })

	function AutoNav:TAXIMAP_OPENED(system)
		Debug("TAXIMAP_OPENED", system, GetTaxiMapID())


		local taxiNodes = C_TaxiMap.GetAllTaxiNodes(GetTaxiMapID())

		local currentNode
		for _, node in ipairs(taxiNodes) do
			-- print(node.name, node.state, node.nodeID)
			if node.state == Enum.FlightPathState.Current then
				currentNode = node
				break
			end
		end

		if not currentNode or not self.db.taxiNodes[currentNode.nodeID] then
			-- print("ignore Taxi", currentNode and currentNode.name)
			return
		end

		local targetNodeID = self.db.taxiNodes[currentNode.nodeID]
		for _, node in ipairs(taxiNodes) do
			if node.nodeID == targetNodeID then TakeTaxiNode(node.slotIndex) end
		end
	end

	function AutoNav:OnEnable()
		if not self.SaveTaxiNodeClosure then
			self.SaveTaxiNodeClosure = GenerateClosure(self.SaveTaxiNode, self)
			
			hooksecurefunc("TakeTaxiNode", self.SaveTaxiNodeClosure)
		end
	end

	function AutoNav:SaveTaxiNode(index)
		-- print("SaveTaxiNode", index)

		local currentNode, targetNode
		for _, node in ipairs(C_TaxiMap.GetAllTaxiNodes(GetTaxiMapID())) do
			if node.state == Enum.FlightPathState.Current then
				currentNode = node
			elseif node.slotIndex == index then
				targetNode = node
			end
		end

		local mapID = GetTaxiMapID()

		if currentNode and targetNode and self.db.taxiNodes[currentNode.nodeID] ~= targetNode.nodeID then
			-- print("Saving", currentNode.name, targetNode.name)
			self.db.taxiNodes[currentNode.nodeID] = targetNode.nodeID

			local location = ("|Hworldmap:%d:%d:%d|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a%s]"):format(
				mapID,
				currentNode.position.x * 10000,
				currentNode.position.y * 10000,
				currentNode.name
			)
			local text = "The flight from |cff71d5ff%s|r to |cff71d5ff%s|r is saved. All your characters will fly automatically."
			message(text:format(location, targetNode.name))
		else
			print("Saving failed", currentNode or "unknown", targetNode)
		end
	end

	ns.ModuleManager.RegisterModule("AutoNav", AutoNav, { taxiNodes = {} })
end