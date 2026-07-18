-- World.lua
-- Los lugares que existen en el mundo, con posicion y recursos.
-- Por ahora solo una panaderia con un stock de pan.

local World = {}

World.places = {
	Bakery = {
		Id = "Bakery",
		Position = { x = 50, y = 0 },
		Bread = 3,
		Flour = 2,          -- harina disponible para hornear (se consume!)
	},

	Mill = {
		Id = "Mill",
		Position = { x = -60, y = 20 },
		Flour = 0,          -- harina lista para despachar
	},
}

-- Distancia en linea recta entre dos posiciones {x, y}.
function World.distance(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

return World