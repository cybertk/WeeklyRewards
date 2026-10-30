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
