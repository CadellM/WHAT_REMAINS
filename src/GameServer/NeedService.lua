-- NeedService.lua
-- Como cambian las necesidades con el tiempo. El hambre sube.
-- Atado al reloj diurno (rapido), no al de envejecimiento.

local NeedService = {}

local HUNGER_RATE = 0.1  -- puntos de hambre por segundo-mundo

function NeedService.update(entity, dt)
	local needs = entity.Needs
	needs.Hunger = math.min(100, needs.Hunger + HUNGER_RATE * dt)
end

return NeedService