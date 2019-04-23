class 'CHUDGUI_HiddenViewmodel' (GUIScript)

local exoHUDSize

function CHUDGUI_HiddenViewmodel:Initialize()
	exoHUDSize = GUIScale(Vector(160, 160, 0))

	-- Set the texture to a temp one, avoids crash
	self.leftExo = GUIManager:CreateGraphicItem()
	self.leftExo:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
	self.leftExo:SetBlendTechnique(GUIItem.Add)
	self.leftExo:SetPosition(Vector(-exoHUDSize.x, -exoHUDSize.y, 0))
	self.leftExo:SetLayer(kGUILayerPlayerHUD)
	self.leftExo:SetIsVisible(false)
	
	-- Set the texture to a temp one, avoids crash
	self.rightExo = GUIManager:CreateGraphicItem()
	self.rightExo:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
	self.rightExo:SetBlendTechnique(GUIItem.Add)
	self.rightExo:SetPosition(Vector(exoHUDSize.x, -exoHUDSize.y, 0))
	self.rightExo:SetLayer(kGUILayerPlayerHUD)
	self.rightExo:SetIsVisible(false)
end

local lastLeft, lastRight, lastChange
function CHUDGUI_HiddenViewmodel:Update()
	local exoHUDScript = ClientUI.GetScript("Hud/Marine/GUIExoHUD")
	if exoHUDScript then
		local player = Client.GetLocalPlayer()
		local weapon = player:GetActiveWeapon()
		if weapon and weapon:isa("ExoWeaponHolder") then
			local leftWeapon = Shared.GetEntity(weapon.leftWeaponId)
			local rightWeapon = Shared.GetEntity(weapon.rightWeaponId)
			if lastLeft ~= leftWeapon or lastRight ~= rightWeapon then
				lastLeft = leftWeapon
				lastRight = rightWeapon
				lastChange = Shared.GetTime()
				self.leftExo:SetTexture("ui/transparent.dds")
				self.rightExo:SetTexture("ui/transparent.dds")
			end
			-- Delay creation to allow the HUD to be created (avoids crashes)
			if lastChange < Shared.GetTime() - 2.5 then
				lastChange = 0
				local leftVisible = leftWeapon:isa("Minigun") or leftWeapon:isa("Railgun")
				local rightVisible = rightWeapon:isa("Minigun") or rightWeapon:isa("Railgun")
				self.leftExo:SetIsVisible(leftVisible)
				self.rightExo:SetIsVisible(rightVisible)
				if leftVisible then
					self.leftExo:SetTexture(leftWeapon:isa("Minigun") and "*exo_minigun_left" or leftWeapon:isa("Railgun") and "*exo_railgun_left")
					self.leftExo:SetSize(Vector(-(leftWeapon:isa("Minigun") and exoHUDSize.x/2 or exoHUDSize.x),exoHUDSize.y,0))
				end
				if rightVisible then
					self.rightExo:SetTexture(rightWeapon:isa("Minigun") and "*exo_minigun_right" or rightWeapon:isa("Railgun") and "*exo_railgun_right")
					self.rightExo:SetSize(Vector(rightWeapon:isa("Minigun") and exoHUDSize.x/2 or exoHUDSize.x,exoHUDSize.y,0))
				end
			end
		end
	end
end

function CHUDGUI_HiddenViewmodel:OnResolutionChanged()
	self:Uninitialize()
	self:Initialize()
end

function CHUDGUI_HiddenViewmodel:Uninitialize()
	if self.fireIndicator then
		GUI.DestroyItem(self.fireIndicator)
		self.fireIndicator = nil
	end

	if self.leftIndicator then
		GUI.DestroyItem(self.leftIndicator)
		self.leftIndicator = nil
	end
	
	if self.umbraIndicator then
		GUI.DestroyItem(self.umbraIndicator)
		self.umbraIndicator = nil
	end
	
	if self.enzymeIndicator then
		GUI.DestroyItem(self.enzymeIndicator)
		self.enzymeIndicator = nil
	end
	
	if self.leftExo then
		GUI.DestroyItem(self.leftExo)
		self.leftExo = nil
	end
	
	if self.rightExo then
		GUI.DestroyItem(self.rightExo)
		self.rightExo = nil
	end
end

