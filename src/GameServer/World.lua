-- World.lua
-- Los lugares que existen en el mundo, con posicion y recursos.
-- Por ahora solo una panaderia con un stock de pan.

local World = {}

World.places = {
	Bakery = {
		Id = "Bakery",
		Position = { x = 50, y = 0 },
		Bread = 3,
		Flour = 2,
	},

	Mill = {
		Id = "Mill",
		Position = { x = -60, y = 20 },
		Flour = 0,
		Corn = 2,           -- maiz disponible para moler (se consume!)
	},

	Farm = {
		Id = "Farm",
		Position = { x = -30, y = -70 },
		Corn = 0,           -- maiz listo para despachar al molino
	},
}

-- Distancia en linea recta entre dos posiciones {x, y}.
function World.distance(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

return World