local function CHUDRestartScripts(scripts)

	for _, currentScript in pairs(scripts) do
		local script = ClientUI.GetScript(currentScript)
		if script then
			script:Uninitialize()
			script:Initialize()
		end
	end
	
end

local uiScaleTime = 0
local function CHUDApplyNewUIScale()
	uiScaleTime = Shared.GetTime()
end

local function CheckUIScaleTime()
	if uiScaleTime ~= 0 and uiScaleTime + 1 < Shared.GetTime() then
		local xRes = Client.GetScreenWidth()
		local yRes = Client.GetScreenHeight()
		GetGUIManager():OnResolutionChanged(xRes, yRes, xRes, yRes)
		uiScaleTime = 0
	end
end

Event.Hook("UpdateRender", CheckUIScaleTime)

CHUDOptions =
{
			mingui = {
				name = "CHUD_MinGUI",
				label = "Minimal GUI",
				tooltip = "Removes backgrounds/scanlines from all UI elements.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "ui",
				valueType = "bool",
				applyFunction = function() CHUDRestartScripts({
					"Hud/Marine/GUIMarineHUD",
					"GUIAlienHUD",
					}) end,
				sort = "A01",
			},
			rtcount = {
				name = "CHUD_RTcount",
				label = "RT count dots",
				tooltip = "Toggles the RT count dots at the bottom and replaces them with a number.",
				type = "select",
				values  = { "Number", "Dots" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				helpImage = "ui/helpImages/rtcount.dds",
				helpImageSize = Vector(256, 128, 0),
				sort = "A02",
			},
			showcomm = {
				name = "CHUD_CommName",
				label = "Comm name/Team res",
				tooltip = "Enables or disables showing the commander name and team resources.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				sort = "A03",
				applyFunction = function() CHUDRestartScripts({
					"Hud/Marine/GUIMarineHUD",
					"GUIAlienHUD",
					}) end,
			},
			gametime = {
				name = "CHUD_Gametime",
				label = "Game time",
				tooltip = "Adds or removes the game time on the top left of the HUD.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				sort = "A04",
				applyFunction = function() CHUDRestartScripts({
					"Hud/Marine/GUIMarineHUD",
					"GUIAlienHUD",
					}) end,
			},
			crosshairscale = {
				name = "CHUD_CrosshairScale",
				label = "Crosshair scale",
				tooltip = "Lets you increase or decrease the size of your crosshair.",
				type = "slider",
				defaultValue = 1,
				minValue = 0.01,
				maxValue = 2,
				multiplier = 100,
				category = "ui",
				valueType = "float",
				applyFunction = function()
					CHUDRestartScripts({ "GUICrosshair" })
					if GetGUIManager and GetGUIManager():GetGUIScriptSingle("NS2Plus/Client/CHUDGUI_HUDBars") then
						GetGUIManager():GetGUIScriptSingle("NS2Plus/Client/CHUDGUI_HUDBars"):Reset()
					end
				end,
				sort = "A05",
			},
			banners = {
				name = "CHUD_Banners",
				label = "Objective banners",
				tooltip = "Enables or disables the banners in the center of the screen (\"Commander needed\", \"Power node under attack\", \"Evolution lost\", etc.).",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				sort = "A06",
			},
			unlocks = {
				name = "CHUD_Unlocks",
				label = "Research notifications",
				tooltip = "Enables or disables the research completed notifications on the right side of the screen.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				sort = "A07",
			},
			inventory = {
				name = "CHUD_Inventory",
				label = "Weapon Inventory",
				tooltip = "Lets you customize the functionality of the inventory.",
				type = "select",
				values  = { "Default", "Hide", "Show ammo", "Always on", "Always on + ammo" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function() CHUDRestartScripts({
					"Hud/Marine/GUIMarineHUD",
					"GUIAlienHUD",
					"GUIProgressBar",
					}) end,
				helpImage = "ui/helpImages/inventory.dds",
				helpImageSize = Vector(256, 128, 0),
				sort = "A08",
			},
			
			minimap = {
				name = "CHUD_Minimap",
				label = "Marine minimap",
				tooltip = "Enables or disables the minimap and location name.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				sort = "B01",
				applyFunction = function() CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD" }) end,
			},
			commactions = {
				name = "CHUD_CommActions",
				label = "Marine comm actions",
				tooltip = "Shows or hides the last commander actions.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				sort = "B02",
				applyFunction = function() CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD" }) end,
			},
			hpbar = {
				name = "CHUD_HPBar",
				label = "Marine health bars",
				tooltip = "Enables or disables the health bars from the bottom left of the marine HUD and only leaves the numbers.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				applyFunction = function() CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD" }) end,
				sort = "B03",
			},
			uplvl = {
				name = "CHUD_UpgradeLevel",
				label = "Upgrade level UI",
				tooltip = "Changes between disabled, default or old icons for marine upgrades.",
				type = "select",
				values  = { "Disabled", "Default", "NS2 Beta" },
				defaultValue = 1,
				category = "ui",
				valueType = "int",
				applyFunction = function()
					CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD" })
				end,
				helpImage = "ui/helpImages/uplvl.dds",
				helpImageSize = Vector(160, 128, 0),
				sort = "B04",
			},
			welderup = {
				name = "CHUD_WelderUp",
				label = "Show welder as upgrade",
				tooltip = "When you have a welder it shows up under the armor and weapon level.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				helpImage = "ui/helpImages/welderup.dds",
				helpImageSize = Vector(160, 160, 0),
				sort = "B05",
				resetSettingInBuild = 262,
			},
			classicammo = {
				name = "CHUD_ClassicAmmo",
				label = "Classic ammo counter",
				tooltip = "Enables or disables a classic ammo counter on the bottom right of the marine HUD, above the personal resources text.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "ui",
				valueType = "bool",
				applyFunction = function()
					CHUDEvaluateGUIVis()
				end,
				sort = "B06",
			},
			lowammowarning = {
				name = "CHUD_LowAmmoWarning",
				label = "Low ammo warning",
				tooltip = "Enables or disables the low ammo warning in the weapon displays.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = true,
				category = "ui",
				valueType = "bool",
				helpImage = "ui/helpImages/lowammowarning.dds",
				helpImageSize = Vector(128, 128, 0),
				sort = "B07",
			},
			hudbars_m = {
				name = "CHUD_CustomHUD_M",
				label = "HUD bars (Marine)",
				tooltip = "HL2 Style displays health/armor and ammo next to the crosshair. NS1 Style puts big bars at the bottom on each side.",
				type = "select",
				values  = { "Disabled", "HL2 Style", "NS1 Style" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function()
					local classicammoScript = "NS2Plus/Client/CHUDGUI_ClassicAmmo"
					local hudbarsScript = "NS2Plus/Client/CHUDGUI_HUDBars"
					if GetGUIManager():GetGUIScriptSingle(hudbarsScript) then
						GetGUIManager():DestroyGUIScriptSingle(hudbarsScript)
					end
					if GetGUIManager():GetGUIScriptSingle(classicammoScript) then
						GetGUIManager():DestroyGUIScriptSingle(classicammoScript)
					end
					CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD", "GUIJetpackFuel" })
					CHUDEvaluateGUIVis()
				end,
				sort = "B08",
			},
			
			hudbars_a = {
				name = "CHUD_CustomHUD_A",
				label = "HUD bars (Alien)",
				tooltip = "HL2 Style displays health/armor and ammo next to the crosshair. NS1 Style puts big bars at the bottom on each side.",
				type = "select",
				values  = { "Disabled", "HL2 Style", "NS1 Style" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function()
					local hudbarsScript = "NS2Plus/Client/CHUDGUI_HUDBars"
					if GetGUIManager():GetGUIScriptSingle(hudbarsScript) then
						GetGUIManager():DestroyGUIScriptSingle(hudbarsScript)
					end
					CHUDRestartScripts({ "GUIAlienHUD" })
					CHUDEvaluateGUIVis()
				end,
				sort = "C01",
			},
			aliencircles = {
				name = "CHUD_AlienBars",
				label = "Alien circles",
				tooltip = "Lets you choose between different alien energy/health circles.",
				type = "select",
				values  = { "Default", "Oma", "Rantology" },
				valueTable  = { "ui/alien_hud_health.dds", "ui/oma_alien_hud_health.dds", "ui/rant_alien_hud_health.dds" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				helpImage = "ui/helpImages/aliencircles.dds",
				helpImageSize = Vector(192, 120, 0),
				sort = "C02",
			},
			instantalienhealth = {
				name = "CHUD_InstantAlienHealth",
				label = "Instant Alien Health Bar",
				tooltip = "The alien health circle displays the current value instead of using animations when health changes.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "ui",
				valueType = "bool",
				sort = "C03"
			},
			
			avstate = { 
				name = "CHUD_AVState",
				label = "Default AV state",
				tooltip = "Sets the state the alien vision will be in when you respawn.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "ui",
				valueType = "bool",
				sort = "C04",
			},
			av = {
				name = "CHUD_AV",
				label = "Alien vision",
				tooltip = "Lets you choose between different Alien Vision types.",
				type = "select",
				values  = { "Default", "Huze's Old AV", "Huze's Minimal AV", "Uke's AV", "Old AV (Fanta)", "Cr4zyAV Configurable" },
				valueTable = {
					"shaders/DarkVision.screenfx",
					"shaders/HuzeOldAV.screenfx",
					"shaders/HuzeMinAV.screenfx",
					"shaders/UkeAV.screenfx",
					"shaders/FantaVision.screenfx",
					"shaders/Cr4zyAV.screenfx",
				},
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				children = { "av_style", "av_offstyle", "av_closecolor", "av_closeintensity", "av_distantcolor", "av_distantintensity", "av_fogcolor", "av_fogintensity", "av_edges", "av_edgesize", "av_desaturation", "av_desaturationintensity" },
				hideValues = { 0, 1, 2, 3, 4 },
				sort = "C05",
				resetSettingInBuild = 237,
			},
			av_style = { 
				name = "CHUD_AVStyle",
				label = "Alien Vision Style",
				tooltip = "Switches between different configurable styles of Alien Vision.",
				type = "select",
				values  = { "Minimal", "Original", "Depth Fog" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				helpImage = "ui/helpImages/av_style.dds",
				helpImageSize = Vector(400, 256, 0),
				children = { "av_fogcolor", "av_fogintensity" },
				hideValues = { 0 },
				sort = "C06",
			},
			av_offstyle = { 
				name = "CHUD_AVOffStyle",
				label = "Alien Vision Disabled Style",
				tooltip = "Switches between different options for when Alien Vision is disabled.",
				type = "select",
				values  = { "Nothing", "Minimal world edges", "Coloured edges" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				helpImage = "ui/helpImages/av_offstyle.dds",
				helpImageSize = Vector(400, 256, 0),
				sort = "C07",
			},
			av_closecolor = {
				name = "CHUD_AVCloseColor",
				label = "Alien Vision close color",
				tooltip = "Sets the close color in Alien Vision.",
				defaultValue = 0x0030FE,
				category = "ui",
				valueType = "color",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C08",
				resetSettingInBuild = 237,
			},
			av_closeintensity = { 
				name = "CHUD_AVCloseIntensity",
				label = "Close Color Intensity",
				tooltip = "Sets the 'brightness' value of the Close Color.",
				type = "slider",
				defaultValue = 1.0,
				minValue = -0.1,
				maxValue = 2.0,
				category = "ui",
				valueType = "float",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C09",
			},
			av_distantcolor = {
				name = "CHUD_AVDistantColor",
				label = "Alien Vision distant color",
				tooltip = "Sets the distant color in Alien Vision.",
				defaultValue = 0x00FF00,
				category = "ui",
				valueType = "color",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C10",
			},
			av_distantintensity = { 
				name = "CHUD_AVDistantIntensity",
				label = "Distant Color Intensity",
				tooltip = "Sets the 'brightness' value of the Distant Color.",
				type = "slider",
				defaultValue = 1.0,
				minValue = -0.1,
				maxValue = 2.0,
				category = "ui",
				valueType = "float",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C11",
			},
			av_fogcolor = {
				name = "CHUD_AVFogColor",
				label = "Alien Vision tint color",
				tooltip = "Depending on mode sets either fog colour or model colour in old mode.",
				defaultValue = 0x140228,
				category = "ui",
				valueType = "color",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C12",
			},
			av_fogintensity = { 
				name = "CHUD_AVFogIntensity",
				label = "Tint Color Intensity",
				tooltip = "Sets the 'brightness' value of the Tint Color.",
				type = "slider",
				defaultValue = 1.0,
				minValue = -0.1,
				maxValue = 2.0,
				category = "ui",
				valueType = "float",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C13",
			},
			av_edges = { 
				name = "CHUD_AVEdges",
				label = "Alien Vision Edges",
				tooltip = "Switches between edge outlines that are uniform in size or ones that thicken in peripheral vision.",
				type = "select",
				values  = { "Normal", "Thicker Peripheral Edges" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C14",
				resetSettingInBuild = 237,
			},
			av_edgesize = { 
				name = "CHUD_AVEdgeSize",
				label = "Alien Vision Edge thickness",
				tooltip = "Sets the thickness of edges in alien vision.",
				type = "slider",
				defaultValue = 0.4,
				minValue = 0.0,
				maxValue = 2.0,
				category = "ui",
				valueType = "float",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C15",
			},	
			av_desaturation = { 
				name = "CHUD_AVDesaturation",
				label = "Alien Vision Desaturation",
				tooltip = "Switches between different types of desaturation.",
				type = "select",
				values  = { "None", "Full Scene", "Desaturate Distance" },
				defaultValue = 0,
				category = "ui",
				valueType = "int",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				helpImage = "ui/helpImages/av_desat.dds",
				helpImageSize = Vector(400, 256, 0),
				sort = "C16",
				resetSettingInBuild = 237,
			},
			av_desaturationintensity = { 
				name = "CHUD_AVDesaturationIntensity",
				label = "Desaturation Intensity",
				tooltip = "Sets the desaturation amount.",
				type = "slider",
				defaultValue = 0.25,
				minValue = 0.0,
				maxValue = 1.0,
				category = "ui",
				valueType = "float",
				applyFunction = function() CHUDRestartScripts({ "GUIAlienHUD" }) end,
				sort = "C17",
			},
			
			
			
			
			killfeedhighlight = {
				name = "CHUD_KillFeedHighlight",
				label = "Killfeed highlight",
				tooltip = "Enables or disables the border for your player kills in the killfeed.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = 1,
				category = "hud",
				valueType = "int",
				applyFunction = function()
					CHUDRestartScripts({ "GUIDeathMessages" })
				end,
				sort = "A01",
			},
			killfeedcolorcustom = {
				name = "CHUD_KillFeedHighlightColorCustom",
				label = "Use custom killfeed highlight color",
				tooltip = "Lets you choose the color of the highlight border for your kills in the killfeed.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = false,
				category = "hud",
				valueType = "bool",
				hideValues = { false },
				children = { "killfeedcolor" },
				applyFunction = function()
					CHUDRestartScripts({ "GUIDeathMessages" })
				end,
				sort = "A02",
			},
			killfeedcolor = {
				name = "CHUD_KillFeedHighlightColor",
				label = "Killfeed highlight color",
				tooltip = "Chooses the color of the highlight border for your kills in the killfeed.",
				defaultValue = 0xFF0000,
				category = "hud",
				valueType = "color",
				applyFunction = function()
					CHUDRestartScripts({ "GUIDeathMessages" })
				end,
				sort = "A03",
				resetSettingInBuild = 265,
			},
			killfeedscale = {
				name = "CHUD_KillFeedScale",
				label = "Killfeed scale",
				tooltip = "Lets you scale the killfeed.",
				type = "slider",
				defaultValue = 1,
				minValue = 1,
				maxValue = 2,
				multiplier = 100,
				category = "hud",
				valueType = "float",
				applyFunction = function()
					CHUDRestartScripts({ "GUIDeathMessages" })
				end,
				sort = "A04",
			},
			killfeediconscale = {
				name = "CHUD_KillFeedIconScale",
				label = "Killfeed icon scale",
				tooltip = "Lets you scale the size of the icons in the killfeed.",
				type = "slider",
				defaultValue = 1,
				minValue = 1,
				maxValue = 2,
				multiplier = 100,
				category = "hud",
				valueType = "float",
				applyFunction = function()
					CHUDRestartScripts({ "GUIDeathMessages" })
				end,
				sort = "A05",
			},
			nameplates = {
				name = "CHUD_Nameplates",
				label = "Nameplate style",
				tooltip = "Changes building names and health/armor bars for teammates and structures.",
				type = "select",
				values  = { "Default", "Percentages", "Bars only", "Percentages + Bars" },
				defaultValue = 0,
				category = "hud",
				valueType = "int",
				helpImage = "ui/helpImages/nameplates.dds",
				helpImageSize = Vector(360, 96, 0),
				sort = "A06",
			},
			smallnps = {
				name = "CHUD_SmallNameplates",
				label = "Small nameplates",
				tooltip = "Makes fonts in the nameplates smaller.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "hud",
				valueType = "bool",
				applyFunction = function() CHUDRestartScripts({ "GUIUnitStatus" }) end,
				sort = "A07",
			},
			nameplatesdistance = {
				name = "CHUD_Nameplates_Distance",
				label = "Nameplates Distance",
				tooltip = "Chooses how far away, in meters, the nameplates render (ie. when aiming at a building to check its health). This includes teammate names while not aiming at them. High values will decrease performance.",
				type = "slider",
				defaultValue = 13,
				minValue = 5,
				maxValue = 30,
				category = "hud",
				valueType = "float",
				sort = "A08",
			},
			score = {
				name = "CHUD_ScorePopup",
				label = "Score popup",
				tooltip = "Disables or enables score popup (+5).",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "hud",
				valueType = "bool",
				children = { "scorecolor" },
				hideValues = { false },
				sort = "A09",
			},
			scorecolor = {
				name = "CHUD_ScorePopupColor",
				label = "Score popup color",
				tooltip = "Changes the color of the score popup.",
				defaultValue = 0x19FF19,
				category = "hud",
				valueType = "color",
				applyFunction = function()
					GUINotifications.kScoreDisplayKillTextColor = ColorIntToColor(CHUDGetOption("scorecolor"))
				end,
				sort = "A10",
				resetSettingInBuild = 264,
			},
			assists = {
				name = "CHUD_Assists",
				label = "Assist score popup",
				tooltip = "Disables or enables the assists score popup.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "hud",
				valueType = "bool",
				children = { "assistscolor" },
				hideValues = { false },
				sort = "A11",
			},
			assistscolor = {
				name = "CHUD_AssistsPopupColor",
				label = "Assists popup color",
				tooltip = "Changes the color of the assists popup.",
				defaultValue = 0xBFBF19,
				category = "hud",
				valueType = "color",
				applyFunction = function()
					GUINotifications.kScoreDisplayTextColor = ColorIntToColor(CHUDGetOption("assistscolor"))
				end,
				sort = "A12",
				resetSettingInBuild = 264,
			},
			wps = {
				name = "CHUD_Waypoints",
				label = "Waypoints",
				tooltip = "Disables or enables all waypoints except Attack orders (waypoints can still be seen on minimap).",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "hud",
				valueType = "bool",
				sort = "A13",
			},
			minwps = {
				name = "CHUD_MinWaypoints",
				label = "Minimal waypoints",
				tooltip = "Toggles all text/backgrounds and only leaves the waypoint icon.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "hud",
				valueType = "bool",
				helpImage = "ui/helpImages/minwps.dds",
				helpImageSize = Vector(150, 100, 0),
				sort = "A14",
			},
			autowps = { 
				name = "CHUD_AutoWPs",
				label = "Automatic waypoints",
				tooltip = "Enables or disables automatic waypoints (not given by the commander).",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "hud",
				valueType = "bool",
				sort = "A15",
			},
			pickupexpire = { 
				name = "CHUD_PickupExpire",
				label = "Pickup expiration bar",
				tooltip = "Adds a bar indicating the time left for the pickupable to disappear.",
				type = "select",
				values  = { "Disabled", "Equipment Only", "All pickupables" },
				defaultValue = 2,
				category = "hud",
				valueType = "int",
				sort = "A16",
				resetSettingInBuild = 191,
			},
			pickupexpirecolor = { 
				name = "CHUD_PickupExpireBarColor",
				label = "Dynamically colored expiration bar",
				tooltip = "Makes the expire bar colored depending on time left.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = 0,
				category = "hud",
				valueType = "int",
				sort = "A17",
			},		
			motiontracking = {
				name = "CHUD_MotionTracking",
				label = "Motion tracking circle",
				tooltip = "Lets you choose between default scan circles and a less obstructing one.",
				type = "select",
				values  = { "Default", "Minimal" },
				defaultValue = 0,
				category = "hud",
				valueType = "int",
				helpImage = "ui/helpImages/motiontracking.dds",
				helpImageSize = Vector(160, 80, 0),
				sort = "B01"
			},
			wrenchicon = { 
				name = "CHUD_DynamicWrenchColor",
				label = "Dynamically colored repair icon",
				tooltip = "Makes the wrench on the marine HUD be color coded with the amount of damage received.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = 1,
				category = "hud",
				valueType = "int",
				sort = "B02",
			},
			
			
			
			
			serverblood = {
				name = "CHUD_ServerBlood",
				label = "Server-side blood hits",
				tooltip = "Disables predicted blood on the client and turns it into server-confirmed blood.",
				type = "select",
				values  = { "Predicted", "Server confirmed" },
				defaultValue = false,
				category = "damage",
				valueType = "bool",
				applyFunction = function()
					local message = { }
					message.serverblood = CHUDGetOption("serverblood")
					Client.SendNetworkMessage("SetCHUDServerBlood", message)
				end,
				sort = "A01",
			},
			hitindicator = { 
				name = "CHUD_HitIndicator",
				label = "Hit indicator fade time",
				tooltip = "Controls how long the crosshair hit indicator will last after hitting a target.",
				type = "slider",
				defaultValue = 0.25,
				minValue = 0,
				maxValue = 1,
				multiplier = 100,
				category = "damage",
				valueType = "float",
				applyFunction = function() Player.kShowGiveDamageTime = CHUDGetOption("hitindicator") end,
				applyOnLoadComplete = true,
				sort = "A02",
				resetSettingInBuild = 297
			},
			fasterdamagenumbers = {
				name = "CHUD_FasterDamageNumbers",
				label = "Faster damage numbers",
				tooltip = "Lets you choose the speed of the \"counting up\" text animation for the damage numbers.",
				type = "select",
				values  = { "Default", "Faster", "Instant" },
				defaultValue = 0,
				category = "damage",
				valueType = "int",
				applyFunction = 
					function() 
						local speeds = { [0] = 220, [1] = 800, [2] = 9001 }
						kWorldDamageNumberAnimationSpeed = speeds[CHUDGetOption("fasterdamagenumbers")]
					end,
				sort = "A03",
			},
			overkilldamagenumbers = {
				name = "CHUD_OverkillDamageNumbers",
				label = "Overkill damage numbers",
				tooltip = "Makes damage numbers display overkill values on the killing blow. This displays the damage done even if it's higher than the target's remaining HP instead of the actual damage dealt.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = false,
				category = "damage",
				valueType = "bool",
				applyFunction = function()
					local message = { }
					message.overkill = CHUDGetOption("overkilldamagenumbers")
					Client.SendNetworkMessage("SetCHUDOverkill", message)
				end,
				sort = "A04",
			},
			damagenumbertime = 
			{
				name = "CHUD_DamageNumberTime",
				label = "Damage number fade time",
				tooltip = "Controls how long damage numbers are on screen.",
				type = "slider",
				defaultValue = kWorldMessageLifeTime,
				minValue = 0,
				maxValue = 3,
				category = "damage",
				valueType = "float",
				sort = "A05"
			},
			dmgscale = {
				name = "CHUD_DMGScale",
				label = "Damage numbers scale",
				tooltip = "Lets you scale the damage numbers.",
				type = "slider",
				defaultValue = 1,
				minValue = 0.5,
				maxValue = 2,
				multiplier = 100,
				category = "damage",
				valueType = "float",
				sort = "A06",
			},
			uniqueshotgunhits = {
				name = "CHUD_UniqueShotgunHits",
				label = "Shotgun damage numbers",
				tooltip = "Optionally show unique damage numbers for each shotgun shot.",
				type = "select",
				values  = { "Default", "Per shot" },
				defaultValue = false,
				category = "damage",
				valueType = "bool",
				sort = "A07",
			},
			dmgcolor_m = {
				name = "CHUD_DMGColorM",
				label = "Marine damage numbers color",
				tooltip = "Changes the color of the marine damage numbers.",
				valueType = "color",
				defaultValue = 0x4DDBFF,
				category = "damage",
				sort = "A08",
				resetSettingInBuild = 264,
			},
			dmgcolor_a = {
				name = "CHUD_DMGColorA",
				label = "Alien damage numbers color",
				tooltip = "Changes the color of the alien damage numbers.",
				defaultValue = 0xFFCA3A,
				category = "damage",
				valueType = "color",
				sort = "A09",
				resetSettingInBuild = 264,
			},
			
			
			
			minimapalpha = { 
				name = "CHUD_MinimapAlpha",
				label = "Overview opacity",
				tooltip = "Sets the trasparency of the map overview.",
				type = "slider",
				defaultValue = 0.85,
				minValue = 0,
				maxValue = 1,
				multiplier = 100,
				category = "minimap",
				valueType = "float",
				applyFunction = function()
					local minimapScript = ClientUI.GetScript("GUIMinimapFrame")
					if minimapScript then
						minimapScript:GetMinimapItem():SetColor(Color(1,1,1,CHUDGetOption("minimapalpha")))
					end
				end,
				sort = "A01",
			},
			locationalpha = { 
				name = "CHUD_LocationAlpha",
				label = "Location text opacity",
				tooltip = "Sets the trasparency of the location text on the minimap.",
				type = "slider",
				defaultValue = 0.65,
				minValue = 0,
				maxValue = 1,
				multiplier = 100,
				category = "minimap",
				valueType = "float",
				applyFunction = function()
					Shared.ConsoleCommand("setmaplocationcolor 255 255 255 " .. tostring(tonumber(CHUDGetOption("locationalpha"))*255))
				end,
				sort = "A02",
			},
			friends = {
				name = "CHUD_Friends",
				label = "Friends highlighting",
				tooltip = "Enables or disables the friend highlighting in the minimap.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "minimap",
				valueType = "bool",
				applyFunction = function() 	local friends = CHUDGetOption("friends")
					ReplaceLocals(PlayerUI_GetStaticMapBlips, { kMinimapBlipTeamFriendAlien =
						ConditionalValue(friends, kMinimapBlipTeam.FriendAlien, kMinimapBlipTeam.Alien) } )
					ReplaceLocals(PlayerUI_GetStaticMapBlips, { kMinimapBlipTeamFriendMarine =
						ConditionalValue(friends, kMinimapBlipTeam.FriendMarine, kMinimapBlipTeam.Marine) } )
				end,
				sort = "A03",
			},
			pglines = { 
				name = "CHUD_MapConnectorLines",
				label = "Phase Gate Lines",
				tooltip = "Cutomizes the look of the PG lines in the minimap.",
				type = "select",
				values  = { "Solid line", "Static arrows", "Animated lines", "Animated arrows" },
				defaultValue = 3,
				category = "minimap",
				valueType = "int",
				sort = "A04",
			},
			minimaptoggle = { 
				name = "CHUD_MinimapToggle",
				label = "Minimap key behavior",
				tooltip = "Lets you make the minimap key a toggle instead of holding.",
				type = "select",
				values  = { "Hold", "Toggle" },
				defaultValue = 0,
				category = "minimap",
				valueType = "int",
				sort = "A05",
			},
			overheadsmoothing = { 
				name = "CHUD_OverheadSmoothing",
				label = "Spectator overhead smoothing",
				tooltip = "Toggles between smoothed and instant camera movement when clicking on the minimap as an overhead spectator.",
				type = "select",
				values  = { "Instant", "Smoothed" },
				defaultValue = true,
				category = "minimap",
				valueType = "bool",
				sort = "A06",
			},
			minimaparrowcolorcustom = { 
				name = "CHUD_MinimapArrowColorCustom",
				label = "Use custom minimap arrow color",
				tooltip = "Lets you set the color of the arrow indicating your position in the minimap.",
				type = "select",
				values  = { "Disabled", "Enabled" },
				defaultValue = false,
				category = "minimap",
				valueType = "bool",
				applyFunction = function()
					local minimapScript = ClientUI.GetScript("GUIMinimapFrame")
					local playerIconColor = nil
					if CHUDGetOption("minimaparrowcolorcustom") then
						playerIconColor = ColorIntToColor(CHUDGetOption("minimaparrowcolor"))
					end
					if minimapScript then
						minimapScript:SetPlayerIconColor(playerIconColor)
					end
					CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD" })
				end,
				hideValues = { false },
				children = { "minimaparrowcolor" },
				sort = "A07",
			},
			minimaparrowcolor = { 
				name = "CHUD_MinimapArrowColor",
				label = "Minimap arrow color",
				tooltip = "Sets the color of the arrow indicating your position in the minimap.",
				defaultValue = 0xFFFF00,
				category = "minimap",
				applyFunction = function()
					local minimapScript = ClientUI.GetScript("GUIMinimapFrame")
					local playerIconColor = nil
					if CHUDGetOption("minimaparrowcolorcustom") then
						playerIconColor = ColorIntToColor(CHUDGetOption("minimaparrowcolor"))
					end
					if minimapScript then
						minimapScript:SetPlayerIconColor(playerIconColor)
					end
					CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD" })
				end,
				valueType = "color",
				sort = "A08",
				resetSettingInBuild = 265,
			},
			mapelementscolor = {
				name = "CHUD_MapElementsColor",
				label = "Tech point/Res node minimap color",
				tooltip = "Sets the color for the empty Tech Points and Resource Nodes in the minimap.",
				defaultValue = 0x00FF80,
				category = "minimap",
				valueType = "color",
				sort = "A09",
				resetSettingInBuild = 330,
			},
			playercolor_m = { 
				name = "CHUD_PlayerColor_M",
				label = "Marine minimap player color",
				tooltip = "Sets the color of marine players in the minimap different from the structures.",
				defaultValue = 0x00D8FF,
				category = "minimap",
				applyFunction = function() CHUDRestartScripts({ "Hud/Marine/GUIMarineHUD" }) end,
				valueType = "color",
				sort = "A10",
				resetSettingInBuild = 264,
			},
			playercolor_a = { 
				name = "CHUD_PlayerColor_A",
				label = "Alien minimap player color",
				tooltip = "Sets the color of alien players in the minimap different from the structures.",
				defaultValue = 0xFF8A00,
				category = "minimap",
				valueType = "color",
				sort = "A11",
				resetSettingInBuild = 264,
			},
			commhighlight = {
				name = "CHUD_CommHighlight",
				label = "(Comm) Building highlight",
				tooltip = "Highlights the buildings of the same type that you're about to drop in the minimap in a different color.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "minimap",
				valueType = "bool",
				children = { "commhighlightcolor" },
				hideValues = { false },
				sort = "A12",
			},
			commhighlightcolor = {
				name = "CHUD_CommHighlightColor",
				label = "(Comm) Building highlight color",
				tooltip = "Selects the color of the building highlight.",
				valueType = "color",
				defaultValue = 0xFFFF00,
				category = "minimap",
				sort = "A13",
			},
			
			
			
			hitsounds = {
				name = "CHUD_Hitsounds",
				label = "Hitsounds",
				tooltip = "Chooses between different server confirmed hitsounds.",
				type = "select",
				values  = { "Vanilla", "Quake 3", "Quake 4", "Dystopia" },
				valueTable = { "null",
					"sound/hitsounds.fev/hitsounds/q3",
					"sound/hitsounds.fev/hitsounds/q4",
					"sound/hitsounds.fev/hitsounds/dys",
				},
				defaultValue = 0,
				category = "sound",
				valueType = "int",
				children = { "hitsounds_pitch" },
				hideValues = { 0 },
				sort = "A01",
			},
			hitsounds_pitch = { 
				name = "CHUD_HitsoundsPitch",
				label = "Hitsounds pitch modifier",
				tooltip = "Sets the pitch for high damage hits on variable damage weapons. This setting has no effect for vanilla hitsounds.",
				type = "select",
				values  = { "Low pitch", "High pitch" },
				defaultValue = 0,
				category = "sound",
				valueType = "int",
				sort = "A02",
			},
			ambient = {
				name = "CHUD_Ambient",
				label = "Ambient sounds",
				tooltip = "Enables or disables map ambient sounds.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "sound",
				valueType = "bool",
				applyFunction = SetCHUDAmbients,
				applyOnLoadComplete = true,
				sort = "A03",
			},
			
			
			
			mapparticles = {
				name = "CHUD_MapParticles",
				label = "Map particles",
				tooltip = "Enables or disables particles, holograms and other map specific effects.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "graphics",
				valueType = "bool",
				applyFunction = SetCHUDCinematics,
				applyOnLoadComplete = true,
				sort = "A01",
			},
			particles = {
				name = "CHUD_Particles",
				label = "Minimal particles",
				tooltip = "Toggles between default and less vision obscuring particles.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "graphics",
				valueType = "bool",
				applyFunction = SetCHUDCinematics,
				applyOnLoadComplete = true,
				sort = "A02"
			},
			nsllights = {
				name = "lowLights",
				label = "High performance lights",
				tooltip = "Replaces the low quality option lights with the lights from the NSL maps which have the lowest light count. Requires low quality lights in the vanilla graphics option.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "graphics",
				valueType = "bool",
				applyFunction = function()
					lowLightsSwitched = false
					CHUDLoadLights()
				end,
				sort = "A04",
			}, 
			flashatmos = { 
				name = "CHUD_FlashAtmos",
				label = "Flashlight atmospherics",
				tooltip = "Sets the atmospheric density of flashlights.",
				type = "slider",
				defaultValue = 1,
				minValue = 0,
				maxValue = 1,
				multiplier = 100,
				category = "graphics",
				valueType = "float",
				sort = "A05",
			},
			blur = {
				name = "CHUD_Blur",
				label = "Blur",
				tooltip = "Removes the background blur from menus/minimap.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "graphics",
				valueType = "bool",
				sort = "A06"
			},
			maxdecallifetime = {
				name = "CHUD_MaxDecalLifeTime",
				label = "Max decal lifetime (minutes)",
				tooltip = "Changes the maximum decal lifetime, you still have to set the slidebar to your liking in the vanilla options.",
				type = "slider",
				defaultValue = 1,
				minValue = 0,
				maxValue = 100,
				multiplier = 1,
				category = "graphics",
				valueType = "float",
				sort = "A07",
			},
			tracers = {
				name = "CHUD_Tracers",
				label = "Weapon tracers",
				tooltip = "Enables or disables weapon tracers.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "graphics",
				valueType = "bool",
				sort = "A08",
			},
			gorgespit = { 
				name = "CHUD_GorgeSpit",
				label = "Gorge Spit",
				tooltip = "Replaces gorge spit with a model (rifle_grenade) so it gets outlined and is easier to see with custom alien vision.",
				type = "select",
				values  = { "Default", "High Visibility" },
				defaultValue = false,
				category = "graphics",
				valueType = "bool",
				sort = "A09",
			},
			
			
			
			sbcenter = { 
				name = "CHUD_SBCenter",
				label = "Auto-center scoreboard",
				tooltip = "Enable or disable the scoreboard scrolling to your entry in the scoreboard automatically after opening it.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "stats",
				valueType = "bool",
				sort = "A01",
			},
			kda = {
				name = "CHUD_KDA",
				label = "KDA/KAD",
				tooltip = "Switches the scoreboard columns between KAD and KDA.",
				type = "select",
				values  = { "KAD", "KDA" },
				defaultValue = false,
				category = "stats",
				valueType = "bool",
				applyFunction = function() CHUDRestartScripts({ "GUIScoreboard" }) end,
				sort = "A02",
			},
			deathstats = { 
				name = "CHUD_DeathStats",
				label = "Stats UI",
				tooltip = "Enables or disables the stats you get after you die and at the end of the round. Also visible on voiceover menu (default: X).",
				type = "select",
				values  = { "Fully disabled", "Only voiceover menu", "Enabled" },
				defaultValue = 2,
				disabledValue = 0,
				category = "stats",
				valueType = "int",
				sort = "A03",
			},
			endstatsorder = { 
				name = "CHUD_EndStatsOrder",
				label = "End Game Stats UI Order",
				tooltip = "Sets the order in which the stats after a round ends are displayed.",
				type = "select",
				values  = { "Team stats first", "Personal stats first" },
				defaultValue = 0,
				category = "stats",
				valueType = "int",
				sort = "A04",
			},
			
			
			
			castermode = { 
				name = "CHUD_CasterMode",
				label = "Caster mode",
				tooltip = "Makes NS2+ use all the default values without overwriting your current config.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "misc",
				valueType = "bool",
				applyFunction = function()
					for name, option in pairs(CHUDOptions) do
						if name ~= "castermode" then
							if option.applyFunction then
								option.applyFunction()
							end
						end
					end
				end,
				sort = "A01",
			},
			brokenscaling = { 
				name = "CHUD_BrokenScaling",
				label = "UI Scaling version",
				tooltip = "Revert the amazing UI Scaling introduced in build 276 by the sexiest man alive and use the inferior, disgusting and broken stuff from previous builds. Use at your own risk.",
				type = "select",
				values  = { "Default", "Old" },
				defaultValue = false,
				category = "misc",
				valueType = "bool",
				applyFunction = function()
					CHUDApplyNewUIScale()
				end,
				children = { "uiscale" },
				hideValues = { true },
				sort = "A02",
			},
			uiscale = { 
				name = "CHUD_UIScaling",
				label = "UI Scaling",
				tooltip = "Change the scaling for the UI. Note that not everything will adapt to this as not everything is using the same scaling function and some elements might break. Use at your own risk.",
				type = "slider",
				defaultValue = 1,
				minValue = 0.05,
				maxValue = 2,
				multiplier = 100,
				category = "misc",
				valueType = "float",
				applyFunction = function()
					CHUDApplyNewUIScale()
				end,
				sort = "A03",
			},
			sensitivity_perteam = { 
				name = "CHUD_SensitivityPerTeam",
				label = "Team specific sensitivities",
				tooltip = "Lets you have different sensitivities for aliens and marines.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "misc",
				valueType = "bool",
				applyFunction = function()
					CHUDApplyTeamSpecificStuff()
				end,
				children = { "sensitivity_m", "sensitivity_a" },
				hideValues = { false },
				sort = "A04",
				ignoreCasterMode = true,
			},
			sensitivity_m = { 
				name = "CHUD_Sensitivity_M",
				label = "Marine sensitivity",
				tooltip = "Sensitivity for marines.",
				type = "slider",
				defaultValue = 2,
				minValue = 0.01,
				maxValue = 20,
				multiplier = 1,
				category = "misc",
				valueType = "float",
				applyFunction = function()
					CHUDApplyTeamSpecificStuff()
				end,
				sort = "A05",
				ignoreCasterMode = true,
			},
			sensitivity_a = { 
				name = "CHUD_Sensitivity_A",
				label = "Alien sensitivity",
				tooltip = "Sensitivity for aliens.",
				type = "slider",
				defaultValue = 2,
				minValue = 0.01,
				maxValue = 20,
				multiplier = 1,
				category = "misc",
				valueType = "float",
				applyFunction = function()
					CHUDApplyTeamSpecificStuff()
				end,
				sort = "A06",
				ignoreCasterMode = true,
			},
			fov_perteam = { 
				name = "CHUD_FOVPerTeam",
				label = "Team specific FOV",
				tooltip = "Lets you have different FOVs for aliens and marines.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "misc",
				valueType = "bool",
				applyFunction = function()
					CHUDApplyTeamSpecificStuff()
				end,
				children = { "fov_m", "fov_a" },
				hideValues = { false },
				sort = "A07",
				ignoreCasterMode = true,
			},
			fov_m = { 
				name = "CHUD_FOV_M",
				label = "Marine FOV",
				tooltip = "FOV for marines.",
				type = "slider",
				defaultValue = 0,
				minValue = 0,
				maxValue = 1,
				multiplier = 20,
				category = "misc",
				valueType = "float",
				applyFunction = function()
					CHUDApplyTeamSpecificStuff()
				end,
				sort = "A08",
				ignoreCasterMode = true,
			},
			fov_a = { 
				name = "CHUD_FOV_A",
				label = "Alien FOV",
				tooltip = "FOV for aliens.",
				type = "slider",
				defaultValue = 0,
				minValue = 0,
				maxValue = 1,
				multiplier = 20,
				category = "misc",
				valueType = "float",
				applyFunction = function()
					CHUDApplyTeamSpecificStuff()
				end,
				sort = "A09",
				ignoreCasterMode = true,
			},
			autopickup = { 
				name = "CHUD_AutoPickup",
				label = "Weapon autopickup",
				tooltip = "Picks up weapons automatically as long as the slot they belong to is empty.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "misc",
				valueType = "bool",
				sort = "A10",
				applyFunction = function()
					local message = { }
					message.autoPickup = CHUDGetOption("autopickup")
					message.autoPickupBetter = CHUDGetOption("autopickupbetter")
					Client.SendNetworkMessage("SetCHUDAutopickup", message)
				end,
			},
			autopickupbetter = { 
				name = "CHUD_AutoPickupBetter",
				label = "Autopickup better weapon",
				tooltip = "Picks up better weapons in the primary slot automatically.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = false,
				category = "misc",
				valueType = "bool",
				sort = "A11",
				applyFunction = function()
					local message = { }
					message.autoPickup = CHUDGetOption("autopickup")
					message.autoPickupBetter = CHUDGetOption("autopickupbetter")
					Client.SendNetworkMessage("SetCHUDAutopickup", message)
				end,
			},
			drawviewmodel = { 
				name = "CHUD_DrawViewModel",
				label = "Draw viewmodel",
				tooltip = "Enables or disables showing the viewmodel.",
				type = "select",
				values  = { "Display all", "Hide all", "Custom" },
				defaultValue = 0,
				category = "misc",
				valueType = "int",
				sort = "A12",
				applyFunction = function()
					CHUDEvaluateGUIVis()
					CHUDRestartScripts({"Hud/Marine/GUIMarineHUD"})
				end,
				children = { "drawviewmodel_m", "drawviewmodel_a", "drawviewmodel_exo" },
				hideValues = { 0, 1 },
				resetSettingInBuild = 290,
			},
			drawviewmodel_m = { 
				name = "CHUD_DrawViewModel_M",
				label = "Marine viewmodel",
				tooltip = "Enables or disables showing the marine viewmodel.",
				type = "select",
				values  = { "Hide", "Display" },
				defaultValue = true,
				category = "misc",
				valueType = "bool",
				sort = "A13",
				applyFunction = function()
					CHUDEvaluateGUIVis()
					CHUDRestartScripts({"Hud/Marine/GUIMarineHUD"})
				end,
			},
			drawviewmodel_a = { 
				name = "CHUD_DrawViewModel_A",
				label = "Alien viewmodel",
				tooltip = "Enables or disables showing the alien viewmodel.",
				type = "select",
				values  = { "Hide", "Display" },
				defaultValue = true,
				category = "misc",
				valueType = "bool",
				sort = "A14",
				applyFunction = function()
					CHUDEvaluateGUIVis()
				end,
			},
			drawviewmodel_exo = { 
				name = "CHUD_DrawViewModel_Exo",
				label = "Exo viewmodel",
				tooltip = "Enables or disables showing the exo viewmodel.",
				type = "select",
				values  = { "Hide", "Display" },
				defaultValue = true,
				category = "misc",
				valueType = "bool",
				sort = "A15",
				applyFunction = function()
					CHUDEvaluateGUIVis()
					CHUDRestartScripts({"Hud/Marine/GUIMarineHUD"})
				end,
			},
			
			marinecommselect = { 
				name = "CHUD_MarineCommSelect",
				label = "(Comm) Marine Click Selection",
				tooltip = "Lets you disable click selecting for Marines.",
				type = "select",
				values  = { "Off", "On" },
				defaultValue = true,
				category = "misc",
				valueType = "bool",
				sort = "B01",
			},
			commqueue_playeronly = { 
				name = "CHUD_CommQueuePlayerOnly",
				label = "(Comm) Spacebar Player Alerts",
				tooltip = "Allows the spacebar alert queue to only respond to player requests.",
				type = "select",
				values  = { "Default", "Only Player Alerts" },
				defaultValue = false,
				category = "misc",
				valueType = "bool",
				sort = "B02",
			},
}
