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
L["settings_button_description"] = "Customize the window and automations"
L["characters_button_title"] = "Tracking Characters"
L["characters_button_description"] = "Enable/Disable your characters."
L["characters_button_remove_hint"] = "Press CTRL + |A:NPE_LeftClick:16:16|a to delete the character"
L["columns_button_tooltip"] = "Columns"
L["columns_button_description"] = "Enable/Disable Tracking Rewards."
L["sort_button_tooltip"] = "Sort"
L["sort_button_description"] = "Select sorting options for Reward Columns."

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
L["settings_utility_title"] = "Automation"
L["settings_auto_untrack_quests"] = "Untrack Quests on Login"
L["settings_auto_untrack_quests_tooltip"] = "Remove WeeklyRewards quests from the system Objective Tracker when you log in."
L["settings_broadcast_rewards"] = "Announce Claimed Rewards"
L["settings_broadcast_rewards_tooltip"] = "Post a Warband reward summary to the largest available chat channel when you claim a reward."

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

-- Progress tooltips
L["progress_rewards_received_at"] = "Rewards Received At:"
L["progress_started_at"] = "Started At:"
L["progress_rewards_received"] = "Rewards Received"
L["progress_not_started"] = "<Not Started>"
L["progress_drops"] = "Drops"

-- Reward tooltips
L["reward_time_left"] = "Time Left: "
L["reward_objective_multi_quests_title"] = "Complete %d of the following quests:"

-- Candidate tooltips
L["candidate_from_following_quests"] = "Rewards from one of the following quests:"
L["candidate_from_quest_format"] = "Rewards from {quest:%d}"
L["candidate_one_of_following_quests"] = "Each character may select one of the following quests independently:"
L["candidate_from_quest"] = "Rewards from quest"
L["candidate_not_active"] = "Reward is not active this week"

-- Summary
L["summary_completed_count"] = "%s completed %d times this week"
L["summary_progress"] = "Warband Progress:"
L["summary_rewards_received"] = "Total Rewards Received: "

-- Sorting options
L["sort_reward_group"] = "Reward Group"
L["sort_reward_name"] = "Reward Name"
L["sort_time_left"] = "Time Left"
