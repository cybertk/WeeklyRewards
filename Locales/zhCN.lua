if GetLocale() ~= "zhCN" then
	return
end

local _, ns = ...
local L = ns.L

-- Binding
L["BINDING_NAME_WeeklyRewards"] = "显示或隐藏 WeeklyRewards 窗口"

-- Minimap tooltip
L["minimap_tooltip_left_click"] = "|cff00ff00左键点击|r打开 WeeklyRewards。"
L["minimap_tooltip_drag"] = "|cff00ff00拖动|r以移动此图标。"
L["minimap_tooltip_locked"] = " |cffff0000（已锁定）|r"

-- Window titlebar buttons
L["settings_button_description"] = "自定义窗口"
L["characters_button_title"] = "已追踪角色"
L["characters_button_description"] = "启用或禁用你的角色。"
L["characters_button_remove_hint"] = "按住 CTRL + |A:NPE_LeftClick:16:16|a 删除该角色"
L["columns_button_tooltip"] = "列"
L["columns_button_description"] = "启用或禁用已追踪的奖励。"

-- Settings menu
L["settings_show_minimap_button"] = "显示小地图按钮"
L["settings_lock_minimap_button"] = "锁定小地图按钮"
L["settings_window_title"] = "窗口"
L["settings_max_width"] = "最大宽度"
L["settings_max_width_percent"] = "屏幕宽度百分比"
L["settings_max_rows"] = "最大行数"
L["settings_background_color"] = "背景颜色"
L["settings_player_row_color"] = "当前角色行颜色"
L["settings_show_border"] = "显示边框"
L["settings_show_row_numbers"] = "显示行号"
L["settings_tutorials_tooltip"] = "显示引导你了解插件的教程。"
L["settings_auto_untrack_quests"] = "登录时取消追踪任务"
L["settings_auto_untrack_quests_tooltip"] = "登录时从目标追踪中移除 WeeklyRewards 的任务。"
L["settings_broadcast_rewards"] = "通报已领取的奖励"
L["settings_broadcast_rewards_tooltip"] = "领取奖励时，向人数最多的可用聊天频道发送战团奖励摘要。"

-- automation menu
L["automation_button_tooltip"] = "自动化与工具"
L["automation_button_description"] = "加快所有角色的日常收集，并改善游戏体验。"
L["automation_disable_hint"] = "按住任意修饰键（Ctrl、Shift 或 Alt）可暂时停用自动化。"
L["automation_reset_hint"] = "选择时按住修饰键，以免覆盖已保存的自动化设置。"
L["automation_auto_enter_title"] = "自动进入"
L["automation_auto_enter_tooltip"] = "按所选难度自动进入瓦尔和奈格塔尔。"
L["automation_auto_flight_title"] = "自动飞行"
L["automation_auto_flight_tooltip"] = "记住你在每个传送桥和飞行管理员处选择的航线，下次所有角色都会自动搭乘。"
L["automation_auto_flight_saved"] = "已保存从%s飞往|cff71d5ff%s|r的航线。你的所有角色都会自动搭乘。"
L["automation_fast_loot_title"] = "快速拾取"
L["automation_fast_loot_tooltip"] = "移除拾取框的延迟，以最快速度拾取。|n勾选后，所有角色也会启用自动拾取。"

-- Table columns
L["column_realm"] = "服务器"
L["column_covenant"] = "盟约"
L["column_location"] = "位置"
L["column_last_update"] = "最近更新"

-- Covenant tooltips
L["covenant_sanctum_unknown"] = "圣所升级状态未知。"
L["covenant_not_joined"] = "该角色尚未加入任何盟约。"

-- Table tooltips
L["table_sort_hint"] = "<左键点击排序>"
L["table_reset_progress_hint"] = "<按住 Ctrl 点击以重置进度>"
L["table_alts_collect_hint"] = "登录该角色以收集数据。"

-- Tips
L["tips_scrollbar_vertical"] = "拖动或使用鼠标滚轮以滚动查看更多行。"
L["tips_scrollbar_horizontal"] = "拖动或使用鼠标滚轮以滚动查看更多列。|n|n如果同时可以垂直滚动，使用鼠标滚轮时请按住|cffffff00修饰键|r。"
L["tips_drag_to_reorder"] = "拖动奖励名称到新位置以调整顺序。"

-- Progress tooltips
L["progress_rewards_received_at"] = "奖励领取于："
L["progress_started_at"] = "开始于："
L["progress_rewards_received"] = "已获得的奖励"
L["progress_not_started"] = "<未开始>"
L["progress_drops"] = "掉落"

-- Reward tooltips
L["reward_objective_multi_quests_title"] = "完成以下任务中的%d个："

-- Candidate tooltips
L["candidate_from"] = "奖励来自|cffffffff%s|r"
L["candidate_from_following_1"] = "以下之一在战团中共享："
L["candidate_from_following_n"] = "以下%d项在战团中共享："
L["candidate_from_following_all"] = "以下全部："
L["candidate_1_of_following_per_character"] = "每个角色可选择以下之一："
L["candidate_n_of_following_per_character"] = "每个角色最多可完成以下%d项："
L["candidate_x_of_following_per_character"] = "每个角色可完成以下任意项："
L["candidate_not_active"] = "本周该奖励未激活"

-- Summary
L["summary_completed_count"] = "%s本周已完成%d次"
L["summary_progress"] = "战团进度："
L["summary_rewards_received"] = "获得的奖励总计："

-- Character tooltip
L["character_fully_rested"] = "充分休息"
L["character_time_to_fully_rested"] = "距离充分休息：|cffffffff%s|r"
L["character_last_party"] = "上次队伍："

-- Reward descriptions. {map:%s} is filled from the reward id (brew:1978, lf:12).
L["reward:tww-chett"] = "每周 C.H.E.T.T. 清单"
L["reward:tww-incursion"] = "{map:2215}或{map:2255}的日常突袭"
L["reward:tww-invasion"] = "{map:2369}入侵任务|n|n敌人每周轮换，共三种类型：|n|cnYELLOW_FONT_COLOR:维库人|r、|cnYELLOW_FONT_COLOR:纳迦|r和|cnYELLOW_FONT_COLOR:海盗|r。"
L["reward:tww-lfd"] = "每周地下城任务"
L["reward:tww-pact"] = "每周{map:2255}契约选择"
L["reward:mn-pdrops"] = "每周可从世界各地的宝藏中获得专业知识"
L["reward:mn-pquests"] = "每周专业任务"
L["reward:mn-prey-n"] = "每周从{npc:245824}处接取的普通难度猎杀目标。"
L["reward:mn-prey-h"] = "每周从{npc:245824}处接取的困难难度猎杀目标。"
L["reward:mn-prey-m"] = "每周从{npc:245824}处接取的梦魇难度猎杀目标。"
L["reward:brew"] = "向{map:%s}各地的旅店捐献，帮他们付账！"
L["reward:df-artifacts"] = "暗月马戏团文物"
L["reward:df-prof"] = "暗月马戏团专业任务"
L["reward:lf"] = "拜访{map:%s}的长者"
L["reward:lf-capital"] = "拜访|cffffff00阵营主城|r中的长者"
L["reward:lf-dungeon"] = "拜访|cffffff00地下城|r中的长者"
L["reward:love-dono"] = "向工匠商盟捐献金币，以支持礼物盛会。|n|n捐献数分钟后，奖励将通过邮件送达。"
L["reward:msf-capital"] = "从阵营主城偷取火焰"
L["reward:noble-boss"] = "日常节日首领：{npc:216295}。|n|n这个羽族恶棍的巢穴位于{map:37}和{map:1}。"
L["reward:delve-abundance"] = "每周第一次在地下堡中找到{npc:242704}时，该地下堡会变为{spell:1297887}，结束时还会额外获得以下宝箱：|n- 1个|cnEPIC_PURPLE_COLOR:丰裕宝匣|r|n- 2个|cnRARE_BLUE_COLOR:格外丰裕的沉重宝箱|r"
L["reward:delve-fragment-m"] = "从为期6周的{storyline:6385}中获得。{item:285065:0}"
L["reward:bonus"] = "每周奖励活动会提供一个奖励装备的每周任务。"
L["reward:vault"] = "宏伟宝库奖励。从最多9件物品中选择1件。|n|n奖励的物品等级取决于你本周的最高难度记录。|n你也可以选择{item:269862}，而不是装备（每个纹章500|A:coin-gold:0:0|a）。"
