-- MatingService.lua
-- Empareja NPCs compatibles que se perciben cerca.
-- Condiciones: sexo distinto, edad fertil, ambos libres, y probabilidad por dt.
-- Al emparejarse, enlaza las fichas de ambos (Partner).

local Time = require(script.Parent.Time)
local PerceptionService = require(script.Parent.PerceptionService)

local MatingService = {}

-- Revisa si un NPC cumple las condiciones basicas para poder emparejarse.
local function isEligible(entity)
	if entity.Partner ~= nil then return false end          -- ya tiene pareja
	if entity.Age < Time.FERTILE_MIN_AGE then return false end
	if entity.Age > Time.FERTILE_MAX_AGE then return false end
	return true
end

-- Revisa a un NPC contra sus vecinos y quiza forma pareja.
-- dt: segundos-mundo de este paso (para escalar la probabilidad).
function MatingService.update(entity, dt)
	-- El que evalua debe ser elegible.
	if not isEligible(entity) then return end

	local nearby = PerceptionService.getNearby(entity)
	for _, other in ipairs(nearby) do
		-- El otro tambien debe ser elegible y de sexo distinto.
		if isEligible(other) and other.Sex ~= entity.Sex then
			-- Probabilidad por segundo-mundo, escalada por dt.
			if math.random() < Time.MATING_CHANCE_PER_SECOND * dt then
				-- Se emparejan: enlazar ambas fichas.
				entity.Partner = other.Id
				other.Partner = entity.Id
				-- Si alguno era viudo, deja de estarlo al rehacer su vida.
				entity.IsWidowed = false
				other.IsWidowed = false
				print(string.format("[PAREJA] %s (%s, %.0f) y %s (%s, %.0f) formaron pareja.",
					entity.Id, entity.Sex, entity.Age,
					other.Id, other.Sex, other.Age))
				return  -- ya se emparejo, no seguir buscando
			end
		end
	end
end

return MatingService