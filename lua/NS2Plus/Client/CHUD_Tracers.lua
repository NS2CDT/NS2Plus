if Client then
	local old = CreateTracer
	function CreateTracer(startPoint, endPoint, velocity, doer, effectName, residueEffectName)
		if not CHUDGetOption("tracers") then
			return
		end

		return old(startPoint, endPoint, velocity, doer, effectName, residueEffectName)
	end
end
