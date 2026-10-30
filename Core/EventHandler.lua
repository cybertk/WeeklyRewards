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

function EventHandlerMixin:RegisterEvent(...)
	self.frame:RegisterEvent(...)
end

function EventHandlerMixin:UnregisterEvent(...)
	self.frame:UnregisterEvent(...)
end

local ModuleManager = CreateFromMixins(EventHandlerMixin, { Modules = {}, ModulesToEnable = {}, Events = { "PLAYER_ENTERING_WORLD" } })

function ModuleManager:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
	if isInitialLogin == false and isReloadingUi == false then
		return
	end

	for _, m in ipairs(ModuleManager.ModulesToEnable) do
		m:SetEnabled(true)
	end

	ModuleManager.ModulesToEnable = nil
end

function ModuleManager.RegisterModule(name, module, enableOnLogin)
	ModuleManager.Modules[name] = module

	if enableOnLogin then
		table.insert(ModuleManager.ModulesToEnable, module)
	end
end

function ModuleManager.SetModuleEnabled(name, enabled)
	local m = ModuleManager.Modules[name]
	if m then
		m:SetEnabled(enabled)
	end

	if namespace.debug then
		print("|cffff0000", addonName, "SetModuleEnabled", m and "|cff00ff00" or "", name, enabled)
	end
end

namespace.EventHandlerMixin = EventHandlerMixin
namespace.ModuleManager = ModuleManager
