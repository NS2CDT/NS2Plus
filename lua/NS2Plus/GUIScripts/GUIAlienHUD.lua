PrecacheAsset("ui/oma_alien_hud_health.dds")
PrecacheAsset("ui/rant_alien_hud_health.dds")
PrecacheAsset("ui/old_alien_hud_health.dds")
PrecacheAsset("ui/vanilla_alien_hud_health.dds")

function GUIAlienHUD:CHUDRepositionGUI()

	local gametime = CHUDGetOption("gametime")
	local realtime = CHUDGetOption("realtime")
	local biomass = ClientUI.GetScript("GUIBioMassDisplay")
	local mingui = CHUDGetOption("mingui")
	local topbar = CHUDGetOption("topbar")

	local y = 425

	if realtime and self.realTime then

		self.realTime:SetFontName(GUIMarineHUD.kTextFontName)
		self.realTime:SetTextAlignmentX(GUIItem.Align_Max)
		self.realTime:SetScale(GetScaledVector())
		self.realTime:SetPosition(Vector(Client.GetScreenWidth() - GUIScale(20), GUIScale(y), 0))
		GUIMakeFontScale(self.realTime)

		y = y - 25
	end

	if gametime and self.gameTime then

		self.gameTime:SetFontName(GUIMarineHUD.kTextFontName)
		self.gameTime:SetTextAlignmentX(GUIItem.Align_Max)
		self.gameTime:SetScale(GetScaledVector())
		self.gameTime:SetPosition(Vector(Client.GetScreenWidth() - GUIScale(20), GUIScale(y), 0))
		GUIMakeFontScale(self.gameTime)

		y = y - 25
	end

	if topbar > 0 then

		self.resourceDisplay.teamText:SetTextAlignmentX(GUIItem.Align_Max)
		self.resourceDisplay.teamText:SetIsScaling(false)
		self.resourceDisplay.teamText:SetPosition(Vector(Client.GetScreenWidth() - GUIScale(20), y, 0))
	end


	local biomassSmokeyBackground = ConditionalValue(mingui, "ui/transparent.dds", "ui/alien_commander_bg_smoke.dds")
	local biomassTexture = ConditionalValue(mingui, "ui/transparent.dds", "ui/biomass_bar.dds")
	local kBioMassBackgroundPos = GUIScale(Vector(20, 90, 0))
	local kSmokeyBackgroundPos = GUIScale(Vector(-100, 10, 0))

	biomass.smokeyBackground:SetAdditionalTexture("noise", biomassSmokeyBackground)
	biomass.smokeyBackground:SetPosition(kSmokeyBackgroundPos)
	biomass.background:SetTexture(biomassTexture)
	biomass.background:SetPosition(kBioMassBackgroundPos)
end

function GUIAlienHUD:OnLocalPlayerChanged()
	
	if Client.GetIsControllingPlayer() then
		Client.GetLocalPlayer():SetDarkVision(CHUDGetOption("avstate"))
	end

end

function GUIAlienHUD:InitializeCHUDAlienCircles()
	local aliencircles = CHUDGetOption("aliencircles")
	local kTextureNameCHUD = CHUDGetOptionAssocVal("aliencircles")

	self.healthBall:SetForegroundTexture(kTextureNameCHUD)
	self.armorBall:SetForegroundTexture(kTextureNameCHUD)
	self.energyBall:SetForegroundTexture(kTextureNameCHUD)
	self.adrenalineEnergy:SetForegroundTexture(kTextureNameCHUD)

	if aliencircles == 0 then return end -- vanilla circles

	local healthColor = ConditionalValue(aliencircles == 2, Color(1, 1, 1, 1), Color(230/255, 171/255, 46/255, 1))
	local armorColor = ConditionalValue(aliencircles == 2, Color(1, 1, 1, 1), Color(1, 121/255, 12/255, 1))
	local adrenalineColor = ConditionalValue(aliencircles == 2, Color(1, 1, 1, 1), Color(1, 121/255, 12/255, 1))
	local energyColor = ConditionalValue(aliencircles == 2, Color(1, 1, 1, 1), Color(230/255, 171/255, 46/255, 1))

	self.healthBall:GetLeftSide():SetColor(healthColor)
	self.healthBall:GetRightSide():SetColor(healthColor)

	self.armorBall:GetLeftSide():SetColor(armorColor)
	self.armorBall:GetRightSide():SetColor(armorColor)

	self.energyBall:GetLeftSide():SetColor(energyColor)
	self.energyBall:GetRightSide():SetColor(energyColor)

	self.adrenalineEnergy:GetLeftSide():SetColor(adrenalineColor)
	self.adrenalineEnergy:GetRightSide():SetColor(adrenalineColor)

	self.healthBall:GetLeftSide():SetTexturePixelCoordinates(0, 128, 64, 256)
	self.healthBall:GetRightSide():SetTexturePixelCoordinates(64, 128, 128, 256)

	if aliencircles == 1 or aliencircles == 3 then -- oma's or old vanilla circles
		self.armorBall:GetLeftSide():SetTexturePixelCoordinates(128, 0, 192, 128)
		self.armorBall:GetRightSide():SetTexturePixelCoordinates(192, 0, 256, 128)

		self.energyBall:GetLeftSide():SetTexturePixelCoordinates(0, 128, 64, 256)
		self.energyBall:GetRightSide():SetTexturePixelCoordinates(64, 128, 128, 256)

		self.adrenalineEnergy:GetLeftSide():SetTexturePixelCoordinates(128, 0, 192, 128)
		self.adrenalineEnergy:GetRightSide():SetTexturePixelCoordinates(192, 0, 256, 128)
	else -- rant's circles
		self.armorBall:GetLeftSide():SetTexturePixelCoordinates(0, 0, 64, 128)
		self.armorBall:GetRightSide():SetTexturePixelCoordinates(64, 0, 128, 128)

		self.energyBall:GetLeftSide():SetTexturePixelCoordinates(128, 128, 192, 256)
		self.energyBall:GetRightSide():SetTexturePixelCoordinates(192, 128, 256, 256)

		self.adrenalineEnergy:GetLeftSide():SetTexturePixelCoordinates(128, 0, 192, 128)
		self.adrenalineEnergy:GetRightSide():SetTexturePixelCoordinates(192, 0, 256, 128)
	end
end

local originalAlienInit = GUIAlienHUD.Initialize
function GUIAlienHUD:Initialize()
	local mingui = not CHUDGetOption("mingui")

	originalAlienInit(self)

	self.gameTime = self:CreateAnimatedTextItem()
	self.gameTime:SetFontName(GUIMarineHUD.kTextFontName)
	self.gameTime:SetFontIsBold(true)
	self.gameTime:SetLayer(kGUILayerPlayerHUDForeground2)
	self.gameTime:SetColor(kAlienTeamColorFloat)
	self.gameTime:SetIsScaling(false)

	self.realTime = self:CreateAnimatedTextItem()
	self.realTime:SetFontName(GUIMarineHUD.kTextFontName)
	self.realTime:SetFontIsBold(true)
	self.realTime:SetLayer(kGUILayerPlayerHUDForeground2)
	self.realTime:SetColor(kAlienTeamColorFloat)
	self.realTime:SetIsScaling(false)

	local kBackgroundCHUD = ConditionalValue(mingui, PrecacheAsset("ui/alien_commander_bg_smoke.dds"), PrecacheAsset("ui/transparent.dds"))

	-- Backgrounds of health/energy
	self.healthBall.dialBackground:SetAdditionalTexture("noise", kBackgroundCHUD)
	self.energyBall.dialBackground:SetAdditionalTexture("noise", kBackgroundCHUD)
	self.secondaryAbilityBackground:SetAdditionalTexture("noise", kBackgroundCHUD)

	-- Alien bars
	self:InitializeCHUDAlienCircles()

	if mingui then
		self.resourceDisplay.background:SetColor(Color(1,1,1,0))
	else
		self.resourceDisplay.background:SetColor(Color(1,1,1,1))
	end

	Client.DestroyScreenEffect(Player.screenEffects.darkVision)
	Client.DestroyScreenEffect(HiveVision_screenEffect)
	Client.DestroyScreenEffect(HiveVisionExtra_screenEffect)
	HiveVision_screenEffect = Client.CreateScreenEffect("shaders/HiveVision.screenfx")
	HiveVisionExtra_screenEffect = Client.CreateScreenEffect("shaders/HiveVisionExtra.screenfx")
	Player.screenEffects.darkVision = Client.CreateScreenEffect(CHUDGetOptionAssocVal("av"))

	-- Cr4zyAV config options
	if CHUDGetOption("av") == 5 then
		updateAlienVision()
	end

	if CHUDGetOption("hudbars_a") > 0 then
		if CHUDGetOption("hudbars_a") == 2 then
			self.resourceDisplay.background:SetPosition(Vector(-440, -100, 0))
		end

		local healthBall = self.healthBall:GetBackground()
		local energyBall = self.energyBall:GetBackground()
		local healthBallPos = healthBall:GetPosition()
		local energyBallPos = energyBall:GetPosition()
		self.healthBall.leftSide:SetIsVisible(false)
		self.healthBall.rightSide:SetIsVisible(false)
		self.energyBall.leftSide:SetIsVisible(false)
		self.energyBall.rightSide:SetIsVisible(false)
		self.adrenalineEnergy:SetIsVisible(false)

		if CHUDGetOption("hudbars_a") == 2 then
			healthBall:SetPosition(Vector(healthBallPos.x+50, healthBallPos.y, 0))
			energyBall:SetPosition(Vector(energyBallPos.x-50, energyBallPos.y, 0))
			self.secondaryAbilityBackground:SetPosition(Vector(-50, -125, 0))
		end
	end

	self.gorgeBuiltText = GUIManager:CreateTextItem()
	self.gorgeBuiltText:SetFontName(Fonts.kStamp_Large)
	self.gorgeBuiltText:SetScale(GetScaledVector())
	self.gorgeBuiltText:SetAnchor(GUIItem.Middle, GUIItem.Center)
	self.gorgeBuiltText:SetTextAlignmentX(GUIItem.Align_Center)
	self.gorgeBuiltText:SetTextAlignmentY(GUIItem.Align_Center)
	self.gorgeBuiltText:SetColor(kAlienFontColor)
	self.gorgeBuiltText:SetInheritsParentAlpha(true)
	self.gorgeBuiltText:SetIsVisible(false)

	self.energyBall:GetBackground():AddChild(self.gorgeBuiltText)

	self:CHUDRepositionGUI()
end


function GUIAlienHUD:CHUDUpdateHealthBall(deltaTime)
	local healthBarPercentageGoal = PlayerUI_GetPlayerHealth() / PlayerUI_GetPlayerMaxHealth()
	self.healthBarPercentage = healthBarPercentageGoal

	local maxArmor = PlayerUI_GetPlayerMaxArmor()

	if not (maxArmor == 0) then
		local armorBarPercentageGoal = PlayerUI_GetPlayerArmor() / maxArmor
		self.armorBarPercentage = armorBarPercentageGoal
	end

	-- don't use more than 60% for armor in case armor value is bigger than health
	-- for skulk use 10 / 70 = 14% as armor and 86% as health
	local armorUseFraction = Clamp( PlayerUI_GetPlayerMaxArmor() / PlayerUI_GetPlayerMaxHealth(), 0, 0.6)
	local healthUseFraction = 1 - armorUseFraction

	-- set global rotation to snap to the health ring
	self.armorBall:SetRotation( - 2 * math.pi * self.healthBarPercentage * healthUseFraction )

	self.healthBall:SetPercentage(self.healthBarPercentage * healthUseFraction)
	self.armorBall:SetPercentage(self.armorBarPercentage * armorUseFraction)

	self:UpdateFading(self.healthBall:GetBackground(), self.healthBarPercentage * self.armorBarPercentage, deltaTime)
end

local originalAlienSetIsVisible = GUIAlienHUD.SetIsVisible
function GUIAlienHUD:SetIsVisible(state)
	originalAlienSetIsVisible(self, state)

	if self.gameTime then
		self.gameTime:SetIsVisible(state)
	end

	if self.realTime then
		self.realTime:SetIsVisible(state)
	end

end

local originalAlienUpdate = GUIAlienHUD.Update
function GUIAlienHUD:Update(deltaTime)
	originalAlienUpdate(self, deltaTime)

	--local rtcount = CHUDGetOption("rtcount")
	local gametime = CHUDGetOption("gametime")
	local realtime = CHUDGetOption("realtime")
	local instanthealth = CHUDGetOption("instantalienhealth")
	local unlocks = CHUDGetOption("unlocks")
	local alienHudBars = CHUDGetOption("hudbars_a")

	if self.eventDisplay then
		self.eventDisplay.notificationFrame:SetIsVisible(unlocks)
	end

	if instanthealth then
		self:CHUDUpdateHealthBall(deltaTime)
	end

	if self.gameTime then
		self.gameTime:SetText(CHUDGetGameTimeString())
		self.gameTime:SetIsVisible(gametime and self.visible)
	end
	
	if self.realTime then
		self.realTime:SetText(CHUDGetRealTimeString())
		self.realTime:SetIsVisible(realtime and self.visible)
	end

	local aliencircles = CHUDGetOption("aliencircles")
	local energyColor = Color(1, 1, 1, 1)

	if aliencircles == 2 and self.energyBall:GetBackground():GetColor() ~= Color(0.6, 0, 0, 1) then
		self.energyBall:GetLeftSide():SetColor(energyColor)
		self.energyBall:GetRightSide():SetColor(energyColor)
	end

	self.armorBall:SetIsVisible(self.healthBall:GetBackground():GetIsVisible() and CHUDGetOption("hudbars_a") == 0)

	if self.mucousBall and alienHudBars ~= 0 then
		self.mucousBall:SetIsVisible(false)
	end

	local player = Client.GetLocalPlayer()
	local gorgeBuiltTextVisible = false
	if player and player:isa("Gorge") and GUIGorgeBuildMenu then
		local activeWeapon = player:GetActiveWeapon()
		if activeWeapon and activeWeapon:isa("DropStructureAbility") then
			local dropStructureAbility = player:GetWeapon(DropStructureAbility.kMapName)
			if dropStructureAbility then
				local structure = dropStructureAbility:GetActiveStructure()
				local structureId = structure and structure:GetDropStructureId() or -1
				local maxStructures = GorgeBuild_GetMaxNumStructure(structureId)
				local numBuilt = dropStructureAbility:GetNumStructuresBuilt(structureId)

				gorgeBuiltTextVisible = structureId ~= -1
				if gorgeBuiltTextVisible then
					self.gorgeBuiltText:SetText(numBuilt .. "/" .. maxStructures)
					self.gorgeBuiltText:SetColor(GorgeBuild_GetCanAffordAbility(structureId) and kAlienFontColor or kRed)
				end
			end
		end
	end
	self.gorgeBuiltText:SetIsVisible(gorgeBuiltTextVisible)
	self.activeAbilityIcon:SetIsVisible(not gorgeBuiltTextVisible)

	if Client.GetOptionInteger("hudmode", kHUDMode.Full) ~= kHUDMode.Full then
		self.statusDisplays:SetIsVisible(gCHUDHiddenViewModel)
	end

	if alienHudBars > 0 then
		self.adrenalineEnergy:SetIsVisible(false)
	end

end
	
local originalAlienReset = GUIAlienHUD.Reset
function GUIAlienHUD:Reset()
	originalAlienReset(self)

	self:CHUDRepositionGUI()
end

local originalAlienUninit = GUIAlienHUD.Uninitialize
function GUIAlienHUD:Uninitialize()
	originalAlienUninit(self)

	GUI.DestroyItem(self.gameTime)
	self.gameTime = nil
	
	GUI.DestroyItem(self.realTime)
	self.realTime = nil
end

function updateAlienVision()
	local useShader = Player.screenEffects.darkVision
	local av_edgesize = CHUDGetOption("av_edgesize") / 1000

	--to save on shader parameters (because theres a limit) bitshift values into a single var
	local av_bitshift_combine = math.abs(bit.lshift(CHUDGetOption("av_playercolor"), 22) +
									   bit.lshift(CHUDGetOption("av_edgeclean"), 20) +
									   bit.lshift(CHUDGetOption("av_nanoshield"), 18) +
									   bit.lshift(CHUDGetOption("av_style"), 16) +
									   bit.lshift(CHUDGetOption("av_gorgeunique"), 14) +
									   bit.lshift(CHUDGetOption("av_offstyle"), 12) +
									   bit.lshift(CHUDGetOption("av_edges"), 10) +
									   bit.lshift(CHUDGetOption("av_structurecolor"), 8) +
									   bit.lshift(CHUDGetOption("av_desaturation"), 6) +
									   bit.lshift(CHUDGetOption("av_viewmodelstyle"), 4) +
									   bit.lshift(CHUDGetOption("av_skybox"), 2) +
									   bit.lshift(CHUDGetOption("av_activationeffect"), 0)
								)
	--bitshifted var
	useShader:SetParameter("avCombined", av_bitshift_combine)

	--world colors
	--close colours
	useShader:SetParameter("worldCloseRGBInt", CHUDGetOption("av_closecolor"))
	useShader:SetParameter("closeIntensity", CHUDGetOption("av_closeintensity"))

	--distant colours
	useShader:SetParameter("worldFarRGBInt", CHUDGetOption("av_distantcolor"))
	useShader:SetParameter("distantIntensity", CHUDGetOption("av_distantintensity"))

	-- new 329+ marine/alien/gorge/structure colors
	useShader:SetParameter("marineRGBInt", CHUDGetOption("av_colormarine"))
	useShader:SetParameter("marineIntensity", CHUDGetOption("av_marineintensity"))

	useShader:SetParameter("alienRGBInt", CHUDGetOption("av_coloralien"))
	useShader:SetParameter("alienIntensity", CHUDGetOption("av_alienintensity"))

	useShader:SetParameter("gorgeRGBInt", CHUDGetOption("av_colorgorge"))
	useShader:SetParameter("gorgeIntensity", CHUDGetOption("av_gorgeintensity"))

	useShader:SetParameter("mStructRGBInt", CHUDGetOption("av_colormarinestruct"))
	useShader:SetParameter("mStructIntensity", CHUDGetOption("av_mstructintensity"))

	useShader:SetParameter("aStructRGBInt", CHUDGetOption("av_coloralienstruct"))
	useShader:SetParameter("aStructIntensity", CHUDGetOption("av_astructintensity"))

	--edge values
	useShader:SetParameter("edgeSize", av_edgesize)

	--world values
	useShader:SetParameter("desatIntensity", CHUDGetOption("av_desaturationintensity"))
	useShader:SetParameter("avDesatBlend", CHUDGetOption("av_desaturationblend"))
	useShader:SetParameter("avWorldIntensity", CHUDGetOption("av_worldintensity"))
	useShader:SetParameter("avBlend", CHUDGetOption("av_blenddistance"))

	--viewmodel
	useShader:SetParameter("avViewModel", CHUDGetOption("av_viewmodelintensity"))
end