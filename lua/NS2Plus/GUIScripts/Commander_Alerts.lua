local oldCommanderUI_ClickedLocationAlert = CommanderUI_ClickedLocationAlert
function CommanderUI_ClickedLocationAlert(x, z)
	local player = Client.GetLocalPlayer()
	local allAlerts = player and player:isa("AlienCommander") or not CHUDGetOption("commqueue_playeronly")
	if allAlerts then
		oldCommanderUI_ClickedLocationAlert(x, z)
	end
end

local oldCommanderUI_ClickedEntityAlert = CommanderUI_ClickedEntityAlert
function CommanderUI_ClickedEntityAlert(entityId)
	local entity = Shared.GetEntity(entityId)
	local player = Client.GetLocalPlayer()

	if player and entity then
		if entity:isa("Player") then
			oldCommanderUI_ClickedEntityAlert(entityId)
		elseif player:isa("AlienCommander") or not CHUDGetOption("commqueue_playeronly") then
			oldCommanderUI_ClickedEntityAlert(entityId)
		end
	end
end