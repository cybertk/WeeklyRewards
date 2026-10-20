local _, namespace = ...

local Flags = { callbacks = {}, atlas = CreateAtlasMarkup("UI-HUD-MicroMenu-Communities-Icon-Notification", 19, 19) }

function Flags:Init(savedVariableName, changes)
	if _G[savedVariableName] == nil then
		_G[savedVariableName] = {}
	end

	self.data = _G[savedVariableName]

	for _, flags in ipairs(changes) do
		if not self.data.r or flags.r > self.data.r then
			for k, v in pairs(flags) do
				if self.data[k] and type(v) == "table" then
					tAppendAll(self.data[k], v)
				else
					self.data[k] = v
				end
			end
		end
	end
end

function Flags:InvokeAndRegisterCallback(key, callback)
	self.callbacks[key] = callback

	callback(self.data[key])
end

function Flags:Clear(key, value)
	if not self.data[key] then
		return
	end

	if value then
		tDeleteItem(self.data[key], value)
		if #self.data[key] == 0 then
			self:Clear(key)
		end

		return
	end

	self.data[key] = nil
	if self.callbacks[key] then
		self.callbacks[key]()
	end
end

function Flags:IsSet(key, value)
	if not self.data[key] then
		return false
	end

	if value then
		return tContains(self.data[key], value)
	end

	return true
end

function Flags:IsAnySet(key, tbl, field)
	if self.data[key] then
		for _, v in ipairs(tbl) do
			if tContains(self.data[key], v[field]) then
				return true
			end
		end
	end
end

function Flags:Format(s, key, value, field)
	if field then
		return self:IsAnySet(key, value, field) and s .. Flags.atlas or s
	else
		return self:IsSet(key, value) and s .. Flags.atlas or s
	end
end

namespace.Flags = Flags
