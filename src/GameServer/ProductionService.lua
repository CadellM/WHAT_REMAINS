-- ProductionService.lua
-- Hace que los lugares PRODUZCAN cosas con el tiempo.
-- Primer eslabon: la panaderia produce pan sola, sin insumos todavia.
-- Este es el mecanismo base que luego se repite para molino y cosecha.

local World = require(script.Parent.World)

local ProductionService = {}

-- Cada cuanto (segundos-mundo) la panaderia produce un pan.
local BAKERY_INTERVAL = 300
local BAKERY_MAX = 5  -- no acumula mas de esto (capacidad de la tienda)

-- Avanza la produccion de todos los lugares por 'dt'.
function ProductionService.update(dt)
	local bakery = World.places.Bakery

	-- Acumula tiempo desde la ultima produccion.
	bakery.ProductionTimer = (bakery.ProductionTimer or 0) + dt

	-- Cada vez que pasa el intervalo, produce un pan (si hay espacio).
	while bakery.ProductionTimer >= BAKERY_INTERVAL do
		bakery.ProductionTimer = bakery.ProductionTimer - BAKERY_INTERVAL
		if bakery.Bread < BAKERY_MAX then
			bakery.Bread = bakery.Bread + 1
			print(string.format("[PRODUCCION] Panaderia horneo pan. Stock: %d/%d",
				bakery.Bread, BAKERY_MAX))
		end
	end
end

return ProductionService