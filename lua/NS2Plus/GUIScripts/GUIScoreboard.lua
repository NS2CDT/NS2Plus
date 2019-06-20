local kObservatoryUserURL = "https://observatory.morrolan.ch/player?steam_id="

local team1Skill, team2Skill, team1VictoryP, skillDiff, skillPlayers = 0, 0, 0, 0, 0
local textHeight, teamItemWidth

local originalScoreboardUpdateTeam = GUIScoreboard.UpdateTeam
function GUIScoreboard:UpdateTeam(updateTeam)
	originalScoreboardUpdateTeam(self, updateTeam)
	
	local teamGUIItem = updateTeam["GUIs"]["Background"]
	local teamScores = updateTeam["GetScores"]()
	local playerList = updateTeam["PlayerList"]

	local numPlayers = #teamScores
	-- Resize the player list if it doesn't match.
	if #playerList ~= numPlayers then
		self:ResizePlayerList(playerList, numPlayers, teamGUIItem)
	end

	for _, player in ipairs(playerList) do
		-- Swap KDA/KAD
		if CHUDGetOption("kda") and player["Assists"]:GetPosition().x < player["Deaths"]:GetPosition().x then
			local temp = player["Assists"]:GetPosition()
			player["Assists"]:SetPosition(player["Deaths"]:GetPosition())
			player["Deaths"]:SetPosition(temp)
		end
	end

end

local originalScoreboardInit = GUIScoreboard.Initialize
function GUIScoreboard:Initialize()
	originalScoreboardInit(self)
	
	self.avgSkillItemBg = GUIManager:CreateGraphicItem()
	self.avgSkillItemBg:SetColor(Color(0, 0, 0, 0.75))
	self.avgSkillItemBg:SetLayer(kGUILayerScoreboard)
	self.avgSkillItemBg:SetAnchor(GUIItem.Middle, GUIItem.Top)
	self.scoreboardBackground:AddChild(self.avgSkillItemBg)
	
	self.avgSkillItem2Bg = GUIManager:CreateGraphicItem()
	self.avgSkillItem2Bg:SetColor(Color(0, 0, 0, 0.75))
	self.avgSkillItem2Bg:SetLayer(kGUILayerScoreboard)
	self.avgSkillItem2Bg:SetAnchor(GUIItem.Middle, GUIItem.Top)
	self.scoreboardBackground:AddChild(self.avgSkillItem2Bg)
	
	self.avgSkillItem = GUIManager:CreateTextItem()
	self.avgSkillItem:SetFontName(GUIScoreboard.kGameTimeFontName)
	self.avgSkillItem:SetScale(Vector(1, 1, 1) * GUIScoreboard.kScalingFactor)
	self.avgSkillItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
	self.avgSkillItem:SetTextAlignmentX(GUIItem.Align_Center)
	self.avgSkillItem:SetTextAlignmentY(GUIItem.Align_Center)
	self.avgSkillItem:SetColor(ColorIntToColor(kMarineTeamColor))
	self.avgSkillItem:SetText("")
	self.avgSkillItem:SetLayer(kGUILayerScoreboard)
	GUIMakeFontScale(self.avgSkillItem)
	
	self.avgSkillItem2 = GUIManager:CreateTextItem()
	self.avgSkillItem2:SetFontName(GUIScoreboard.kGameTimeFontName)
	self.avgSkillItem2:SetScale(Vector(1, 1, 1) * GUIScoreboard.kScalingFactor)
	self.avgSkillItem2:SetAnchor(GUIItem.Middle, GUIItem.Top)
	self.avgSkillItem2:SetTextAlignmentX(GUIItem.Align_Center)
	self.avgSkillItem2:SetTextAlignmentY(GUIItem.Align_Center)
	self.avgSkillItem2:SetColor(kRedColor)
	self.avgSkillItem2:SetText("")
	self.avgSkillItem2:SetLayer(kGUILayerScoreboard)
	GUIMakeFontScale(self.avgSkillItem2)
	
	self.avgSkillItemBg:SetIsVisible(false)
	self.avgSkillItem2Bg:SetIsVisible(false)
	
	teamItemWidth = self.teams[1].GUIs.Background:GetSize().x
	textHeight = self.avgSkillItem:GetTextHeight("Avg") * self.avgSkillItem:GetScale().y
	
	self.avgSkillItemBg:SetSize(Vector(teamItemWidth, textHeight+5*GUIScoreboard.kScalingFactor, 0))
	self.avgSkillItem2Bg:SetSize(Vector(teamItemWidth, textHeight+5*GUIScoreboard.kScalingFactor, 0))
end

local originalScoreboardUpdate = GUIScoreboard.Update
function GUIScoreboard:Update(deltaTime)
	
	originalScoreboardUpdate(self, deltaTime)
	
	if self.visible then
		self.centerOnPlayer = CHUDGetOption("sbcenter")
	end
end

local originalScoreboardSKE = GUIScoreboard.SendKeyEvent
function GUIScoreboard:SendKeyEvent(key, down)
	local ret = originalScoreboardSKE(self, key, down)

	if GetIsBinding(key, "Scoreboard") and not down then
		self.hoverMenu:Hide()
	end

	if self.visible and self.hoverMenu.background:GetIsVisible() then

		local steamId = GetSteamIdForClientIndex(self.hoverPlayerClientIndex) or 0
		local function openObservatoryProf()
			Client.ShowWebpage(string.format("%s%s", kObservatoryUserURL, steamId))
		end

		local found = 0
		local added = false
		local teamColorBg = Color(0.5, 0.5, 0.5, 0.5)
		local teamColorHighlight = Color(0.75, 0.75, 0.75, 0.75)
		local textColor = Color(1, 1, 1, 1)
		for index, entry in ipairs(self.hoverMenu.links) do
			if not entry.isSeparator then
				local text = entry.link:GetText()
				if text == Locale.ResolveString("SB_MENU_STEAM_PROFILE") then
					teamColorBg = entry.bgColor
					teamColorHighlight = entry.bgHighlightColor
					found = index
				elseif text == "Observatory profile" then
					added = true
				end
			end
		end

		if not added then
			if found > 0 then
				found = found + 1
			else
				found = nil
			end

			-- Don't add the button if we can't find the one we expect
			if found then
				self.hoverMenu:AddButton("Observatory profile", teamColorBg, teamColorHighlight, textColor, openObservatoryProf, found)

				-- Calling the show function will reposition the menu (in case we're out of the window)
				self.hoverMenu:Show()
			end
		end
	end

	return ret
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
