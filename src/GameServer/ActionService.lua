-- ActionService.lua
-- Ejecuta la accion en curso. Al fallar, hace esperar a la entidad
-- para que no reintente lo imposible miles de veces por segundo.

local World = require(script.Parent.World)

local ActionService = {}

local SPEED = 4
local EAT_AMOUNT = 60
local WAIT_AFTER_FAIL = 120  -- segundos-mundo de espera tras un fallo

-- Recibe worldTime para poder programar la espera tras un fallo.
function ActionService.tick(entity, dt, worldTime)
	local action = entity.CurrentAction
	if action == nil then return end

	if action.Type == "TravelToEat" then
		action.Remaining = action.Remaining - SPEED * dt

		if action.Remaining <= 0 then
			entity.Position = { x = action.Destination.x, y = action.Destination.y }

			local place = World.places[action.TargetPlace]
			if place.Bread > 0 then
				place.Bread = place.Bread - 1
				local before = entity.Needs.Hunger
				entity.Needs.Hunger = math.max(0, before - EAT_AMOUNT)
				print(string.format("[LLEGADA] %s llego a %s. Pan disponible.",
					entity.Id, action.TargetPlace))
				print(string.format("[COMER] %s comio. Hambre %.0f -> %.0f. Pan restante: %d",
					entity.Id, before, entity.Needs.Hunger, place.Bread))
			else
				-- FALLO: no habia pan. Que espere antes de reintentar.
				entity.WaitUntil = worldTime + WAIT_AFTER_FAIL
				print(string.format("[FALLO] %s llego a %s pero NO habia pan. Esperara %d seg antes de reintentar.",
					entity.Id, action.TargetPlace, WAIT_AFTER_FAIL))
			end

entity.CurrentAction = nil
		end

	elseif action.Type == "Wander" then
		-- Vagar: caminar hacia un punto al azar. Al llegar, solo termina.
		action.Remaining = action.Remaining - SPEED * dt
		if action.Remaining <= 0 then
			entity.Position = { x = action.Destination.x, y = action.Destination.y }
			print(string.format("[VAGAR] %s llego a su paseo en (%.0f,%.0f).",
				entity.Id, entity.Position.x, entity.Position.y))
			entity.CurrentAction = nil
		end
	end
end

return ActionService