-- EntityStore.lua
-- El lugar central donde viven TODAS las entidades del mundo.
-- Crea entidades, las guarda, y te deja consultarlas.
-- Es la unica fuente de verdad sobre quien existe en el mundo.

local Entity = require(script.Parent.Entity)

local EntityStore = {}

-- Aqui adentro se guardan todas las entidades, por su Id.
-- Ej: entities["entity_001"] = { ...la entidad... }
local entities = {}

-- Contador para dar Ids unicos automaticos: entity_001, entity_002, etc.
local nextNumber = 1

-- Crea una entidad nueva, la guarda en el store, y la devuelve.
function EntityStore.create()
	-- Arma un Id con ceros a la izquierda: entity_001, entity_002...
	local id = string.format("entity_%03d", nextNumber)
	nextNumber = nextNumber + 1

	local newEntity = Entity.new(id)
	entities[id] = newEntity
	return newEntity
end

-- Devuelve una entidad por su Id (o nil si no existe).
function EntityStore.get(id)
	return entities[id]
end

-- Devuelve la tabla completa de entidades, para recorrerlas todas.
function EntityStore.getAll()
	return entities
end

-- Cuenta cuantas entidades existen ahora mismo.
function EntityStore.count()
	local total = 0
	for _ in pairs(entities) do
		total = total + 1
	end
	return total
end

return EntityStore
