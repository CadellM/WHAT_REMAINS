-- Entity.lua
-- Define qué ES una entidad en el mundo.
-- Toda persona del mundo -- la maneje un humano o la IA -- es una Entity.
-- No hay "clase Jugador" y "clase NPC" separadas: hay UNA entidad
-- con un campo Controller que dice quién la conduce.

local Entity = {}

-- Crea una entidad nueva con valores por defecto.
-- id: un texto único que la identifica, ej. "entity_001"
function Entity.new(id)
	return {
		Id = id,
		Controller = "AI",
		Age = 15,
		HoursLived = 0,
		Needs = { Hunger = 30 },

		-- Donde esta la entidad en el mundo (coordenada abstracta).
		Position = { x = 0, y = 0 },

		-- La accion que esta ejecutando ahora mismo (o nil si esta libre).
		-- Mientras esto no sea nil, la entidad NO vuelve a decidir: esta ocupada.
		CurrentAction = nil,

		-- Momento-mundo hasta el cual la entidad espera antes de re-decidir.
		-- Evita que reintente lo mismo miles de veces en el mismo instante.
		WaitUntil = 0,
	}
end

return Entity

