-- MortalityService.lua
-- Revisa si un NPC alcanzo su esperanza de vida. Si si, muere.
-- Por ahora "morir" solo lo marca y lo saca del store. El linaje
-- y el Soul Archive vienen despues; este es el primer paso del ciclo
-- de muerte que sostiene la economia.

local MortalityService = {}

-- Revisa una entidad. Devuelve true si murio.
function MortalityService.check(entity)
	if entity.Age >= entity.Lifespan then
		print(string.format("[MUERTE] %s murio de viejo a los %.1f anios (esperanza: %d).",
			entity.Id, entity.Age, entity.Lifespan))
		return true
	end
	return false
end

return MortalityService