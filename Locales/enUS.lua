local _, ns = ...

local L = {}
ns.L = L

-- Binding
L["BINDING_NAME_WeeklyRewards"] = "Show or hide the WeeklyRewards window"

-- Minimap tooltip
L["minimap_tooltip_left_click"] = "|cff00ff00Left-click|r to open WeeklyRewards."
L["minimap_tooltip_drag"] = "|cff00ff00Drag|r to move this icon."
L["minimap_tooltip_locked"] = " |cffff0000(locked)|r"

-- Window titlebar buttons
L["settings_button_description"] = "Customize the window"
L["characters_button_title"] = "Tracked Characters"
L["characters_button_description"] = "Enable or disable your characters."
L["characters_button_remove_hint"] = "Press CTRL + |A:NPE_LeftClick:16:16|a to delete the character"
L["columns_button_tooltip"] = "Columns"
L["columns_button_description"] = "Enable or disable tracked rewards."

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
L["settings_tutorials_tooltip"] = "Display tutorials that introduce the addon."
L["settings_auto_untrack_quests"] = "Untrack Quests on Login"
L["settings_auto_untrack_quests_tooltip"] = "Remove WeeklyRewards quests from the objective tracker when you log in."
L["settings_broadcast_rewards"] = "Announce Claimed Rewards"
L["settings_broadcast_rewards_tooltip"] = "Post a Warband reward summary to the largest available chat channel when you claim a reward."

-- automation menu
L["automation_button_tooltip"] = "Automation & Tools"
L["automation_button_description"] = "Speed up farming and improve quality of life for every character."
L["automation_disable_hint"] = "Hold a modifier key (Ctrl, Shift, or Alt) to temporarily disable automation."
L["automation_auto_enter_title"] = "Auto Enter"
L["automation_auto_enter_tooltip"] = "Automatically enter {map:3047} and {map:3075} at the selected difficulty."

-- Table columns
L["column_covenant"] = "Covenant"
L["column_location"] = "Location"
L["column_last_update"] = "Last Update"

-- Covenant tooltips
L["covenant_sanctum_unknown"] = "Sanctum upgrade status is unknown."
L["covenant_not_joined"] = "This character has not joined a Covenant."

-- Table tooltips
L["table_sort_hint"] = "<Left-click to sort>"
L["table_reset_progress_hint"] = "<Ctrl-click to reset progress>"
L["table_alts_collect_hint"] = "Log in with this character to collect it."

-- Tips
L["tips_scrollbar_vertical"] = "Drag or use the mouse wheel to scroll for more rows."
L["tips_scrollbar_horizontal"] = "Drag or use the mouse wheel to scroll for more columns.|n|n"
	.. "If vertical scrolling is also active, hold a |cffffff00modifier|r key while using the mouse wheel."
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
L["candidate_from_following_quests"] = "%s earned from one of the following quests:"
L["candidate_from_quest_format"] = "Rewards from {quest:%d}"
L["candidate_one_of_following_quests"] = "Each character may select one of the following quests independently:"
L["candidate_from_quest"] = "Rewards from quest"
L["candidate_not_active"] = "Reward is not active this week"

-- Summary
L["summary_completed_count"] = "%s completed %d times this week"
L["summary_progress"] = "Warband Progress:"
L["summary_rewards_received"] = "Total rewards received: "

-- Character tooltip
L["character_fully_rested"] = "Fully Rested"
L["character_time_to_fully_rested"] = "Time until fully rested: |cffffffff%s|r"
L["character_last_party"] = "Last Party:"

-- Shared fragments used by reward data
L["week_count"] = "Week %d"
L["df_profession_knowledge"] = "Profession Knowledge Points"
L["love_bundle_500"] = "|cff1eff00[Bundle of Love Tokens]|r for offering 500 gold, contains 3-5 |T135453:12|t |cffffffff[Love Token]|r"
L["love_bundle_10000"] = "|cff0070dd[Bundle of Love Tokens]|r for offering 10,000 gold, contains 10-15 |T135453:12|t |cffffffff[Love Token]|r"
