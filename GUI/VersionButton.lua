local addonName = ...

WeeklyRewardsVersionButtonMixin = {}

function WeeklyRewardsVersionButtonMixin:OnLoad()
	local version = C_AddOns.GetAddOnMetadata(addonName, "Version")

	self:SetText(version)

	self:SetScale(0.8)
	self:SetWidth(self:GetTextWidth())
end
