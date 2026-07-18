-- World.lua
-- Los lugares que existen en el mundo, con posicion y recursos.
-- Por ahora solo una panaderia con un stock de pan.

local World = {}

World.places = {
	Bakery = {
		Id = "Bakery",
		Position = { x = 50, y = 0 },  -- lejos del origen: hay que viajar
		Bread = 3,                     -- stock inicial de pan (se agota!)
	},
}

-- Distancia en linea recta entre dos posiciones {x, y}.
function World.distance(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

return World