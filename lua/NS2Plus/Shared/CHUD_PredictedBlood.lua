if Client then
	local oldDamageMixinDoDamage = DamageMixin.DoDamage
	local oldHandleHitEffect = HandleHitEffect
	function DamageMixin:DoDamage(damage, target, point, direction, surface, altMode, showtracer)        
		if not CHUDGetOption("serverblood") or not target then         
			return oldDamageMixinDoDamage(self, damage, target, point, direction, surface, altMode, showtracer)
		else
			HandleHitEffect = function() end
			local killedFromDamage = oldDamageMixinDoDamage(self, damage, target, point, direction, surface, altMode, showtracer)
			HandleHitEffect = oldHandleHitEffect
			return killedFromDamage
		end
	end
elseif Server then
	local function OnSetCHUDServerBlood(client, message)

		if client then
			local player = client:GetControllingPlayer()
			if player and message ~= nil then
				player.serverblood = message.serverblood
			end
		end

	end

	Server.HookNetworkMessage("SetCHUDServerBlood", OnSetCHUDServerBlood)

	local oldBuildHitEffectMessage = BuildHitEffectMessage
	
	function BuildHitEffectMessage(position, doer, surface, target, showtracer, altMode, damage, direction)
		local attacker = doer
		local parent = doer:GetParent()

		if doer:isa("Player") then
			attacker = doer
		elseif parent and parent:isa("Player") then
			attacker = parent
		elseif HasMixin(doer, "Owner") and parent and parent:isa("Player") then
			attacker = doer:GetOwner()
		end

		local message
		if attacker and attacker.serverblood and parent == attacker and target then
			message = oldBuildHitEffectMessage(position, doer, surface, target, false, altMode, damage, direction)
			Server.SendNetworkMessage(attacker, "HitEffect", message, false)
		end

		if message and not showtracer then -- don't call oldBuildHitEffectMessage twice with same arguments
			return message
		end

		return oldBuildHitEffectMessage(position, doer, surface, target, showtracer, altMode, damage, direction)
	end

end