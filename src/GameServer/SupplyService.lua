-- SupplyService.lua
-- Mueve recursos entre lugares con TIEMPO DE ENTREGA (sin repartidor fisico).
-- Dos rutas ahora:
--   Cosecha -> Molino (maiz)
--   Molino  -> Panaderia (harina)

local World = require(script.Parent.World)

local SupplyService = {}

-- Ruta harina: Molino -> Panaderia
local FLOUR_DISPATCH_INTERVAL = 200
local FLOUR_DELIVERY_TIME = 150
local FLOUR_DISPATCH_AMOUNT = 2

-- Ruta maiz: Cosecha -> Molino
local CORN_DISPATCH_INTERVAL = 170
local CORN_DELIVERY_TIME = 120
local CORN_DISPATCH_AMOUNT = 2

-- Envios en transito.
local shipments = {}

function SupplyService.update(dt)
	local farm = World.places.Farm
	local mill = World.places.Mill
	local bakery = World.places.Bakery

	-- 1. Cosecha despacha maiz hacia el molino.
	farm.DispatchTimer = (farm.DispatchTimer or 0) + dt
	while farm.DispatchTimer >= CORN_DISPATCH_INTERVAL do
		farm.DispatchTimer = farm.DispatchTimer - CORN_DISPATCH_INTERVAL
		if farm.Corn >= CORN_DISPATCH_AMOUNT then
			farm.Corn = farm.Corn - CORN_DISPATCH_AMOUNT
			table.insert(shipments, {
				resource = "Corn",
				target = "Mill",
				amount = CORN_DISPATCH_AMOUNT,
				remaining = CORN_DELIVERY_TIME,
			})
			print(string.format("[ENVIO] Cosecha despacho %d maiz al molino. Llega en %d seg. (Cosecha: %d)",
				CORN_DISPATCH_AMOUNT, CORN_DELIVERY_TIME, farm.Corn))
		end
	end

	-- 2. Molino despacha harina hacia la panaderia.
	mill.DispatchTimer = (mill.DispatchTimer or 0) + dt
	while mill.DispatchTimer >= FLOUR_DISPATCH_INTERVAL do
		mill.DispatchTimer = mill.DispatchTimer - FLOUR_DISPATCH_INTERVAL
		if mill.Flour >= FLOUR_DISPATCH_AMOUNT then
			mill.Flour = mill.Flour - FLOUR_DISPATCH_AMOUNT
			table.insert(shipments, {
				resource = "Flour",
				target = "Bakery",
				amount = FLOUR_DISPATCH_AMOUNT,
				remaining = FLOUR_DELIVERY_TIME,
			})
			print(string.format("[ENVIO] Molino despacho %d harina a la panaderia. Llega en %d seg. (Molino: %d)",
				FLOUR_DISPATCH_AMOUNT, FLOUR_DELIVERY_TIME, mill.Flour))
		end
	end

	-- 3. Avanza los envios en transito y entrega los que llegan.
	for i = #shipments, 1, -1 do
		local ship = shipments[i]
		ship.remaining = ship.remaining - dt
		if ship.remaining <= 0 then
			local place = World.places[ship.target]
			place[ship.resource] = (place[ship.resource] or 0) + ship.amount
			print(string.format("[ENTREGA] Llegaron %d %s a %s. (Total ahi: %d)",
				ship.amount, ship.resource, ship.target, place[ship.resource]))
			table.remove(shipments, i)
		end
	end
end

return SupplyService