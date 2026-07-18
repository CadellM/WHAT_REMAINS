-- PerceptionService.lua
-- Permite a un NPC percibir a OTROS NPCs cercanos.
-- Es la primera vez que un ser del mundo es consciente de otro ser.
-- Sobre esto se construye todo lo social: emparejarse, preguntar, comerciar.

local EntityStore = require(script.Parent.EntityStore)
local World = require(script.Parent.World)

local PerceptionService = {}

-- Que tan lejos "ve" un NPC a otro (en unidades de distancia del mundo).
local PERCEPTION_RANGE = 20

-- Devuelve una lista de los NPCs cercanos a 'entity' (sin incluirse a si mismo).
function PerceptionService.getNearby(entity)
	local nearby = {}
	for _, other in pairs(EntityStore.getAll()) do
		if other.Id ~= entity.Id then
			local dist = World.distance(entity.Position, other.Position)
			if dist <= PERCEPTION_RANGE then
				table.insert(nearby, other)
			end
		end
	end
	return nearby
end

return PerceptionService