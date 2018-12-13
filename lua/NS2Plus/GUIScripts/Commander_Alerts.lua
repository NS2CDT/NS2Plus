local oldCommanderUI_ClickedLocationAlert = CommanderUI_ClickedLocationAlert
function CommanderUI_ClickedLocationAlert(x, z)
	if not CHUDGetOption("commqueue_playeronly") then
		oldCommanderUI_ClickedLocationAlert(x, z)
	end
end

local oldCommanderUI_ClickedEntityAlert = CommanderUI_ClickedEntityAlert
function CommanderUI_ClickedEntityAlert(entityId)
	local entity = Shared.GetEntity(entityId)
	if entity then
		if entity:isa("Player") then
			oldCommanderUI_ClickedEntityAlert(entityId)
		elseif not CHUDGetOption("commqueue_playeronly") then
			oldCommanderUI_ClickedEntityAlert(entityId)
		end
	end
end