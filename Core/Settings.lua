local _, namespace = ...

local Settings = { callbacks = {}, keysMonitored = {} }

function Settings:RegisterSettings(savedVariableName, default)
	local function PopulateDefaultValue(tbl, values)
		for key, value in pairs(values) do
			if tbl[key] == nil then
				tbl[key] = value
			elseif type(value) == "table" then
				tbl[key] = tbl[key] or {}
				PopulateDefaultValue(tbl[key], value)
			end
		end
	end

	if _G[savedVariableName] == nil then
		_G[savedVariableName] = {}
	end

	self.settings = _G[savedVariableName]
	PopulateDefaultValue(self.settings, default)
end

function Settings:RegisterCallback(keyPattern, callback, owner, ...)
	if self.callbacks[keyPattern] == nil then
		self.callbacks[keyPattern] = {}
	end

	self.callbacks[keyPattern][owner] = GenerateClosure(callback, owner, ...)

	for key, _ in pairs(self.keysMonitored) do
		if key:find(keyPattern) then
			self.keysMonitored[key] = nil
		end
	end
end

function Settings:InvokeAndRegisterCallback(keyPattern, callback, ...)
	callback(..., self.settings[keyPattern], keyPattern)
	self:RegisterCallback(keyPattern, callback, ...)
end

function Settings:UnregisterCallback(keyPattern, owner)
	if self.callbacks[keyPattern] == nil then
		return
	end

	self.callbacks[keyPattern][owner] = nil
end

function Settings:Notify(key, value)
	if self.keysMonitored[key] == nil then
		local callbacks = {}

		for pattern, closures in pairs(self.callbacks) do
			if key:find(pattern) then
				for _, closure in pairs(closures) do
					table.insert(callbacks, closure)
				end
			end
		end

		self.keysMonitored[key] = callbacks
	end

	for _, callback in ipairs(self.keysMonitored[key]) do
		callback(value, key)
	end
end

function Settings:Set(key, value)
	local oldValue = self.settings[key]
	if oldValue == value then
		return
	end

	if type(value) == "table" then
		Mixin(self.settings[key], value)
	else
		self.settings[key] = value
	end

	self:Notify(key, value)
end

function Settings:Get(key)
	return self.settings[key]
end

function Settings:Toggle(key)
	self:Set(key, not self.settings[key])
end

function Settings:MatchOption(key, predicates)
	if not self.settings[key].enabled then
		return false
	end

	local predicate = predicates[self.settings[key].option]
	return predicate == nil or predicate()
end

function Settings:GetOption(key)
	if not self.settings[key].enabled then
		return
	end

	return self.settings[key].option
end

function Settings:WrapOptionCallback(key, callback, owner)
	local NotifyNewOption = function()
		callback(owner, Settings:GetOption(key))
	end

	return key, NotifyNewOption, owner
end

function Settings:GenerateTooltip(description, title)
	return function(tooltip)
		if type(description) == "string" then
			GameTooltip_SetTitle(tooltip, title)
			GameTooltip_AddNormalLine(tooltip, description)
		elseif description.itemID then
			tooltip:SetItemByID(description.itemID)
		elseif description.currencyID then
			tooltip:SetCurrencyByID(description.currencyID)
		end
	end
end

function Settings:GenerateGetter(key)
	return GenerateClosure(self.Get, self, key)
end

function Settings:GenerateTableGetter(key, constTableIndex)
	return function(tableIndex)
		return self.settings[key][constTableIndex or tableIndex]
	end
end

function Settings:GenerateComparator(key, value)
	return function(overrideValue)
		return self.settings[key] == (overrideValue or value)
	end
end

function Settings:GenerateSetter(key)
	return GenerateClosure(self.Set, self, key)
end

function Settings:GenerateToggler(key)
	return GenerateClosure(self.Toggle, self, key)
end

function Settings:GenerateTableToggler(key)
	return function(tableIndex)
		self:Set(key, { [tableIndex] = not self.settings[key][tableIndex] })
	end
end

function Settings:GenerateRotator(key, values)
	return function(overrideValues)
		local index = 1
		for i, v in ipairs(overrideValues or values) do
			if v == self.settings[key] then
				index = i
				break
			end
		end

		index = index == #values and 1 or (index + 1)

		self:Set(key, values[index])
	end
end

function Settings:CreateMenuTree(key, menu, text, submenuTextGetter, sortDescending, response)
	local submenus = {}

	if type(submenuTextGetter) == "table" then
		submenus = submenuTextGetter
	else
		for index in pairs(self.settings[key]) do
			table.insert(submenus, { index = index, priority = index, text = submenuTextGetter(index) })
		end
	end

	table.sort(submenus, function(a, b)
		if sortDescending then
			return a.priority > b.priority
		else
			return a.priority < b.priority
		end
	end)

	local rootMenu = text ~= nil and menu:CreateButton(text) or menu

	for _, row in ipairs(submenus) do
		self:CreateCheckboxMenu(key, rootMenu, row.text, row.index, row.tooltip, response)
	end
end

function Settings:CreateCheckboxMenu(key, menu, text, tableIndex, tooltipText, response)
	local checkbox

	if tableIndex then
		checkbox = menu:CreateCheckbox(text, Settings:GenerateTableGetter(key), Settings:GenerateTableToggler(key), tableIndex)
	else
		checkbox = menu:CreateCheckbox(text, Settings:GenerateGetter(key), Settings:GenerateToggler(key))
	end

	if tooltipText then
		checkbox:SetTooltip(self:GenerateTooltip(tooltipText, text))
	end

	if response then
		checkbox:SetResponse(response)
	end

	return checkbox
end

function Settings:CreateRadio(key, menu, text, data)
	return menu:CreateRadio(text, Settings:GenerateComparator(key), Settings:GenerateSetter(key), data)
end

function Settings:CreateOptionsTree(key, menu, text, options, tooltipText, response)
	local disableAllowed = type(Settings:Get(key)) == "table"

	local rootMenu, Comparator, Setter
	if disableAllowed then
		rootMenu = self:CreateCheckboxMenu(key, menu, text, "enabled", tooltipText)

		Comparator = function(v)
			return self.settings[key]["option"] == v
		end

		Setter = function(v)
			self:Set(key, { ["option"] = v })
		end
	else
		rootMenu = menu:CreateButton(text)
		rootMenu:SetTooltip(function(tooltip)
			GameTooltip_SetTitle(tooltip, text)
			GameTooltip_AddNormalLine(tooltip, tooltipText)
		end)

		Comparator = Settings:GenerateComparator(key)
		Setter = Settings:GenerateSetter(key)
	end

	if options.range then
		local values = {}
		local start, stop, step = unpack(options.range)

		for i = start, stop, step do
			if options.percentage then
				table.insert(values, { text = format("%d%%", i), value = i / 100 })
			else
				table.insert(values, { text = format("%d", i), value = i })
			end
		end

		options = values
	end

	for _, option in ipairs(options) do
		if type(option) == "string" then
			option = { text = _G[option], value = option }
		end

		local radio = rootMenu:CreateRadio(option.text, Comparator, Setter, option.value)

		if response then
			radio:SetResponse(response)
		end

		if option.tooltip then
			radio:SetTooltip(self:GenerateTooltip(option.tooltip, option.text))
		end

		if disableAllowed then
			radio:SetEnabled(Settings:GenerateTableGetter(key, "enabled"))
		end
	end
end

namespace.Settings = Settings
