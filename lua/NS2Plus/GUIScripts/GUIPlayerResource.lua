GUIPlayerResource.kRTCountSize = Vector(20, 40, 0)
GUIPlayerResource.kPixelWidth = 16
GUIPlayerResource.kPixelHeight = 32
local kRTCountTextures = { alien = PrecacheAsset("ui/alien_HUD_rtcount.dds"), marine = PrecacheAsset("ui/marine_HUD_rtcount.dds") }
GUIPlayerResource.kRTCountYOffset = -16
GUIPlayerResource.kRTCountTextOffset = Vector(460, 90, 0)

local oldInit = GUIPlayerResource.Initialize
function GUIPlayerResource:Initialize(style, teamNumber)
	oldInit(self, style, teamNumber)

	-- Team display.
	self.teamText = self.script:CreateAnimatedTextItem()
	self.teamText:SetAnchor(GUIItem.Left, GUIItem.Top)
	self.teamText:SetTextAlignmentX(GUIItem.Align_Min)
	self.teamText:SetTextAlignmentY(GUIItem.Align_Min)
	self.teamText:SetColor(style.textColor)
	self.teamText:SetBlendTechnique(GUIItem.Add)
	self.teamText:SetFontIsBold(true)
	self.teamText:SetFontName(GUIPlayerResource.kTresTextFontName)
	self.teamText:SetIsVisible(style.displayTeamRes)
	self.frame:AddChild(self.teamText)

	self.rtCount = GetGUIManager():CreateGraphicItem()
	self.rtCount:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
	self.rtCount:SetLayer(self.hudLayer + 2)
	self.rtCount:SetTexture(kRTCountTextures[style.textureSet])
	self.background:AddChild(self.rtCount)
end

local oldReset = GUIPlayerResource.Reset
function GUIPlayerResource:Reset(scale)
	oldReset(self, scale)

	self.teamText:SetScale(Vector(1,1,1) * self.scale * 1.2)
	self.teamText:SetScale(GetScaledVector())
	if self.teamNumber == kTeam1Index then
		self.teamText:SetPosition(GUIPlayerResource.kTeam1TextPos)
	else
		self.teamText:SetPosition(GUIPlayerResource.kTeam2TextPos)
	end
	self.teamText:SetFontName(GUIPlayerResource.kTresTextFontName)
	GUIMakeFontScale(self.teamText)
end

local oldUpdate = GUIPlayerResource.Update
function GUIPlayerResource:Update(_, parameters)
	oldUpdate(self, _, parameters)

	local rtcount = CHUDGetOption("rtcount")
	local topbar = CHUDGetOption("topbar")
	local showcomm = CHUDGetOption("showcomm")

	if showcomm and topbar > 0 then
		local tRes = parameters[1]
		self.teamText:SetText(string.format(Locale.ResolveString("TEAM_RES"), math.floor(tRes)))
		self.teamText:SetIsVisible(Client.GetHudDetail() == kHUDMode.Full)
	else
		self.teamText:SetIsVisible(false)
	end

	local numRTs = parameters[3]
	if rtcount == 1 then
		self.rtCount:SetIsVisible(false)
		self.pResDescription:SetText(string.format("%s (%d %s)",
				Locale.ResolveString("RESOURCES"),
				numRTs,
				ConditionalValue(numRTs == 1, "RT", "RTs")))
	elseif rtcount == 0 and numRTs > 0 then
		-- adjust rt count display
		local width = GUIPlayerResource.kRTCountSize.x * self.scale * numRTs
		local x1 = 0
		local x2 = numRTs * GUIPlayerResource.kPixelWidth
		local y1 = 0
		local y2 = GUIPlayerResource.kPixelHeight
		self.rtCount:SetTexturePixelCoordinates(x1, y1, x2, y2)
		self.rtCount:SetSize(Vector(width, GUIPlayerResource.kRTCountSize.y * self.scale, 0))
		self.rtCount:SetPosition(Vector(-width/2, GUIPlayerResource.kRTCountYOffset * self.scale, 0))
		self.rtCount:SetIsVisible(true)

		self.pResDescription:SetText(Locale.ResolveString("RESOURCES"))

	else -- rtcount == 2 and numRTs == 0 or rtcount == 0
		self.rtCount:SetIsVisible(false)
		self.pResDescription:SetText(Locale.ResolveString("RESOURCES"))
	end
end