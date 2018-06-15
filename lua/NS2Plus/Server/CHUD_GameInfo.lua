local originalGameInfo
originalGameInfo = Class_ReplaceMethod( "GameInfo", "OnCreate",
	function(self)
		
		originalGameInfo(self)
		
		self.showAvgSkill = CHUDServerOptions["show_avgteamskill"].currentValue == true
		self.showProbability = CHUDServerOptions["show_probabilityofteamvictory"].currentValue == true
		self.showPlayerSkill = CHUDServerOptions["show_playerskill"].currentValue == true
		self.showEndStatsAuto = CHUDServerOptions["autodisplayendstats"].currentValue == true
		self.showEndStatsTeamBreakdown = CHUDServerOptions["endstatsteambreakdown"].currentValue == true
		
	end)

CHUDServerOptions["show_avgteamskill"].applyFunction = function()
		GetGameInfoEntity().showAvgSkill = CHUDServerOptions["show_avgteamskill"].currentValue
	end
CHUDServerOptions["show_probabilityofteamvictory"].applyFunction = function()
		GetGameInfoEntity().showProbability = CHUDServerOptions["show_probabilityofteamvictory"].currentValue
	end
CHUDServerOptions["show_playerskill"].applyFunction = function()
		GetGameInfoEntity().showPlayerSkill = CHUDServerOptions["show_playerskill"].currentValue
	end
CHUDServerOptions["autodisplayendstats"].applyFunction = function()
		GetGameInfoEntity().showEndStatsAuto = CHUDServerOptions["autodisplayendstats"].currentValue
	end
CHUDServerOptions["endstatsteambreakdown"].applyFunction = function()
		GetGameInfoEntity().showEndStatsTeamBreakdown = CHUDServerOptions["endstatsteambreakdown"].currentValue
	end