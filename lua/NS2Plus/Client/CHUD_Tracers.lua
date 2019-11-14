local oldTriggerFirstPersonTracer = TriggerFirstPersonTracer
function TriggerFirstPersonTracer(weapon, endPosition)
	if not CHUDGetOption("tracers") then return end

	return oldTriggerFirstPersonTracer(weapon, endPosition)
end
