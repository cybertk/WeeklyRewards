local _, ns = ...

local L = {}
ns.L = L

-- Binding
L["BINDING_NAME_WeeklyRewards"] = "Show or hide the WeeklyRewards window"

-- Minimap tooltip
L["minimap_tooltip_left_click"] = "|cff00ff00Left-Click|r to open WeeklyRewards."
L["minimap_tooltip_drag"] = "|cff00ff00Drag|r to move this icon."
L["minimap_tooltip_locked"] = " |cffff0000(locked)|r"

-- Window titlebar buttons
L["settings_button_description"] = "Customize the window."
L["characters_button_title"] = "Tracked Characters"
L["characters_button_description"] = "Enable or disable your characters."
L["characters_button_remove_hint"] = "Ctrl-Click a character to remove it"
L["columns_button_tooltip"] = "Columns"
L["columns_button_description"] = "Enable or disable tracked rewards."

-- Settings menu
L["settings_show_minimap_button"] = "Show Minimap Button"
L["settings_lock_minimap_button"] = "Lock Minimap Button"
L["settings_window_title"] = "Window"
L["settings_column_layout"] = "Column Layout"
L["settings_max_width"] = "Max Width"
L["settings_max_width_percent"] = "Percent of screen width"
L["settings_max_rows"] = "Max Rows"
L["settings_background_color"] = "Background Color"
L["settings_player_row_color"] = "Current Character Row Color"
L["settings_show_border"] = "Show Border"
L["settings_show_row_numbers"] = "Show Row Numbers"
L["settings_tutorials_tooltip"] = "Display tutorials that introduce the addon."
L["settings_auto_untrack_quests"] = "Untrack Quests on Login"
L["settings_auto_untrack_quests_tooltip"] = "Remove WeeklyRewards quests from the objective tracker when you log in."
L["settings_broadcast_rewards"] = "Announce Claimed Rewards"
L["settings_broadcast_rewards_tooltip"] = "Post a Warband reward summary to the largest available chat channel when you claim a reward."

-- automation menu
L["automation_button_tooltip"] = "Automation & Tools"
L["automation_button_description"] = "Speed up farming and enhance quality of life for all characters."
L["automation_disable_hint"] = "Hold any modifier key (Ctrl/Shift/Alt) to temporarily disable the automation"
L["automation_reset_hint"] = "Hold a modifier key when selecting if you don’t want to replace your saved automation."
L["automation_auto_enter_title"] = "Auto Enter"
L["automation_auto_enter_tooltip"] = "Automatically enter Val and Naigtal at the selected difficulty."
L["automation_auto_flight_title"] = "Auto Flight"
L["automation_auto_flight_tooltip"] = "Remember the flight you choose at each portal bridge and flight master, and take it automatically next time on all characters."
L["automation_auto_flight_saved"] = "Flight from %s to |cff71d5ff%s|r saved. All of your characters will take it automatically next time."
L["automation_fast_loot_title"] = "Fast Loot"
L["automation_fast_loot_tooltip"] = "Loot at maximum speed by skipping the loot-frame delay.|nWhen checked, Auto Loot is also enabled on all characters."

-- Table columns
L["column_realm"] = "Realm"
L["column_covenant"] = "Covenant"

-- Covenant tooltips
L["covenant_sanctum_unknown"] = "This character's Sanctum upgrades are unknown."
L["covenant_not_joined"] = "This character has not joined a Covenant."

-- Table tooltips
L["table_sort_hint"] = "<Left-Click to sort>"
L["table_reset_progress_hint"] = "<Ctrl-Click to reset progress>"
L["table_alts_collect_hint"] = "Log in on this character to update its progress."

-- Tips
L["tips_scrollbar_vertical"] = "Drag or use the mouse wheel to scroll to see more rows."
L["tips_scrollbar_horizontal"] = "Drag or use the mouse wheel to scroll to see more columns.|n|nIf the window also scrolls vertically, hold a |cffffff00modifier|r key while using the mouse wheel."
L["tips_drag_to_reorder"] = "Drag a reward name to a new position to change its order."

-- Progress tooltips
L["progress_rewards_received_at"] = "Rewards received at:"
L["progress_started_at"] = "Started at:"
L["progress_rewards_received"] = "Rewards Received"
L["progress_not_started"] = "<Not Started>"
L["progress_drops"] = "Drops"

-- Reward tooltips
L["reward_objective_multi_quests_title"] = "Complete %d of the following quests:"

-- Candidate tooltips
L["candidate_from"] = "Rewards earned from |cffffffff%s|r"
L["candidate_from_following_1"] = "One of the following shared across your Warband:"
L["candidate_from_following_n"] = "%d of the following shared across your Warband:"
L["candidate_from_following_all"] = "All of the following:"
L["candidate_1_of_following_per_character"] = "One of the following per character:"
L["candidate_n_of_following_per_character"] = "Up to %d of the following per character:"
L["candidate_x_of_following_per_character"] = "Any of the following per character:"
L["candidate_not_active"] = "This reward is not active this week."

-- Summary
L["summary_completed_count"] = "%s completed %d times this week"
L["summary_progress"] = "Warband Progress:"
L["summary_rewards_received"] = "Total Rewards Received: "

-- Character tooltip
L["character_fully_rested"] = "Fully Rested"
L["character_time_to_fully_rested"] = "Time until fully rested: |cffffffff%s|r"
L["character_last_party"] = "Last Party:"

-- Reward descriptions. {map:%s} is filled from the reward id (brew:1978, lf:12).
L["reward:tww-chett"] = "Weekly C.H.E.T.T. List"
L["reward:tww-incursion"] = "Daily incursions in {map:2215} or {map:2255}"
L["reward:tww-invasion"] = "{map:2369} Invasion Quests|n|nEnemies cycle every week through three types:|n|cnYELLOW_FONT_COLOR:Vrykul|r, |cnYELLOW_FONT_COLOR:Naga|r, and |cnYELLOW_FONT_COLOR:Pirate|r."
L["reward:tww-lfd"] = "Weekly Dungeon Quest"
L["reward:tww-pact"] = "Weekly {map:2255} Pact Choice"
L["reward:mn-pdrops"] = "Weekly Profession Knowledge from treasures around the world."
L["reward:mn-pquests"] = "Weekly Profession Quests"
L["reward:mn-prey-n"] = "Weekly Prey targets on Normal difficulty from {npc:245824}."
L["reward:mn-prey-h"] = "Weekly Prey targets on Hard difficulty from {npc:245824}."
L["reward:mn-prey-m"] = "Weekly Prey targets on Nightmare difficulty from {npc:245824}."
L["reward:brew"] = "Donate to taverns across {map:%s} to cover the tab!"
L["reward:df-artifacts"] = "Darkmoon Faire Artifacts"
L["reward:df-prof"] = "Darkmoon Faire Profession Quests"
L["reward:lf"] = "Visiting the Elders in {map:%s}"
L["reward:lf-capital"] = "Visiting the Elders in |cffffff00Faction Capitals|r"
L["reward:lf-dungeon"] = "Visiting the Elders in |cffffff00Dungeons|r"
L["reward:love-dono"] = "Donate gold to the Artisan's Consortium to support the Gala of Gifts.|n|nThe reward is delivered by mail several minutes after the donation."
L["reward:msf-capital"] = "Stealing Flame from Faction Capitals"
L["reward:noble-boss"] = "Daily Holiday Boss: {npc:216295}.|n|nThe nest of this feathery fiend is located in both {map:37} and {map:1}."
L["reward:delve-abundance"] = "The first time you find {npc:242704} in a delve each week, it becomes {spell:1297887}, and you receive these extra chests at the end:|n- 1 |cnEPIC_PURPLE_COLOR:Bountiful Coffer|r|n- 2 |cnRARE_BLUE_COLOR:Abundantly Bountiful Heavy Trunk|r"
L["reward:delve-fragment-m"] = "Earned from the 6-week {storyline:6385}. {item:285065:0}"
L["reward:bonus"] = "The Weekly Bonus Event provides a weekly quest that rewards equipment."
L["reward:vault"] = "Great Vault Rewards provide 1 piece of loot from a pool of up to 9 items.|n|nThe item level depends on your highest runs of the week.|nYou can also select the {item:269862} instead of equipment (500|A:coin-gold:0:0|a for each token)."
