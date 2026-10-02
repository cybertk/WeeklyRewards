local addonName, namespace = ...

local L = namespace.L

local Tips = {
	tipsShown = {},
}

function Tips:SetupVerticalScrollBarHelpTip(scrollBar)
	self:SetupFrameHelpTip(scrollBar, L["tips_scrollbar_vertical"], HelpTip.Point.TopEdgeCenter)
end

function Tips:SetupHorizontalScrollBarHelpTip(scrollBar)
	self:SetupFrameHelpTip(scrollBar, L["tips_scrollbar_horizontal"], HelpTip.Point.BottomEdgeCenter)
end

function Tips:SetupFrameHelpTip(frame, text, targetPoint)
	frame:HookScript("OnShow", function()
		if frame:IsVisible() then
			self:ShowHelpTip(text, targetPoint, frame)
		end
	end)
end

function Tips:SetOwner(owner)
	self.owner = owner
end

function Tips:ShowHelpTip(text, targetPoint, relativeRegion)
	if self.tipsShown[text] then
		return
	end

	self.tipsShown[text] = HelpTip:Show(self.owner, {
		text = text,
		buttonStyle = HelpTip.ButtonStyle.Close,
		targetPoint = targetPoint,
		alignment = HelpTip.Alignment.Center,
		autoEdgeFlipping = true,
		autoHorizontalSlide = true,
		autoHideWhenTargetHides = true,
	}, relativeRegion)
end

namespace.Tips = Tips
