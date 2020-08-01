

local kMaxMarineNotificationsHL1Hudbars = 3
local kMaxAlienNotificationsHL1Hudbars = 2

local OriginalGUIEventInitialize = GUIEvent.Initialize
function GUIEvent:Initialize()

    OriginalGUIEventInitialize(self)

    local hudBars = ConditionalValue(self.useMarineStyle, CHUDGetOption("hudbars_m"), CHUDGetOption("hudbars_a"))
    if hudBars == 2 then

        self.maxNotifications = ConditionalValue(self.useMarineStyle, kMaxMarineNotificationsHL1Hudbars, kMaxAlienNotificationsHL1Hudbars)

    end
end

local OriginalGUIEventUpdate = GUIEvent.Update
function GUIEvent:Update(_, newTechId)

    OriginalGUIEventUpdate(self, _, newTechId)

    local hudBars = ConditionalValue(self.useMarineStyle, CHUDGetOption("hudbars_m"), CHUDGetOption("hudbars_a"))
    if hudBars == 2 then

        self.maxNotifications = ConditionalValue(self.useMarineStyle, kMaxMarineNotificationsHL1Hudbars, kMaxAlienNotificationsHL1Hudbars)

    else

        self.maxNotifications = ConditionalValue(self.useMarineStyle, GUIEvent.kMaxDisplayedNotificationsMarine, GUIEvent.kMaxDisplayedNotificationsAlien)

    end
end
