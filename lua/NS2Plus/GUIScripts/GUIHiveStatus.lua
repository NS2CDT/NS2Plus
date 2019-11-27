local originalInit = GUIHiveStatus.Initialize
function GUIHiveStatus:Initialize()
	originalInit(self)

	local gametime = CHUDGetOption("gametime")
	local realtime = CHUDGetOption("realtime")
	if gametime and realtime then
		self.kStatusBackgroundPosition = GUIScale( Vector( 0, 97, 0 ) )
		self.background:SetPosition( self.kStatusBackgroundPosition )
	end

	self.hivestatus = CHUDGetOption("hivestatus")
	self:SetIsVisible(self.hivestatus)
end

local oldUpdate = GUIHiveStatus.Update
function GUIHiveStatus:Update(deltaTime)
	if not self.hivestatus then return end

	oldUpdate(self, deltaTime)
end

	local transparent = PrecacheAsset("ui/transparent.dds")
local originalCreateStatusContainer = GUIHiveStatus.CreateStatusContainer
function GUIHiveStatus:CreateStatusContainer(slotIdx, locationId)
	originalCreateStatusContainer(self, slotIdx, locationId)

	local mingui = not CHUDGetOption("mingui")
	local frameBackground = ConditionalValue(mingui, "ui/alien_hivestatus_frame_bgs.dds", transparent)
	local locationBackground = ConditionalValue(mingui, "ui/alien_hivestatus_locationname_bg.dds", transparent)

	self.statusSlots[slotIdx].frame:SetTexture(frameBackground)
	self.statusSlots[slotIdx].locationBackground:SetTexture(locationBackground)
end