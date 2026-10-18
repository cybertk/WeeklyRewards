local _, namespace = ...

local Settings = namespace.Settings

local TableRowMixin = {}

local ROW_COLOR_ODD

function TableRowMixin:OnLoad() end

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

WeeklyRewardsTableDataRowMixin = TableDataRowMixin
