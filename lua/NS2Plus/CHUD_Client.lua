Script.Load("lua/NS2Plus/Client/CHUD_Particles.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Settings.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Options.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Atmospherics.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Lights.lua")
Script.Load("lua/NS2Plus/Client/CHUD_UnitStatus.lua")
Script.Load("lua/NS2Plus/Client/CHUD_PlayerClient.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Tracers.lua")
Script.Load("lua/NS2Plus/Client/CHUD_ScoreDisplay.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Sounds.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Hitsounds.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Outlines.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Decals.lua")
Script.Load("lua/NS2Plus/Client/CHUD_WeaponTime.lua")
Script.Load("lua/NS2Plus/Client/CHUD_ViewModel.lua")
Script.Load("lua/NS2Plus/Client/CHUD_GoldenMode.lua")
Script.Load("lua/NS2Plus/Client/CHUD_MinimapMoveMixin.lua")
Script.Load("lua/NS2Plus/Client/CHUD_GorgeSpit.lua")

trollModes = {}

local originalGUIScale = GUIScale
function GUIScale(size)
	if not CHUDGetOption("brokenscaling") and not trollModes["masterresMode"] then
		local scale = CHUDGetOption("uiscale") or 1
		return originalGUIScale(size*scale)
	elseif trollModes["masterresMode"] then
		--return originalGUIScale(size*(1+PlayerUI_GetGameLengthTime()/60))
		return originalGUIScale(size)
	elseif CHUDGetOption("brokenscaling") then
		local screenWidth = Client.GetScreenWidth()
		local screenHeight = Client.GetScreenHeight()
		local kScreenScaleAspect = 1280
		local ScreenSmallAspect = ConditionalValue(screenWidth > screenHeight, screenHeight, screenWidth)
		return math.scaledown(size, ScreenSmallAspect, kScreenScaleAspect) * (2 - (ScreenSmallAspect / kScreenScaleAspect))
	end
end

local originalGUISetColor = GUIItem.SetColor
function GUIItem:SetColor(p1, p2, p3, p4)
	if not trollModes["ironMode"] then
		originalGUISetColor(self, p1, p2, p3, p4)
	else
		local color = ProcessColorInput(p1, p2, p3, p4) * Color(1, 0, 0, 1)
		originalGUISetColor(self, color)
	end
end

local function ToggleIron()
	trollModes["ironMode"] = not trollModes["ironMode"]
	
	local xRes = Client.GetScreenWidth()
	local yRes = Client.GetScreenHeight()
	GetGUIManager():OnResolutionChanged(xRes, yRes, xRes, yRes)
	
	Shared.Message("IronHorse mode: " .. ConditionalValue(trollModes["ironMode"], "ENGAGED!", "Disabled :("))
end

Event.Hook("Console_ironmode", ToggleIron)
Event.Hook("Console_ironhorsemode", ToggleIron)

local function OnLoadComplete()
	GetCHUDSettings()

	GetGUIManager():CreateGUIScript("NS2Plus/Client/CHUDGUI_DeathStats")
	GetGUIManager():CreateGUIScript("NS2Plus/Client/CHUDGUI_EndStats")

	Shared.Message("NS2+ v" .. kCHUDVersion .. " loaded (NS2 Build " .. Shared.GetBuildNumber() .. "). Type \"plus\" in console for available commands. You can also customize your game from the options menu.")
end

local function OnLocalPlayerChanged()
	CHUDLoadLights()
	CHUDEvaluateGUIVis()
	CHUDApplyLifeformSpecificStuff()
	CHUDUpdateDaltonizeVision()
end

local lastTeam
local function CheckPlayerTeamChange()
	local player = Client.GetLocalPlayer()
	local teamNumber = player and player:GetTeamNumber()
	if teamNumber ~= lastTeam then
		CHUDApplyTeamSpecificStuff()
		lastTeam = teamNumber
	end
end

Event.Hook("UpdateClient", CheckPlayerTeamChange)
Event.Hook("LoadComplete", OnLoadComplete)
Event.Hook("LocalPlayerChanged", OnLocalPlayerChanged)

function Client.AddWorldMessage(messageType, message, position, entityId)

	-- Only add damage messages if we have it enabled
	if messageType ~= kWorldTextMessageType.Damage or Client.GetOptionBoolean( "drawDamage", true ) then

		-- If we already have a message for this entity id, update existing message instead of adding new one
		local time = Client.GetTime()
			
		local updatedExisting = false
		
		if messageType == kWorldTextMessageType.Damage and entityId ~= nil and entityId ~= Entity.invalidId then
		
			for _, currentWorldMessage in ipairs(Client.worldMessages) do
			
				if currentWorldMessage.messageType == messageType and currentWorldMessage.entityId == entityId and currentWorldMessage.canAccumulate then

					currentWorldMessage.creationTime = time
					currentWorldMessage.position = position
					currentWorldMessage.previousNumber = tonumber(currentWorldMessage.message)
					currentWorldMessage.message = currentWorldMessage.message + message
					currentWorldMessage.minimumAnimationFraction = kWorldDamageRepeatAnimationScalar
					
					updatedExisting = true
					break
					
				end
				
			end
			
		end
		
		if not updatedExisting then
		
			local worldMessage = {}
			
			worldMessage.messageType = messageType
			worldMessage.message = message
			worldMessage.position = position        
			worldMessage.creationTime = time
			worldMessage.entityId = entityId
			worldMessage.animationFraction = 0
			worldMessage.lifeTime = ConditionalValue(kWorldTextMessageType.CommanderError == messageType, kCommanderErrorMessageLifeTime, kWorldMessageLifeTime)
			
			if messageType == kWorldTextMessageType.Damage then
				
				worldMessage.lifeTime = CHUDGetOption("damagenumbertime")
				
				local player = Client.GetLocalPlayer()
				local weapon = player and player:GetActiveWeapon()
				if weapon and weapon:isa("Shotgun") and CHUDGetOption( "uniqueshotgunhits" ) then
					worldMessage.canAccumulate = false
				else
					worldMessage.canAccumulate = true
				end
					
			end
			
			if messageType == kWorldTextMessageType.CommanderError then
			
				local commander = Client.GetLocalPlayer()
				if commander then
					commander:TriggerInvalidSound()
				end
				
			end
			
			table.insert(Client.worldMessages, worldMessage)
			
		end
		
	end
	
end

local function OnCommandClearBinding(keyName)
	if keyName then
		Shared.ConsoleCommand("clear_binding " .. tostring(keyName))
	end
end
Event.Hook("Console_unbind", OnCommandClearBinding)

CHUDDevMode = false
local function OnCommandDevMode(arg)
	if arg == nil then
		Print("NS2Plus dev mode is %s", CHUDDevMode and "enabled" or "disabled")
	else
		CHUDDevMode = string.ToBoolean(arg)
		Print("NS2Plus dev mode is now %s", CHUDDevMode and "enabled" or "disabled")
	end
end
Event.Hook("Console_plus_dev", OnCommandDevMode)