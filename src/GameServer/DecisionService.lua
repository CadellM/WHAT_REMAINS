-- DecisionService.lua
-- Decide QUE quiere hacer una entidad segun sus necesidades.
-- Ahora respeta un tiempo de espera (WaitUntil) para no re-decidir sin parar.

local HUNGER_THRESHOLD = 80
local WANDER_CHANCE = 0.02  -- probabilidad por decision de salir a vagar
local World = require(script.Parent.World)

local DecisionService = {}

local HUNGER_THRESHOLD = 80

-- Recibe worldTime para saber si todavia esta "esperando".
function DecisionService.decide(entity, worldTime)
	-- Si esta ocupada, no decide nada nuevo.
	if entity.CurrentAction ~= nil then
		return nil
	end

	-- Si todavia esta en su tiempo de espera, no decide nada.
	if worldTime < entity.WaitUntil then
		return nil
	end

	-- PRIORIDAD 1: la necesidad manda. Si tiene hambre, va por comida.
	if entity.Needs.Hunger >= HUNGER_THRESHOLD then
		local bakery = World.places.Bakery
		local dist = World.distance(entity.Position, bakery.Position)
		return {
			Type = "TravelToEat",
			Destination = bakery.Position,
			TargetPlace = "Bakery",
			Distance = dist,
			Remaining = dist,
			Purpose = "Eat",
		}
	end

	-- PRIORIDAD 2: si esta tranquilo, vaga a un punto al azar.
	-- WANDER_CHANCE evita que decida vagar en CADA tick: solo a veces.
	if math.random() < WANDER_CHANCE then
		local target = {
			x = math.random(-40, 40),
			y = math.random(-40, 40),
		}
		local dist = World.distance(entity.Position, target)
		if dist > 1 then
			return {
				Type = "Wander",
				Destination = target,
				Distance = dist,
				Remaining = dist,
			}
		end
	end

	return nil
end

return DecisionService