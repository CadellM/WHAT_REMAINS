-- Entity.lua
-- Define que ES una entidad en el mundo.
-- Toda persona del mundo -- la maneje un humano o la IA -- es una Entity.
-- No hay "clase Jugador" y "clase NPC" separadas: hay UNA entidad
-- con un campo Controller que dice quien la conduce.

local Time = require(script.Parent.Time)

local Entity = {}

-- Crea una entidad nueva con valores por defecto.
-- id: un texto unico que la identifica, ej. "entity_001"
function Entity.new(id)
	return {
		Id = id,
		Controller = "AI",
		-- Genero al azar: mismo molde, valor distinto. La variacion vive en el dato.
		Sex = (math.random() < 0.5) and "M" or "F",
		Age = 15,
		Lifespan = Time.rollNpcLifespan(),
		HoursLived = 0,
		Needs = { Hunger = 30 },
		Position = { x = 0, y = 0 },
		CurrentAction = nil,
		WaitUntil = 0,
	}
end

return Entity