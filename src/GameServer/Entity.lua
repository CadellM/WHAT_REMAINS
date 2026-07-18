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
		Sex = (math.random() < 0.5) and "M" or "F",
		Age = 15,
		Lifespan = Time.rollNpcLifespan(),
		HoursLived = 0,
		Needs = { Hunger = 30 },
		-- Vitalidad: que tan vivo estas. Baja por hambre extrema (y luego ataques, veneno...).
		-- Si llega a 0, muere. Es el punto unico de dano del que penden todas las amenazas.
		Vitality = 100,
		Position = { x = 0, y = 0 },
		CurrentAction = nil,
		WaitUntil = 0,

		-- === Pareja y linaje (sembrados vacios; los sistemas los llenan despues) ===

		-- Pareja actual: el Id del NPC con quien esta emparejado, o nil si esta libre.
		Partner = nil,

		-- Linaje: quienes son sus padres, y quienes son sus hijos.
		-- Parents guarda los Ids de mama y papa. Children, la lista de Ids de sus hijos.
		-- Esto es el arbol genealogico que el sistema de sucesor usara en el futuro.
		Parents = {},
		Children = {},

		-- Viudez con memoria: parejas que tuvo y perdio (murieron).
		-- Guarda sus Ids. De aqui sale "recordar a quien amo".
		FormerPartners = {},

		-- Marca de viudo: cuando su pareja muere, esto se pone en true.
		-- Reduce (de forma fija por ahora) su chance de reemparejarse.
		IsWidowed = false,

		-- Estado de embarazo: nil si no esta embarazada. Cuando lo esta,
		-- guarda datos de la gestacion (cuanto falta, quien es el otro progenitor).
		Pregnancy = nil,
	}
end

return Entity