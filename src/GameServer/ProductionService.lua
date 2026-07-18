-- ProductionService.lua
-- Cadena completa de produccion:
--   Cosecha: produce maiz de la nada (primer eslabon, la semilla).
--   Molino: consume MAIZ para producir harina (si no hay maiz, no muele).
--   Panaderia: consume HARINA para producir pan (si no hay harina, no hornea).

local World = require(script.Parent.World)

local ProductionService = {}

-- Panaderia
local BAKERY_INTERVAL = 300
local BAKERY_MAX = 5

-- Molino
local MILL_INTERVAL = 180
local MILL_MAX = 8

-- Cosecha
local FARM_INTERVAL = 160
local FARM_MAX = 10

function ProductionService.update(dt)
	local bakery = World.places.Bakery
	local mill = World.places.Mill
	local farm = World.places.Farm

	-- === Panaderia: harina -> pan ===
	bakery.ProductionTimer = (bakery.ProductionTimer or 0) + dt
	while bakery.ProductionTimer >= BAKERY_INTERVAL do
		bakery.ProductionTimer = bakery.ProductionTimer - BAKERY_INTERVAL
		if bakery.Bread < BAKERY_MAX and bakery.Flour > 0 then
			bakery.Flour = bakery.Flour - 1
			bakery.Bread = bakery.Bread + 1
			print(string.format("[PRODUCCION] Panaderia horneo pan (uso 1 harina). Pan: %d/%d, Harina: %d",
				bakery.Bread, BAKERY_MAX, bakery.Flour))
		elseif bakery.Bread < BAKERY_MAX and bakery.Flour <= 0 then
			print("[SECA] Panaderia quiere hornear pero NO tiene harina.")
		end
	end

	-- === Molino: maiz -> harina ===
	mill.ProductionTimer = (mill.ProductionTimer or 0) + dt
	while mill.ProductionTimer >= MILL_INTERVAL do
		mill.ProductionTimer = mill.ProductionTimer - MILL_INTERVAL
		if mill.Flour < MILL_MAX and mill.Corn > 0 then
			mill.Corn = mill.Corn - 1
			mill.Flour = mill.Flour + 1
			print(string.format("[PRODUCCION] Molino molio harina (uso 1 maiz). Harina: %d/%d, Maiz: %d",
				mill.Flour, MILL_MAX, mill.Corn))
		elseif mill.Flour < MILL_MAX and mill.Corn <= 0 then
			print("[SECA] Molino quiere moler pero NO tiene maiz.")
		end
	end

	-- === Cosecha: produce maiz ===
	farm.ProductionTimer = (farm.ProductionTimer or 0) + dt
	while farm.ProductionTimer >= FARM_INTERVAL do
		farm.ProductionTimer = farm.ProductionTimer - FARM_INTERVAL
		if farm.Corn < FARM_MAX then
			farm.Corn = farm.Corn + 1
			print(string.format("[PRODUCCION] Cosecha produjo maiz. Maiz: %d/%d",
				farm.Corn, FARM_MAX))
		end
	end
end

return ProductionService