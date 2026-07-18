-- ProductionService.lua
-- Los lugares producen cosas con el tiempo.
-- Panaderia: consume HARINA para producir pan (si no hay harina, no hornea).
-- Molino: produce harina de la nada (por ahora; el maiz es el siguiente eslabon).

local World = require(script.Parent.World)

local ProductionService = {}

-- Panaderia
local BAKERY_INTERVAL = 300
local BAKERY_MAX = 5

-- Molino
local MILL_INTERVAL = 180
local MILL_MAX = 8

function ProductionService.update(dt)
	local bakery = World.places.Bakery
	local mill = World.places.Mill

	-- === Panaderia: harina -> pan ===
	bakery.ProductionTimer = (bakery.ProductionTimer or 0) + dt
	while bakery.ProductionTimer >= BAKERY_INTERVAL do
		bakery.ProductionTimer = bakery.ProductionTimer - BAKERY_INTERVAL
		if bakery.Bread < BAKERY_MAX and bakery.Flour > 0 then
			bakery.Flour = bakery.Flour - 1
			bakery.Bread = bakery.Bread + 1
			print(string.format("[PRODUCCION] Panaderia horneo pan (uso 1 harina). Pan: %d/%d, Harina restante: %d",
				bakery.Bread, BAKERY_MAX, bakery.Flour))
		elseif bakery.Bread < BAKERY_MAX and bakery.Flour <= 0 then
			print("[SECA] Panaderia quiere hornear pero NO tiene harina.")
		end
	end

	-- === Molino: produce harina ===
	mill.ProductionTimer = (mill.ProductionTimer or 0) + dt
	while mill.ProductionTimer >= MILL_INTERVAL do
		mill.ProductionTimer = mill.ProductionTimer - MILL_INTERVAL
		if mill.Flour < MILL_MAX then
			mill.Flour = mill.Flour + 1
			print(string.format("[PRODUCCION] Molino molio harina. Harina: %d/%d",
				mill.Flour, MILL_MAX))
		end
	end
end

return ProductionService