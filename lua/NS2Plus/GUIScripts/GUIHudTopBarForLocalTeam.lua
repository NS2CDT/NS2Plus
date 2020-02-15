local oldInitialize = GUIHudTopBarForLocalTeam.Initialize
function GUIHudTopBarForLocalTeam:Initialize(params, errorDepth)
	oldInitialize(self, params, errorDepth)

	self:UpdateCHUDVisibility()
end

local oldOnUpdate = GUIHudTopBarForLocalTeam.OnUpdate
function GUIHudTopBarForLocalTeam:OnUpdate(deltaTime, now)
	if not self.CHUDVisibility then return end

	oldOnUpdate(self, deltaTime, now)
end

function GUIHudTopBarForLocalTeam:UpdateCHUDVisibility()
	local topbar = CHUDGetOption("topbar")
	self.CHUDVisibility = topbar < 2
	if topbar == 1 then
		local player = Client.GetLocalPlayer()
		self.CHUDVisibility = player and player:isa("Commander")
	end

	self:SetVisible(self.CHUDVisibility)
end