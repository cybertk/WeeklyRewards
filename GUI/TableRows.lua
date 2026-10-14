local _, namespace = ...

local Util = namespace.Util
local Flags = namespace.Flags
local Settings = namespace.Settings
local Tips = namespace.Tips
local ActiveRewards = namespace.ActiveRewards

local TableRowMixin = {}

function TableRowMixin:OnLoad() end

local ReorderMixin = {}

function ReorderMixin:OnEvent(event, ...)
	if event == "GLOBAL_MOUSE_UP" then
		self:EndOrderChange(...)
		self:SetScript("OnEvent", self.sourceOnEventScript)
		self:UnregisterEvent("GLOBAL_MOUSE_UP")
	end
end

function ReorderMixin:OnOrderChangeBegin(source, ghost, blocker) end
function ReorderMixin:OnOrderChangeCancel(source) end
function ReorderMixin:OnOrderChangeEnd(source, target, placeBeforeTarget) end

function ReorderMixin:CreateReorderMarker()
	local line = self:CreateTexture(nil, "OVERLAY")

	line:SetDrawLayer("OVERLAY", 7)
	line:SetAtlas("CDM-Vertical", true)
	line:SetSize(8, 52)

	return line
end

function ReorderMixin:CreateReorderBlocker()
	local blocker = CreateFrame("Frame")

	blocker:SetFrameStrata("TOOLTIP")
	blocker:SetFrameLevel(10000)
	blocker:EnableMouse(true)

	return blocker
end

function ReorderMixin:CreateReorderGhost()
	local ghost = CreateFrame("Frame", nil, UIParent)

	ghost:SetFrameStrata("TOOLTIP")
	ghost:SetFrameLevel(10000)

	return ghost
end

function ReorderMixin:AddReorderSource(frame, reorderable)
	if frame:GetParent() ~= self then
		return
	end

	frame.reorderable = not not reorderable

	if reorderable then
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", function(frame)
			self:BeginOrderChange(frame)
		end)
	else
		frame:RegisterForDrag()
		frame:SetScript("OnDragStart")
	end
end

function ReorderMixin:GetReorderMarker()
	if self.reorderMarker == nil then
		self.reorderMarker = self:CreateReorderMarker()
	end
	return self.reorderMarker
end

function ReorderMixin:GetReorderBlocker()
	if self.reorderBlocker == nil then
		self.reorderBlocker = self:CreateReorderBlocker()
	end
	return self.reorderBlocker
end

function ReorderMixin:GetReorderGhost()
	if self.reorderGhost == nil then
		self.reorderGhost = self:CreateReorderGhost()
	end
	return self.reorderGhost
end

function ReorderMixin:UpdateReorderTarget()
	local region = GetMouseFoci()[1]
	if not region then
		self.reorderTarget = nil
		return
	end

	local left, right = region:GetLeft(), region:GetRight()
	if left and right then
		self.placeBeforeTarget = GetCursorPosition() / region:GetEffectiveScale() < (left + right) / 2
	end

	self.reorderTarget = region
end

function ReorderMixin:UpdateReorderMarker()
	local marker = self:GetReorderMarker()

	if not self.reorderTarget or self.reorderTarget == self.reorderSource then
		marker:Hide()
		return
	end

	if self.reorderTarget.reorderable then
		marker:SetVertexColor(1, 1, 1)
	else
		marker:SetVertexColor(ERROR_COLOR:GetRGB())
	end

	marker:ClearAllPoints()
	marker:SetPoint("CENTER", self.reorderTarget, self.placeBeforeTarget and "LEFT" or "RIGHT", 0, 0)
	marker:Show()
end

function ReorderMixin:IsReordering()
	return self.reorderSource ~= nil
end

function ReorderMixin:BeginOrderChange(frame)
	if self:IsReordering() then
		return
	end

	self.reorderSource = frame

	PlaySound(SOUNDKIT.UI_CURSOR_PICKUP_OBJECT)
	GameTooltip:Hide()
	SetCursor("Interface/CURSOR/openhandglow")

	local ghost = self:GetReorderGhost()
	ghost:SetSize(frame:GetSize())
	ghost:SetScript("OnUpdate", function(f)
		local x, y = GetCursorPosition()
		local scale = f:GetEffectiveScale()
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale + 16, y / scale - 0)

		self:UpdateReorderTarget()
		self:UpdateReorderMarker()
	end)
	ghost:Show()

	local blocker = self:GetReorderBlocker()
	blocker:Show()

	self.sourceOnEventScript = self:GetScript("OnEvent")
	self:SetScript("OnEvent", self.OnEvent)
	self:RegisterEvent("GLOBAL_MOUSE_UP")

	self:OnOrderChangeBegin(self.reorderSource, ghost, blocker)
end

function ReorderMixin:EndOrderChange(frame)
	if not self:IsReordering() then
		return
	end

	local ghost = self:GetReorderGhost()
	local source, target = self.reorderSource, self.reorderTarget

	ghost:SetScript("OnUpdate")
	ghost:Hide()
	self.reorderSource = nil
	self.reorderTarget = nil
	self:GetReorderMarker():Hide()
	self:GetReorderBlocker():Hide()

	ResetCursor()

	if target and target.reorderable and source ~= target then
		PlaySound(SOUNDKIT.UI_CURSOR_DROP_OBJECT)
		self:OnOrderChangeEnd(source, target, self.placeBeforeTarget)
	else
		PlaySound(SOUNDKIT.COOLDOWN_LAYOUT_MANAGER_PLACEMENT_ERROR)
		self:OnOrderChangeCancel(source)
	end
end

local TableHeaderRowMixin = CreateFromMixins(TableRowMixin, ReorderMixin)

function TableHeaderRowMixin:OnLoad()
	TableRowMixin.OnLoad(self)
	for _, column in ipairs(self.columns) do
		self:AddReorderSource(column, column.data.selectedIndex)

		Mixin(column, WeeklyRewardsTableHeaderCellMixin)
		_G.xx = column
		if not column.Arrow then
			column:OnLoad()
		end

		column:Layout()

		if column.data.selectedIndex == 1 and (ActiveRewards:IsNewCandidateSelected() or Flags:IsSet("dragTip")) then
			C_Timer.After(0.2, function()
				Tips:ShowDragToOrderHelpTip(column)
				Flags:Clear("dragTip")
			end)
		end
	end
end

function TableHeaderRowMixin:OnOrderChangeBegin(source, ghost, blocker)
	if not ghost.text then
		ghost.text = ghost:CreateFontString(nil, "OVERLAY")
		ghost.text:SetFontObject("GameFontHighlightSmall")
		ghost.text:SetPoint("TOPLEFT", ghost, "TOPLEFT", 8, 0)
		ghost.text:SetPoint("BOTTOMRIGHT", ghost, "BOTTOMRIGHT", -8, 0)
		ghost.text:SetJustifyH("CENTER")

		ghost.background = ghost:CreateTexture(nil, "BACKGROUND")
		ghost.background:SetAllPoints()
		ghost.background:SetColorTexture(0, 0, 0, 1)
	end

	ghost:SetScale(self.window:GetScale())
	ghost.text:SetText(source.text:GetText())

	for _, column in ipairs(self.columns) do
		column:SetEnabled(false)
	end

	blocker:SetAllPoints(self.window.table.scrollFrame)
end

function TableHeaderRowMixin:OnOrderChangeCancel(source)
	for _, column in ipairs(self.columns) do
		column:SetEnabled(true)
	end
end

function TableHeaderRowMixin:OnOrderChangeEnd(source, target, placeBeforeTarget)
	self:OnOrderChangeCancel(source)

	if ActiveRewards.Get():MoveSelected(source.data.selectedIndex, target.data.selectedIndex, placeBeforeTarget) then
		Util:Debug("Reordered column:", source.data.selectedIndex, target.data.selectedIndex, placeBeforeTarget)
		namespace.GUIMain:Redraw()
	end
end

local TableDataRowMixin = CreateFromMixins(TableRowMixin)

function TableDataRowMixin:OnLoad()
	TableRowMixin.OnLoad(self)

	self:UpdateBackgroundColor(self.data.character:IsCurrent() and Settings:Get("windowPlayerRowColor") or nil)
end

function TableDataRowMixin:UpdateBackgroundColor(color)
	if color then
		if not self:GetNormalTexture() then
			self:SetNormalTexture("Interface/BUTTONS/WHITE8X8")
		end

		self:GetNormalTexture():SetVertexColor(color.r, color.g, color.b, color.a)
	end

	if self:GetNormalTexture() then
		self:GetNormalTexture():SetShown(color ~= nil)
	end

	if self.Background then
		self.Background:SetShown(color == nil)
	end
end

WeeklyRewardsTableHeaderRowMixin = TableHeaderRowMixin
WeeklyRewardsTableDataRowMixin = TableDataRowMixin
