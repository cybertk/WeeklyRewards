local addonName, namespace = ...

local EventHandlerMixin = { IsEventFiltered = nop }

function EventHandlerMixin:Enable()
	if self.isEnabled then
		return
	end

	if not self.frame then
		self.frame = CreateFrame("Frame")
		self.frame:SetScript("OnEvent", function(_, event, ...)
			if not self:IsEventFiltered(event) then
				self[event](self, ...)
			end
		end)
	end

	if self.Events then
		FrameUtil.RegisterFrameForEvents(self.frame, self.Events)
	end

	if self.OnEnable then
		self:OnEnable()
	end

	self.isEnabled = true
end

function EventHandlerMixin:Disable()
	if not self.isEnabled then
		return
	end

	FrameUtil.UnregisterFrameForEvents(self.frame, self.Events)
	self.isEnabled = false
end

function EventHandlerMixin:SetEnabled(enabled)
	if enabled then
		self:Enable()
	else
		self:Disable()
	end
end

function EventHandlerMixin:SetDB(db, default)
	self.db = db

	for k, v in pairs(default) do
		if self.db[k] == nil then
			self.db[k] = type(v) == "table" and CopyTable(v) or v
		end
	end
end

function EventHandlerMixin:RegisterEvent(...)
	self.frame:RegisterEvent(...)
end

function EventHandlerMixin:UnregisterEvent(...)
	self.frame:UnregisterEvent(...)
end

local ModuleManager = CreateFromMixins(EventHandlerMixin, { Modules = {}, ModulesToEnable = {}, ModuleDefaultDB = {}, Events = { "PLAYER_ENTERING_WORLD" } })

function ModuleManager:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
	if isInitialLogin == false and isReloadingUi == false then
		return
	end

	for _, m in ipairs(ModuleManager.ModulesToEnable) do
		m:SetEnabled(true)
	end

	ModuleManager.ModulesToEnable = nil
end

function ModuleManager.RegisterModule(name, module, defaultDB, enableOnLogin)
	ModuleManager.Modules[name] = module
	ModuleManager.ModuleDefaultDB[name] = defaultDB

	if enableOnLogin then
		table.insert(ModuleManager.ModulesToEnable, module)
	end
end

function ModuleManager.SetModuleEnabled(name, enabled)
	local m = ModuleManager.Modules[name]

	if m and ModuleManager.ModuleDefaultDB[name] and ModuleManager.db then
		ModuleManager.db[name] = ModuleManager.db[name] or {}
		m:SetDB(ModuleManager.db[name], ModuleManager.ModuleDefaultDB[name])
	end

	if m then
		m:SetEnabled(enabled)
	end

	if namespace.Util.debug then
		print("|cffff0000", addonName, "SetModuleEnabled", m and "|cff00ff00" or "", name, enabled)
	end
end

function ModuleManager.SetDB(db)
	ModuleManager.db = db
end

namespace.EventHandlerMixin = EventHandlerMixin
namespace.ModuleManager = ModuleManager
