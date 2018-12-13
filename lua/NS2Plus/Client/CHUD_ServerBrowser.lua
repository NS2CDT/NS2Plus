local oldBuildServerEntry = BuildServerEntry
function BuildServerEntry(serverIndex)
	local serverEntry = oldBuildServerEntry(serverIndex)

	local mainMenu = GetCHUDMainMenu()
	if mainMenu and mainMenu.serverList and mainMenu.serverList:GetIsVisible() then
		local serverTags = { }
		Client.GetServerTags(serverIndex, serverTags)
		
		for t = 1, #serverTags do
			local _, pos = string.find(serverTags[t], "CHUD_0x")
			if pos then
				serverEntry.CHUDBitmask = tonumber(string.sub(serverTags[t], pos+1))
				break
			end
		end
	end
	
	return serverEntry
	
end

local kBlue = Color(0, 168/255 ,255/255)
local kGreen = Color(0, 208/255, 103/255)
local kYellow = kGreen --Color(1, 1, 0) --used for reserved full
local kGold = kBlue --Color(212/255, 175/255, 55/255) --used for ranked
local originalSetServerData = ServerEntry.SetServerData
function ServerEntry:SetServerData(serverData)
	originalSetServerData(self, serverData)

	local blockedString
	if serverData.CHUDBitmask ~= nil then
		local mode = serverData.mode:gsub("ns2", "ns2+", 1)
		self.modName:SetText(mode)

		if serverData.ranked then
			self.modName:SetColor(kGold)
		end
		for i = 1, #CHUDTagBitmaskEnum do
			local index = CHUDTagBitmaskEnum[i]
			local mask = CHUDTagBitmask[index]

			if CheckCHUDTagOption(serverData.CHUDBitmask, mask) then
				if index == "mcr" then
					self.playerCount:SetColor(kYellow)
				else
					local val = ConditionalValue(CHUDOptions[index].disabledValue == nil, CHUDOptions[index].defaultValue, CHUDOptions[index].disabledValue)

					if CHUDOptions[index].currentValue ~= val then
						self.modName:SetColor(kYellow)
						if not blockedString then
							blockedString = ConditionalValue(serverData.ranked, "Ranked server. ", "") .. "This server has disabled these NS2+ settings that you're currently using: " .. CHUDOptions[index].label
						else
							blockedString = blockedString .. ", " .. CHUDOptions[index].label
						end

					end
				end
			end
		end
	end
		
	self.modName.tooltipText = blockedString or serverData.ranked and Locale.ResolveString(string.format("SERVERBROWSER_RANKED_TOOLTIP"))
	self.mapName:SetColor(kWhite)
	self.mapName.tooltipText = nil
	if serverData.ranked and blockedString then
		self.mapName:SetColor(kGold)
		self.mapName.tooltipText = Locale.ResolveString(string.format("SERVERBROWSER_RANKED_TOOLTIP"))
	end
end

local originalServerEntryInit = ServerEntry.Initialize
function ServerEntry:Initialize()
	originalServerEntryInit(self)

	if not self.tooltip and self.modName.tooltip then
		self.tooltip = self.modName.tooltip
	end

	table.insert(self.mouseOverCallbacks, function(self)
		if self.mapName.tooltipText and GUIItemContainsPoint(self.mapName, Client.GetCursorPosScreen()) then
			self.tooltip:SetText(self.mapName.tooltipText)
			self.tooltip:Show()
			self.mapName.toolTipActive = true
		elseif self.mapName.toolTipActive then
			self.mapName.toolTipActive = false
			self.tooltip:Hide()
		end
	end)
end