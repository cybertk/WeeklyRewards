if GetLocale() ~= "zhCN" then
	return
end

local _, ns = ...
local L = ns.L

-- Binding
L["BINDING_NAME_WeeklyRewards"] = "显示/隐藏窗口"

-- Minimap tooltip
L["minimap_tooltip_left_click"] = "|cff00ff00左键点击|r打开WeeklyRewards。"
L["minimap_tooltip_drag"] = "|cff00ff00拖拽|r移动此图标"
L["minimap_tooltip_locked"] = " |cffff0000(已锁定)|r"

-- Window titlebar buttons
L["close_button_tooltip"] = "关闭窗口"
L["settings_button_tooltip"] = "设置"
L["settings_button_description"] = "让我们自定义一些设置"
L["characters_button_tooltip"] = "角色"
L["characters_button_description"] = "启用/禁用你的角色。"
L["characters_button_remove_hint"] = "<Ctrl点击删除角色>"
L["columns_button_tooltip"] = "列"
L["columns_button_description"] = "启用/禁用追踪奖励。"
L["sort_button_tooltip"] = "排序"
L["sort_button_description"] = "选择奖励列的排序选项。"

-- Settings menu
L["settings_show_minimap_button"] = "显示小地图按钮"
L["settings_show_minimap_tooltip"] = "小地图周围有时会很拥挤。"
L["settings_lock_minimap_button"] = "锁定小地图按钮"
L["settings_lock_minimap_tooltip"] = "不再意外移动按钮！"
L["settings_window_title"] = "窗口"
L["settings_scaling"] = "缩放"
L["settings_max_width"] = "最大宽度"
L["settings_max_width_percent"] = "% 全屏"
L["settings_background_color"] = "背景颜色"
L["settings_show_border"] = "显示边框"
L["settings_utility_title"] = "实用工具"
L["settings_auto_untrack_quests"] = "自动取消追踪任务"
L["settings_auto_untrack_quests_tooltip"] = "登录时取消追踪所有WeeklyRewards管理的任务，这可以提供更清洁的任务日志面板"
L["settings_broadcast_rewards"] = "广播奖励"
L["settings_broadcast_rewards_tooltip"] = "获得奖励后广播你的战团奖励摘要。聊天频道会自动选择观众最多的频道。"

-- Table columns
L["column_name"] = "姓名"
L["column_realm"] = "服务器"
L["column_level"] = "等级"
L["column_faction"] = "阵营"
L["column_location"] = "位置"
L["column_last_update"] = "最后更新"

-- Table tooltips
L["table_sort_hint"] = "<左键点击排序>"
L["table_reset_progress_hint"] = "<Ctrl点击重置进度>"

-- Progress tooltips
L["progress_rewards_received_at"] = "奖励获得时间："
L["progress_started_at"] = "开始时间："
L["progress_rewards_received"] = "已获得奖励"
L["progress_not_started"] = "<未开始>"
L["progress_drops"] = "掉落"

-- Reward tooltips
L["reward_sort_hint"] = "|A:NPE_LeftClick:16:16|a(排序)"
L["reward_rewards"] = "奖励"
L["reward_loading"] = "加载中"
L["reward_time_left"] = "剩余时间："

-- Sorting options
L["sort_reward_group"] = "奖励组"
L["sort_reward_name"] = "奖励名称"
L["sort_time_left"] = "剩余时间"
