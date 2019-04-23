local originalExoHUDUpdate = GUIExoHUD.Update
function GUIExoHUD:Update(deltaTime)
	originalExoHUDUpdate(self, deltaTime)

	local fullMode = Client.GetOptionInteger("hudmode", kHUDMode.Full) == kHUDMode.Full
	local mingui = not CHUDGetOption("mingui")

	if fullMode then
		self.innerRing:SetIsVisible(mingui)
		self.outerRing:SetIsVisible(mingui)
		self.leftInfoBar:SetIsVisible(mingui)
		self.rightInfoBar:SetIsVisible(mingui)
		self.staticRing:SetIsVisible(mingui)

		if not gCHUDHiddenViewModel then
			self.playerStatusIcons:SetIsVisible(mingui)
		end
	else
		self.playerStatusIcons:SetIsVisible(gCHUDHiddenViewModel)
	end
end