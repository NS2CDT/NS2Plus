local oldCreateTimeLimitedDecal = Client.CreateTimeLimitedDecal
function Client.CreateTimeLimitedDecal(materialName, coords, scale, lifeTime)

	if not lifeTime then
		lifeTime = Client.GetDefaultDecalLifetime() * CHUDGetOption("maxdecallifetime")
	end
	
	oldCreateTimeLimitedDecal(materialName, coords, scale, lifeTime)

end