local _, ns = ...

local L = {}
ns.L = L

-- Binding
L["BINDING_NAME_WeeklyRewards"] = "Show/Hide the window of WeeklyRewards"

-- Minimap tooltip
L["minimap_tooltip_left_click"] = "|cff00ff00Left click|r to open WeeklyRewards."
L["minimap_tooltip_drag"] = "|cff00ff00Drag|r to move this icon"
L["minimap_tooltip_locked"] = " |cffff0000(locked)|r"

-- Window titlebar buttons
L["close_button_tooltip"] = "Close the window"
L["settings_button_tooltip"] = "Settings"
L["settings_button_description"] = "Customize the window"
L["characters_button_title"] = "Tracking Characters"
L["characters_button_description"] = "Enable/Disable your characters."
L["characters_button_remove_hint"] = "Press CTRL + |A:NPE_LeftClick:16:16|a to delete the character"
L["columns_button_tooltip"] = "Columns"
L["columns_button_description"] = "Enable/Disable Tracking Rewards."

-- Settings menu
L["settings_show_minimap_button"] = "Show Minimap Button"
L["settings_lock_minimap_button"] = "Lock Minimap Button"
L["settings_window_title"] = "Window"
L["settings_max_width"] = "Max Width"
L["settings_max_width_percent"] = "Percent of screen width"
L["settings_max_rows"] = "Max Rows"
L["settings_background_color"] = "Background Color"
L["settings_player_row_color"] = "Current Character Row Color"
L["settings_show_border"] = "Show Border"
L["settings_show_row_numbers"] = "Show Row Numbers"
L["settings_tutorials_tooltip"] = "Display tutorials which help introduce you to addon."
L["settings_auto_untrack_quests"] = "Untrack Quests on Login"
L["settings_auto_untrack_quests_tooltip"] = "Remove WeeklyRewards quests from the system Objective Tracker when you log in."
L["settings_broadcast_rewards"] = "Announce Claimed Rewards"
L["settings_broadcast_rewards_tooltip"] = "Post a Warband reward summary to the largest available chat channel when you claim a reward."

-- automation menu
L["automation_button_tooltip"] = "Automation & Tools"
L["automation_button_description"] = "Speed up farming and enhance quality of life for all characters."
L["automation_disable_hint"] = "Hold any modifier key (Ctrl/Shift/Alt) to temporarily disable the automation"
L["automation_reset_hint"] = "To avoid replacing the saved automation, hold a modifier key while selecting."
L["automation_auto_enter_title"] = "Auto Enter"
L["automation_auto_enter_tooltip"] = "Automatically enter Val and Naigtal at the selected difficulty."
L["automation_auto_flight_title"] = "Auto Flight"
L["automation_auto_flight_tooltip"] = "Remember the flight you choose at each portal bridge and flight master, and take it automatically next time on all characters."
L["automation_auto_flight_saved"] = "Flight from %s to |cff71d5ff%s|r saved. All your characters will take it automatically."
L["automation_fast_loot_title"] = "Fast Loot"
L["automation_fast_loot_tooltip"] = "Loot at maximum speed by removing the delay with the loot frame.|nWhen checked the Auto Loot will also be enabled on all characters."

-- Table columns
L["column_realm"] = "Realm"
L["column_covenant"] = "Covenant"
L["column_location"] = "Location"
L["column_last_update"] = "LastUpdate"

-- Covenant tooltips
L["covenant_sanctum_unknown"] = "Sanctum Upgrade status is unknown"
L["covenant_not_joined"] = "This character has not join any Covenant"

-- Table tooltips
L["table_sort_hint"] = "<Left Click to Sort>"
L["table_reset_progress_hint"] = "<Ctrl click to reset the progress>"
L["table_alts_collect_hint"] = "Log in on this character to collect it"

-- Tips
L["tips_scrollbar_vertical"] = "Drag or use the mouse wheel to scroll for more rows."
L["tips_scrollbar_horizontal"] = "Drag or use the mouse wheel to scroll for more columns.|n|nIf vertical scrolling is also active, hold a |cffffff00modifier|r key while using the mouse wheel."
L["tips_drag_to_reorder"] = "Drag the reward name to a new position to change its order."

-- Progress tooltips
L["progress_rewards_received_at"] = "Rewards Received At:"
L["progress_started_at"] = "Started At:"
L["progress_rewards_received"] = "Rewards Received"
L["progress_not_started"] = "<Not Started>"
L["progress_drops"] = "Drops"

-- Reward tooltips
L["reward_time_left"] = "Time Left: "
L["reward_objective_multi_quests_title"] = "Complete %d of the following quests:"
L["reward_repeat_one_time"] = "One-time Quests"

-- Candidate tooltips
L["candidate_from"] = "Rewards earned from |cffffffff%s|r"
L["candidate_from_following_1"] = "One of the following shared across your Warband:"
L["candidate_from_following_n"] = "%d of the following shared across your Warband:"
L["candidate_from_following_all"] = "All of the following:"
L["candidate_1_of_following_per_character"] = "One of the following per character:"
L["candidate_n_of_following_per_character"] = "Up to %d of the following per character:"
L["candidate_x_of_following_per_character"] = "Any of the following per character:"
L["candidate_not_active"] = "Reward is not active this week"

-- Summary
L["summary_completed_count"] = "%s completed %d times this week"
L["summary_progress"] = "Warband Progress:"
L["summary_rewards_received"] = "Total Rewards Received: "

-- Reward Descriptions
L["reward:tww-chett"] = "Weekly C.H.E.T.T. List"
L["reward:tww-incursion"] = "Daily incursions in Hallowfall or Azj-Kahet"
L["reward:tww-invasion"] = "Siren Isle Invasion Quests|n|nEnemies cycle every week through three types:|n|cffffff00Vrykul|r, |cffffff00Naga|r, and |cffffff00Pirate|r."
L["reward:tww-lfd"] = "Weekly Dungeon Quest"
L["reward:tww-pact"] = "Weekly Azj-Kahet Pact Choice"
L["reward:mn-pdrops"] = "Weekly Profession Knowledge from Treasures around the World"
L["reward:mn-pquests"] = "Weekly Profession Quests"
L["reward:mn-prey-n"] = "Weekly Prey targets on Normal difficulty from {npc:245824}."
L["reward:mn-prey-h"] = "Weekly Prey targets on Hard difficulty from {npc:245824}."
L["reward:mn-prey-m"] = "Weekly Prey targets on Nightmare difficulty from {npc:245824}."
L["reward:mn-prey-select"] = "Preferential Killing|n|cnLIGHTBLUE_FONT_COLOR:Unlocked after reaching Renown 10 in the Preyhunter's Journey.|r"
L["reward:brew"] = "Donate to taverns across {map:%s} to cover the tab!"
L["reward:df-artifacts"] = "Darkmoon Faire Artifacts"
L["reward:df-prof"] = "Darkmoon Faire Profession Quests"
L["reward:lf"] = "Visiting the Elders in {map:%s}"
L["reward:lf-capital"] = "Visiting the Elders in Faction Capitals"
L["reward:lf-dungeon"] = "Visiting the Elders in Dungeons"
L["reward:love-dono"] = "Donate gold to the Artisan's Consortium to support the Gala of Gifts.|n|nThe reward is delivered by mail several minutes after the donation."
L["reward:msf-capital"] = "Stealing Flame from Faction Capitals"
L["reward:noble-boss"] = "Daily Holiday Boss: Daetan Swiftplume.|n|nThe nest of this feathery fiend is located in both Elwynn Forest and Durotar."
L["reward:delve-abundance"] = "The first time you find Dundun in a delve each week, it becomes {spell:1297887}, and you receive these extra chests at the end:|n- 1 |cnEPIC_PURPLE_COLOR:Bountiful Coffer|r|n- 2 |cnRARE_BLUE_COLOR:Abundantly Bountiful Heavy Trunk|r"
L["reward:delve-fragment-m"] = "Earned from the 6-week {storyline:6385}. {item:285065:0}"
L["reward:bonus"] = "The Weekly Bonus Event provides a weekly quest that rewards equipment."
L["reward:vault"] = "Great Vault rewards provide 1 piece of loot from a pool of up to 9 items.|n|nThe item level depends on your highest runs of the week.|nYou can also select the {item:258556} instead of equipment (500|A:coin-gold:0:0|a for each token)."

