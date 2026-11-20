if GetLocale() ~= "ruRU" then
	return
end

local _, ns = ...
local L = ns.L

-- Binding
L["BINDING_NAME_WeeklyRewards"] = "Показать/скрыть окно WeeklyRewards"

-- Minimap tooltip
L["minimap_tooltip_left_click"] = "|cff00ff00ЛКМ|r - открыть WeeklyRewards."
L["minimap_tooltip_drag"] = "|cff00ff00Перетаскивание|r - переместить иконку."
L["minimap_tooltip_locked"] = " |cffff0000(заблокировано)|r"

-- Window titlebar buttons
L["settings_button_description"] = "Настройки окна"
L["characters_button_title"] = "Отслеживание персонажей"
L["characters_button_description"] = "Вкл./откл. Ваших персонажей."
L["characters_button_remove_hint"] = "<Ctrl+ЛКМ - удалить персонажа>"
L["columns_button_tooltip"] = "Колонки"
L["columns_button_description"] = "Вкл./откл. отслеживание наград."

-- Settings menu
L["settings_show_minimap_button"] = "Показывать кнопку у миникарты"
L["settings_lock_minimap_button"] = "Заблокировать кнопку у миникарты"
L["settings_window_title"] = "Окно"
L["settings_max_width"] = "Макс. ширина"
L["settings_max_width_percent"] = "% от полного экрана"
L["settings_max_rows"] = "Макс. кол-во строк"
L["settings_background_color"] = "Цвет фона"
L["settings_player_row_color"] = "Цвет строки текущего персонажа"
L["settings_show_border"] = "Показывать границу"
L["settings_show_row_numbers"] = "Показывать номера строк"
L["settings_tutorials_tooltip"] = "Показывать обучающие подсказки, помогающие познакомиться с аддоном."
L["settings_auto_untrack_quests"] = "Отключение заданий"
L["settings_auto_untrack_quests_tooltip"] = "Отключить отслеживание всех заданий, управляемых WeeklyRewards, при входе в игру, что позволит сделать панель журнала заданий более удобной."
L["settings_broadcast_rewards"] = "Оповещать о наградах"
L["settings_broadcast_rewards_tooltip"] = "После получения наград Отряда Вы сможете опубликовать сводку по ней. Для этого автоматически выбирается канал чата с наибольшей аудиторией."

-- automation menu
L["automation_button_tooltip"] = "Автоматизация и инструменты"
L["automation_button_description"] = "Ускорьте фарм и повысьте комфорт игры для всех персонажей."
L["automation_disable_hint"] = "Удерживайте любой модификатор (Ctrl/Shift/Alt), чтобы временно отключить автоматизацию"
L["automation_reset_hint"] = "Удерживайте клавишу-модификатор при выборе, если не хотите заменять сохранённую автоматизацию."
L["automation_auto_enter_title"] = "Автовход"
L["automation_auto_enter_tooltip"] = "Автоматически входить в Вал и Найтал на выбранной сложности."
L["automation_auto_flight_title"] = "Автополёт"
L["automation_auto_flight_tooltip"] = "Запоминает маршрут, выбранный у распорядителя полётов, и автоматически выбирает его в следующий раз на этом и остальных персонажах. Берутся только изученные маршруты, стоимость списывается как обычно."
L["automation_auto_flight_saved"] = "Перелёт из %s в |cff71d5ff%s|r сохранён. В следующий раз все Ваши персонажи автоматически воспользуются этим."
L["automation_fast_loot_title"] = "Быстрый сбор добычи"
L["automation_fast_loot_tooltip"] = "Сбор добычи с максимальной скоростью, пропуская задержку окна добычи.|nПри включении автоматический сбор добычи также будет включён для всех персонажей."

-- Table columns
L["column_realm"] = "Игровой мир"
L["column_covenant"] = "Ковенант"

-- Covenant tooltips
L["covenant_sanctum_unknown"] = "Статус обновления Обители неизвестен."
L["covenant_not_joined"] = "Этот персонаж не вступал ни в один Ковенант."

-- Table tooltips
L["table_sort_hint"] = "<ЛКМ - сортировка>"
L["table_reset_progress_hint"] = "<Ctrl+ЛКМ - сброс прогресса>"
L["table_alts_collect_hint"] = "Войдите в игру этим персонажем, чтобы обновить его прогресс."

-- Tips
L["tips_scrollbar_vertical"] = "Перетащите или используйте колесо мыши для прокрутки дополнительных строк."
L["tips_scrollbar_horizontal"] = "Перетащите ползунок или используйте колесо мыши, чтобы прокрутить и увидеть больше столбцов.|n|nЕсли окно также прокручивается по вертикали, удерживайте |cffffff00клавишу-модификатор|r при использовании колеса мыши."
L["tips_drag_to_reorder"] = "Перетащите название награды на новую позицию, чтобы изменить её порядок."

-- Progress tooltips
L["progress_rewards_received_at"] = "Награды получены:"
L["progress_started_at"] = "Начато:"
L["progress_rewards_received"] = "Награды получены"
L["progress_not_started"] = "<Не начато>"
L["progress_drops"] = "Дроп"

-- Reward tooltips
L["reward_objective_multi_quests_title"] = "Завершите %d из следующих заданий:"

-- Candidate tooltips
L["candidate_from"] = "Награды, полученные из |cffffffff%s|r"
L["candidate_from_following_1"] = "Один из следующих, общий для Вашего отряда:"
L["candidate_from_following_n"] = "%d из следующих, общих для Вашего отряда:"
L["candidate_from_following_all"] = "Все из следующих:"
L["candidate_1_of_following_per_character"] = "Один из следующих на персонажа:"
L["candidate_n_of_following_per_character"] = "Не более %d из следующих на персонажа:"
L["candidate_x_of_following_per_character"] = "Любой из следующих на персонажа:"
L["candidate_not_active"] = "Эта награда неактивна на этой неделе"

-- Summary
L["summary_completed_count"] = "%s выполнено %d раз на этой неделе"
L["summary_progress"] = "Прогресс Отряда:"
L["summary_rewards_received"] = "Всего получено наград: "

-- Character tooltip
L["character_fully_rested"] = "Полностью отдохнувший"
L["character_time_to_fully_rested"] = "Время до полного отдыха: |cffffffff%s|r"
L["character_last_party"] = "Последняя группа:"

-- Reward descriptions. {map:%s} подставляется из id награды (brew:1978, lf:12).
L["reward:tww-chett"] = "Еженедельный список C.H.E.T.T."
L["reward:tww-incursion"] = "Ежедневные вторжения: {map:2215} или {map:2255}"
L["reward:tww-invasion"] = "Задания вторжения: {map:2369}|n|nКаждую неделю враги сменяются и бывают трех типов:|n|cnYELLOW_FONT_COLOR:Врайкулы|r, |cnYELLOW_FONT_COLOR:Наги|r и |cnYELLOW_FONT_COLOR:Пираты|r."
L["reward:tww-lfd"] = "Еженедельное задание в подземелье"
L["reward:tww-pact"] = "Еженедельный выбор договора: {map:2255}"
L["reward:mn-pdrops"] = "Еженедельное знание профессий из сокровищ по всему миру"
L["reward:mn-pquests"] = "Еженедельные задания профессий"
L["reward:mn-prey-n"] = "Еженедельные цели добычи на обычной сложности от {npc:245824}."
L["reward:mn-prey-h"] = "Еженедельные цели добычи на сложной сложности от {npc:245824}."
L["reward:mn-prey-m"] = "Еженедельные цели добычи на кошмарной сложности от {npc:245824}."
L["reward:brew"] = "Пожертвуйте тавернам в зоне {map:%s}, чтобы оплатить счет!"
L["reward:df-artifacts"] = "Ярмарка Новолуния: артефакты"
L["reward:df-prof"] = "Ярмарка Новолуния: задания профессий"
L["reward:lf"] = "Навестить старейшин: |cnYELLOW_FONT_COLOR:{map:%s}|r"
L["reward:lf-capital"] = "Навестить старейшин: |cnYELLOW_FONT_COLOR:Столицы фракций|r"
L["reward:lf-dungeon"] = "Навестить старейшин: |cnYELLOW_FONT_COLOR:Подземелья|r"
L["reward:love-dono"] = "Пожертвуйте золото (Консорциум ремесленников), чтобы поддержать Праздник даров.|n|nНаграда придет по почте через несколько минут после пожертвования."
L["reward:msf-capital"] = "Кража пламени из столиц фракций"
L["reward:noble-boss"] = "Ежедневный праздничный босс: {npc:216295}.|n|nГнездо этого пернатого злодея находится в зонах {map:37} и {map:1}."
L["reward:delve-abundance"] = "Когда Вы впервые за неделю находите {npc:242704} в Вылазке, она становится {spell:1297887}, и в конце Вас ждут дополнительные сундуки:|n- 1 {item:228942:1}|n- 2 |cnRARE_BLUE_COLOR:Тяжелый сундук щедрого изобилия|r"
L["reward:delve-fragment-m"] = "Награда за 6-недельное задание {storyline:6385}. {item:285065:0}"
L["reward:bonus"] = "Еженедельное бонусное событие дает еженедельное задание. Награда: Снаряжение."
L["reward:vault"] = "Награды Великого хранилища: один предмет из набора до 9 вариантов.|n|nУровень предмета зависит от лучших прохождений за неделю.|nВместо снаряжения можно выбрать {item:269862} (500|A:coin-gold:0:0|a за каждый жетон)."
