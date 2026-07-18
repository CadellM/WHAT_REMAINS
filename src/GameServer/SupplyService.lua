-- SupplyService.lua
-- Mueve recursos entre lugares con un TIEMPO DE ENTREGA.
-- No hay repartidor fisico: es una transferencia con retardo.
-- El molino "despacha" harina; llega a la panaderia unos segundos-mundo despues.

local World = require(script.Parent.World)

local SupplyService = {}

-- Cada cuanto el molino despacha harina hacia la panaderia.
local DISPATCH_INTERVAL = 200
-- Cuanto tarda un envio en llegar (el "en transito").
local DELIVERY_TIME = 150
-- Cuanta harina manda por envio.
local DISPATCH_AMOUNT = 2

-- Lista de envios que van "en camino" (cada uno con su tiempo restante).
local shipments = {}

function SupplyService.update(dt)
	local mill = World.places.Mill
	local bakery = World.places.Bakery

	-- 1. El molino acumula tiempo y despacha harina cada intervalo.
	mill.DispatchTimer = (mill.DispatchTimer or 0) + dt
	while mill.DispatchTimer >= DISPATCH_INTERVAL do
		mill.DispatchTimer = mill.DispatchTimer - DISPATCH_INTERVAL
		if mill.Flour >= DISPATCH_AMOUNT then
			mill.Flour = mill.Flour - DISPATCH_AMOUNT
			table.insert(shipments, {
				amount = DISPATCH_AMOUNT,
				remaining = DELIVERY_TIME,  -- tiempo que le falta para llegar
			})
			print(string.format("[ENVIO] Molino despacho %d harina. Llega en %d seg. (Molino restante: %d)",
				DISPATCH_AMOUNT, DELIVERY_TIME, mill.Flour))
		end
	end

	-- 2. Avanza los envios en transito. Los que llegan, entregan su harina.
	for i = #shipments, 1, -1 do  -- de atras hacia adelante para poder remover
		local ship = shipments[i]
		ship.remaining = ship.remaining - dt
		if ship.remaining <= 0 then
			bakery.Flour = bakery.Flour + ship.amount
			print(string.format("[ENTREGA] Llegaron %d harina a la panaderia. (Panaderia harina: %d)",
				ship.amount, bakery.Flour))
			table.remove(shipments, i)
		end
	end
end

return SupplyService