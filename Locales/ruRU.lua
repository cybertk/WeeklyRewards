if GetLocale() ~= "ruRU" then
	return
end

local _, ns = ...
local L = ns.L
--Translator ZamestoTV
-- Binding
L["BINDING_NAME_WeeklyRewards"] = "Показать/скрыть окно WeeklyRewards"

-- Minimap tooltip
L["minimap_tooltip_left_click"] = "|cff00ff00ЛКМ|r — открыть WeeklyRewards."
L["minimap_tooltip_drag"] = "|cff00ff00Перетаскивание|r — переместить иконку"
L["minimap_tooltip_locked"] = " |cffff0000(заблокировано)|r"

-- Window titlebar buttons
L["close_button_tooltip"] = "Закрыть окно"
L["settings_button_tooltip"] = "Настройки"
L["settings_button_description"] = "Настроим всё по вашему вкусу"
L["characters_button_tooltip"] = "Персонажи"
L["characters_button_description"] = "Включить/отключить ваших персонажей."
L["characters_button_remove_hint"] = "<Ctrl+клик для удаления персонажа>"
L["columns_button_tooltip"] = "Колонки"
L["columns_button_description"] = "Включить/отключить отслеживание наград."
L["sort_button_tooltip"] = "Сортировка"
L["sort_button_description"] = "Выберите параметры сортировки для колонок наград."

-- Settings menu
L["settings_show_minimap_button"] = "Показывать кнопку у миникарты"
L["settings_show_minimap_tooltip"] = "Иногда вокруг миникарты становится тесно."
L["settings_lock_minimap_button"] = "Заблокировать кнопку у миникарты"
L["settings_lock_minimap_tooltip"] = "Больше не будете случайно перемещать кнопку!"
L["settings_window_title"] = "Окно"
L["settings_scaling"] = "Масштаб"
L["settings_max_width"] = "Макс. ширина"
L["settings_max_width_percent"] = "% от полного экрана"
L["settings_background_color"] = "Цвет фона"
L["settings_show_border"] = "Показывать рамку"
L["settings_utility_title"] = "Утилиты"
L["settings_auto_untrack_quests"] = "Авто-снятие заданий"
L["settings_auto_untrack_quests_tooltip"] = "При входе в игру снимает все задания, управляемые WeeklyRewards — для чистоты панели заданий"
L["settings_broadcast_rewards"] = "Оповещать о наградах"
L["settings_broadcast_rewards_tooltip"] = "После получения наград Отряда — отправит сводку в чат с наибольшей аудиторией (автовыбор канала)."

-- Table columns
L["column_realm"] = "Сервер"
L["column_covenant"] = "Ковенант"
L["column_location"] = "Местоположение"
L["column_last_update"] = "Обновлено"

-- Table tooltips
L["table_sort_hint"] = "<ЛКМ — сортировка>"
L["table_reset_progress_hint"] = "<Ctrl+клик — сброс прогресса>"

-- Progress tooltips
L["progress_rewards_received_at"] = "Награды получены:"
L["progress_started_at"] = "Начато:"
L["progress_rewards_received"] = "Награды получены"
L["progress_not_started"] = "<Не начато>"
L["progress_drops"] = "Дроп"

-- Reward tooltips
L["reward_rewards"] = "Награды"
L["reward_time_left"] = "Осталось времени: "

-- Sorting options
L["sort_reward_group"] = "Группа наград"
L["sort_reward_name"] = "Название награды"
L["sort_time_left"] = "Осталось времени"
