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
L["settings_button_description"] = "Let's customize things a bit"
L["characters_button_title"] = "Tracking Characters"
L["characters_button_description"] = "Enable/Disable your characters."
L["characters_button_remove_hint"] = "Press CTRL + |A:NPE_LeftClick:16:16|a to delete the character"
L["columns_button_tooltip"] = "Columns"
L["columns_button_description"] = "Enable/Disable Tracking Rewards."
L["sort_button_tooltip"] = "Sort"
L["sort_button_description"] = "Select sorting options for Reward Columns."

-- Settings menu
L["settings_show_minimap_button"] = "Show the minimap button"
L["settings_show_minimap_tooltip"] = "It does get crowded around the minimap sometimes."
L["settings_lock_minimap_button"] = "Lock the minimap button"
L["settings_lock_minimap_tooltip"] = "No more moving the button around accidentally!"
L["settings_window_title"] = "Window"
L["settings_scaling"] = "Scaling"
L["settings_max_width"] = "Max Width"
L["settings_max_width_percent"] = "% of fullscreen"
L["settings_max_rows"] = "Max Number of Rows"
L["settings_background_color"] = "Background color"
L["settings_show_border"] = "Show the border"
L["settings_utility_title"] = "Utility"
L["settings_auto_untrack_quests"] = "Auto untrack quests"
L["settings_auto_untrack_quests_tooltip"] = "Untrack all WeeklyRewards-managed quests on login, which could provide a cleaner quest log panel"
L["settings_broadcast_rewards"] = "Broadcast rewards"
L["settings_broadcast_rewards_tooltip"] = "Broadcast your Warband rewards summary once claimed. The chat channel is automatically selected with the largest audience."

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
L["table_alts_collect_hint"] = "Log in with this character to collect it"

-- Progress tooltips
L["progress_rewards_received_at"] = "Rewards Received At:"
L["progress_started_at"] = "Started At:"
L["progress_rewards_received"] = "Rewards Received"
L["progress_not_started"] = "<Not Started>"
L["progress_drops"] = "Drops"

-- Reward tooltips
L["reward_rewards"] = "Rewards"
L["reward_time_left"] = "Time Left: "

-- Sorting options
L["sort_reward_group"] = "Reward Group"
L["sort_reward_name"] = "Reward Name"
L["sort_time_left"] = "Time Left"
