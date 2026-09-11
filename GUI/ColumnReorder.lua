local addonName, namespace = ...

local Constants = namespace.Constants
local Utils = namespace.Utils
local L = namespace.L
local Util = namespace.Util
local ActiveRewards = namespace.ActiveRewards

WeeklyRewardsColumnReorderMixin = {}

function WeeklyRewardsColumnReorderMixin:GetVisibleColumnAt(index)
	local i = 0
	local found
	self:ForEachColumn(function(column)
		i = i + 1
		if i == index then
			found = column
		end
	end)
	return found
end

function WeeklyRewardsColumnReorderMixin:GetColumnDragGhost()
	if self.columnDragGhost then
		return self.columnDragGhost
	end

	local ghost = CreateFrame("Frame", addonName .. "ColumnDragGhost", UIParent)
	ghost:SetFrameStrata("TOOLTIP")
	ghost:SetFrameLevel(10000)
	ghost:SetSize(80, Constants.TABLE_HEADER_HEIGHT)
	Utils:SetBackgroundColor(ghost, 0, 0, 0, 0.85)
	ghost.text = ghost:CreateFontString("$parentText", "OVERLAY")
	ghost.text:SetFontObject("GameFontHighlightSmall")
	ghost.text:SetPoint("TOPLEFT", ghost, "TOPLEFT", Constants.TABLE_CELL_PADDING, 0)
	ghost.text:SetPoint("BOTTOMRIGHT", ghost, "BOTTOMRIGHT", -Constants.TABLE_CELL_PADDING, 0)
	ghost.text:SetJustifyH("CENTER")
	ghost.text:SetJustifyV("MIDDLE")
	ghost.text:SetWordWrap(false)
	ghost:Hide()
	self.columnDragGhost = ghost
	return ghost
end

function WeeklyRewardsColumnReorderMixin:GetColumnDropIndicator()
	if self.columnDropIndicator then
		return self.columnDropIndicator
	end

	local header = self.window.table.rows[1]
	local line = header:CreateTexture(nil, "OVERLAY")
	line:SetDrawLayer("OVERLAY", 7)
	line:SetColorTexture(1, 0.82, 0, 0.95)
	line:SetWidth(3)
	line:Hide()
	self.columnDropIndicator = line
	return line
end

function WeeklyRewardsColumnReorderMixin:GetHeaderDropTarget()
	local header = self.window.table.rows[1]
	if not header then
		return
	end

	local scale = header:GetEffectiveScale()
	local cursorX = GetCursorPosition() / scale
	local cells = header.columns
	local n = #cells

	for i, cell in ipairs(cells) do
		if cell:IsShown() then
			local left, right = cell:GetLeft(), cell:GetRight()
			if left and right and cursorX >= left and cursorX <= right then
				return i, cell, cursorX > (left + right) / 2
			end
		end
	end

	local first, last = cells[1], cells[n]
	if first and first:GetLeft() and cursorX < first:GetLeft() then
		return 1, first, false
	end
	if last and last:GetRight() and cursorX > last:GetRight() then
		return n, last, true
	end
end

function WeeklyRewardsColumnReorderMixin:NormalizeRewardDropTarget(index, cell, after)
	if not index then
		return
	end

	local target = self:GetVisibleColumnAt(index)
	if target and target.reward then
		return index, cell, after, target
	end

	local firstIndex, lastIndex, firstReward, lastReward
	local i = 0
	self:ForEachColumn(function(column)
		i = i + 1
		if column.reward then
			if not firstIndex then
				firstIndex = i
				firstReward = column
			end
			lastIndex = i
			lastReward = column
		end
	end)
	if not firstIndex then
		return
	end

	local header = self.window.table.rows[1]
	if index >= lastIndex then
		return lastIndex, header.columns[lastIndex], true, lastReward
	end
	return firstIndex, header.columns[firstIndex], false, firstReward
end

function WeeklyRewardsColumnReorderMixin:UpdateColumnDropIndicator()
	local index, cell, after = self:NormalizeRewardDropTarget(self:GetHeaderDropTarget())
	local indicator = self:GetColumnDropIndicator()
	if not index or not cell or not self.columnDrag then
		indicator:Hide()
		return
	end

	local target = self:GetVisibleColumnAt(index)
	if not target or target.selectedIndex == self.columnDrag.index then
		indicator:Hide()
		return
	end

	indicator:ClearAllPoints()
	if after then
		indicator:SetPoint("TOP", cell, "TOPRIGHT", 0, 0)
		indicator:SetPoint("BOTTOM", cell, "BOTTOMRIGHT", 0, 0)
	else
		indicator:SetPoint("TOP", cell, "TOPLEFT", 0, 0)
		indicator:SetPoint("BOTTOM", cell, "BOTTOMLEFT", 0, 0)
	end
	indicator:Show()
end

function WeeklyRewardsColumnReorderMixin:HideColumnDragVisuals()
	if self.columnDragGhost then
		self.columnDragGhost:SetScript("OnUpdate", nil)
		self.columnDragGhost:Hide()
	end
	if self.columnDropIndicator then
		self.columnDropIndicator:Hide()
	end
	if self.columnDrag and self.columnDrag.frame then
		Utils:SetBackgroundColor(self.columnDrag.frame, 1, 1, 1, 0)
	end
	ResetCursor()
end

function WeeklyRewardsColumnReorderMixin:SetupColumnHeaderDrag(cellFrame)
	if cellFrame.columnDragSetup then
		return
	end
	cellFrame.columnDragSetup = true
	cellFrame:RegisterForDrag("LeftButton")
	cellFrame:SetScript("OnDragStart", function(frame)
		self:OnColumnDragStart(frame)
	end)
	cellFrame:SetScript("OnDragStop", function()
		self:OnColumnDragStop()
	end)
end

function WeeklyRewardsColumnReorderMixin:OnColumnDragStart(frame)
	local index = frame.selectedIndex
	if not index then
		return
	end

	self.didColumnDrag = true
	self.columnDrag = { index = index, frame = frame }
	GameTooltip:Hide()
	Utils:SetBackgroundColor(frame, 1, 1, 1, 0.15)
	SetCursor("Interface/CURSOR/openhandglow")

	local ghost = self:GetColumnDragGhost()
	ghost.text:SetText(frame.text and frame.text:GetText() or "")
	ghost:SetWidth(math.max(frame:GetWidth(), 60))
	ghost:SetHeight(frame:GetHeight())
	ghost:SetScale(self.window:GetScale())
	ghost:Show()
	ghost:SetScript("OnUpdate", function(g)
		local x, y = GetCursorPosition()
		local scale = g:GetEffectiveScale()
		g:ClearAllPoints()
		g:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale + 16, y / scale - 8)
		self:UpdateColumnDropIndicator()
	end)
end

function WeeklyRewardsColumnReorderMixin:OnColumnDragStop()
	local fromIndex = self.columnDrag and self.columnDrag.index
	local _, _, after, target = self:NormalizeRewardDropTarget(self:GetHeaderDropTarget())
	self:HideColumnDragVisuals()
	self.columnDrag = nil

	if not fromIndex or not target or not target.selectedIndex then
		return
	end

	local newIndex = after and (target.selectedIndex + 1) or target.selectedIndex
	if ActiveRewards.Get():MoveSelected(fromIndex, newIndex) then
		Util:Debug("Reordered column:", fromIndex, newIndex)
		ActiveRewards.Get().sortBy = nil
		self:Redraw()
	end
end

function WeeklyRewardsColumnReorderMixin:BindHeaderCell(cellFrame, column)
	cellFrame.selectedIndex = column.selectedIndex
	if column.reward then
		self:SetupColumnHeaderDrag(cellFrame)
	end
end

function WeeklyRewardsColumnReorderMixin:ConsumeColumnDragClick()
	if not self.didColumnDrag then
		return false
	end
	self.didColumnDrag = nil
	return true
end

function WeeklyRewardsColumnReorderMixin:WrapHeaderOnEnter(onEnter)
	return function(cellFrame)
		if self.columnDrag then
			return
		end
		if onEnter then
			onEnter(cellFrame)
		end
	end
end

function WeeklyRewardsColumnReorderMixin:AddColumnReorderHint(tooltip)
	tooltip:AddLine(GREEN_FONT_COLOR:WrapTextInColorCode(L["table_reorder_hint"]))
end
