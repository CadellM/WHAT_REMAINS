-- VitalityService.lua
-- Maneja la vitalidad: baja cuando el hambre esta al maximo, se recupera
-- cuando el NPC esta bien alimentado. Si llega a 0, el NPC muere de hambre.
-- Hoy solo el hambre la afecta; ataques y veneno se sumaran aqui despues.

local Time = require(script.Parent.Time)

local VitalityService = {}

-- Actualiza la vitalidad de una entidad por 'dt'. Devuelve true si murio de hambre.
function VitalityService.update(entity, dt)
	local hunger = entity.Needs.Hunger

	if hunger >= Time.STARVATION_HUNGER_THRESHOLD then
		-- Hambre al maximo: se drena la vitalidad.
		entity.Vitality = entity.Vitality - Time.STARVATION_DRAIN_PER_SECOND * dt
	elseif hunger <= Time.WELL_FED_HUNGER_THRESHOLD then
		-- Bien alimentado: recupera vitalidad, sin pasar de 100.
		entity.Vitality = math.min(100, entity.Vitality + Time.VITALITY_RECOVER_PER_SECOND * dt)
	end
	-- (Entre los dos umbrales, la vitalidad se queda estable.)

	-- Muerte por vitalidad agotada.
	if entity.Vitality <= 0 then
		entity.Vitality = 0
		print(string.format("[MUERTE] %s murio de hambre a los %.1f anios (vitalidad agotada).",
			entity.Id, entity.Age))
		return true
	end

	return false
end

return VitalityService