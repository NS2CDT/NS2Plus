local originalGameInfo
originalGameInfo = Class_ReplaceMethod( "GameInfo", "OnCreate",
	function(self)
		
		originalGameInfo(self)

		self.showEndStatsAuto = CHUDServerOptions["autodisplayendstats"].currentValue == true
		self.showEndStatsTeamBreakdown = CHUDServerOptions["endstatsteambreakdown"].currentValue == true
		
	end)

CHUDServerOptions["autodisplayendstats"].applyFunction = function()
		GetGameInfoEntity().showEndStatsAuto = CHUDServerOptions["autodisplayendstats"].currentValue
	end
CHUDServerOptions["endstatsteambreakdown"].applyFunction = function()
		GetGameInfoEntity().showEndStatsTeamBreakdown = CHUDServerOptions["endstatsteambreakdown"].currentValue
	end