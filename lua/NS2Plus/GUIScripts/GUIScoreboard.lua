local originalScoreboardUpdateTeam = GUIScoreboard.UpdateTeam
function GUIScoreboard:UpdateTeam(updateTeam)
	originalScoreboardUpdateTeam(self, updateTeam)

	if CHUDGetOption("kda") then
		-- Swap KDA/KAD
		local playerList = updateTeam["PlayerList"]
		for _, player in ipairs(playerList) do
			local assistsPosition = player["Assists"]:GetPosition().x
			local deathsPosition = player["Deaths"]:GetPosition().x
			if assistsPosition < deathsPosition then
				player["Assists"]:SetPosition(deathsPosition)
				player["Deaths"]:SetPosition(assistsPosition)
			end
		end
	end
end

local originalScoreboardUpdate = GUIScoreboard.Update
function GUIScoreboard:Update(deltaTime)
	
	originalScoreboardUpdate(self, deltaTime)
	
	if self.visible then
		self.centerOnPlayer = CHUDGetOption("sbcenter")
	end
end

local originalLocaleResolveString = Locale.ResolveString
function Locale.ResolveString(resolveString)
	if CHUDGetOption("kda") then
		if resolveString == "SB_ASSISTS" then
			return originalLocaleResolveString("SB_DEATHS")
		elseif resolveString == "SB_DEATHS" then
			return originalLocaleResolveString("SB_ASSISTS")
		else
			return originalLocaleResolveString(resolveString)
		end
	else
		return originalLocaleResolveString(resolveString)
	end
end
