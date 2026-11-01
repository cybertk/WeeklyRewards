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
L["automation_auto_enter_title"] = "自动进入"
L["automation_auto_enter_tooltip"] = "按所选难度自动进入{map:3047}和{map:3075}。"

-- Table columns
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
L["candidate_from_following_quests"] = "%s来自以下任务之一："
L["candidate_from_quest_format"] = "任务奖励：{quest:%d}"
L["candidate_one_of_following_quests"] = "每个角色可以各自选择以下任务之一："
L["candidate_from_quest"] = "任务奖励"
L["candidate_not_active"] = "本周该奖励未激活"

-- Summary
L["summary_completed_count"] = "%s本周已完成%d次"
L["summary_progress"] = "战团进度："
L["summary_rewards_received"] = "获得的奖励总计："

-- Character tooltip
L["character_fully_rested"] = "充分休息"
L["character_time_to_fully_rested"] = "距离充分休息：|cffffffff%s|r"
L["character_last_party"] = "上次队伍："

-- Shared fragments used by reward data
L["week_count"] = "第%d周"
L["df_profession_knowledge"] = "专业知识点数"
L["love_bundle_500"] = "|cff1eff00[爱情信物包裹]|r：捐献500金币，内含3-5个|T135453:12|t |cffffffff[爱情信物]|r"
L["love_bundle_10000"] = "|cff0070dd[爱情信物包裹]|r：捐献10000金币，内含10-15个|T135453:12|t |cffffffff[爱情信物]|r"

-- Reward descriptions. Keys are candidate ids. Tags resolve to client names.
L["desc:vault"] = "宏伟宝库奖励。从最多9件物品中选择1件。|n|n奖励的物品等级取决于你本周的最高难度记录。|n你也可以选择{item:258556}，而不是装备。"
L["desc:bonus"] = "每周奖励活动会提供一个奖励装备的任务。|n|n这些活动按固定日程轮换，包括：|n- {quest:93593}|n- {quest:93595}|n- {quest:93600}|n- {quest:93605}"
L["desc:tw-dd"] = "时空漫游团队副本"
L["desc:tw-lfd"] = "时空漫游地下城"
L["desc:df-artifacts"] = "暗月马戏团文物"
L["desc:df-prof"] = "暗月马戏团专业任务"
L["desc:df-daily"] = "暗月马戏团日常任务"
L["desc:lf-kal"] = "拜访卡利姆多的长者"
L["desc:lf-ek"] = "拜访东部王国的长者"
L["desc:lf-nr"] = "拜访诺森德的长者"
L["desc:lf-maelstrom"] = "拜访大漩涡的长者"
L["desc:lf-di"] = "拜访巨龙群岛的长者"
L["desc:lf-ka"] = "拜访卡兹阿加的长者"
L["desc:lf-dungeon"] = "拜访地下城中的长者"
L["desc:lf-capital"] = "拜访阵营主城中的长者"
L["desc:msf-main"] = "一次性任务"
L["desc:msf-daily"] = "日常任务"
L["desc:msf-capital"] = "从阵营主城偷取火焰"
L["desc:msf-boss"] = "日常地下城首领：埃霍恩"
L["desc:love-main"] = "一次性主线任务"
L["desc:love-daily"] = "日常任务"
L["desc:love-boss"] = "影牙城堡日常地下城首领：皇冠药剂公司三人组"
L["desc:love-dono"] = "向工匠商盟捐献金币，以支持礼物盛会。|n|n捐献数分钟后，奖励将通过邮件送达。"
L["desc:noble-main"] = "一次性引导任务"
L["desc:noble-daily"] = "日常任务"
L["desc:noble-boss"] = "日常节日首领：戴坦·迅羽。|n|n这个羽族恶棍的巢穴位于{map:37}和{map:1}。"
L["desc:brew-main"] = "美酒节一次性主线任务"
L["desc:brew-daily"] = "美酒节日常任务"
L["desc:brew-boss"] = "黑石深渊日常地下城首领：科林·烈酒"
L["desc:brew-di"] = "向巨龙群岛各地的旅店捐献，帮他们付账！"
L["desc:brew-ka"] = "向卡兹阿加各地的旅店捐献，帮他们付账！"
L["desc:brew-qt"] = "向奎尔萨拉斯各地的旅店捐献，帮他们付账！"
L["desc:mn-pquests"] = "每周专业任务"
L["desc:mn-pdrops"] = "每周可从世界各地的宝藏中获得专业知识"
L["desc:delve-abundance"] = "{faction:2796:-3:1}|n|n每周第一次在地下堡中找到 Dundun 时，该地下堡会变为{spell:1297887}，"
	.. "结束时还会额外获得以下宝箱：|n- 1个|cnEPIC_PURPLE_COLOR:丰裕宝匣|r|n- 2个|cnRARE_BLUE_COLOR:格外丰裕的沉重宝箱|r"
L["desc:delve-fragment-m"] = "从为期6周的{storyline:6385}中获得{item:285065}。|n|n{item:285065:0}"
L["desc:mn-worldboss"] = "每周世界首领"
L["desc:mn-prey-n"] = "每周猎杀任务（普通）"
L["desc:mn-prey-h"] = "每周猎杀任务（困难）"
L["desc:mn-prey-m"] = "每周猎杀任务（梦魇）"
L["desc:mn-prey-select"] = "优先猎杀|n|cnLIGHTBLUE_FONT_COLOR:在“猎手旅途”中达到名望10后解锁。|r"
L["desc:mn-lair"] = "每周巢穴世界首领"
L["desc:tww-worldboss"] = "每周世界首领"
L["desc:tww-archives"] = "档案馆汇总任务"
L["desc:tww-delves"] = "地下堡汇总任务"
L["desc:tww-pact"] = "每周{map:2255}契约选择"
L["desc:tww-atm"] = "每周觉醒机器事件"
L["desc:tww-wax"] = "为狗头人收集蜡油"
L["desc:tww-lfd"] = "每周地下城任务"
L["desc:tww-invasion"] = "{map:2369}入侵任务|n|n敌人每周从三种类型中轮换：|n|cffffff00维库人|r、|cffffff00纳迦|r和|cffffff00海盗|r。"
L["desc:tww-circlet"] = "{item:228411}|n|n完成{quest:84724}后，戒指的起始物品等级为642。|n|n{item:229365}可将戒指提升至最高物品等级658。|n它会从{map:2369}的所有内容中掉落。"
L["desc:tww-chett"] = "每周 C.H.E.T.T. 清单"
L["desc:tww-incursion"] = "{map:2215}或{map:2255}的日常突袭"
