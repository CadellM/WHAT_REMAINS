-- Main.server.lua
-- Vagar + cadena de suministros (primer eslabon: la panaderia produce pan sola).

local RunService = game:GetService("RunService")
local EntityStore = require(script.Parent.EntityStore)
local NeedService = require(script.Parent.NeedService)
local DecisionService = require(script.Parent.DecisionService)
local ActionService = require(script.Parent.ActionService)
local World = require(script.Parent.World)
local ProductionService = require(script.Parent.ProductionService)

local FIXED_DT = 1.0
local TIME_SCALE = 60
local SECONDS_PER_YEAR = 40 * 60

local worldTime = 0

local function step(dt)
	worldTime = worldTime + dt

	-- El mundo produce (panaderia hornea pan, etc.) antes de que actuen los NPC.
	ProductionService.update(dt)

	for _, entity in pairs(EntityStore.getAll()) do
		if entity.Controller == "AI" then
			entity.Age = entity.Age + dt / SECONDS_PER_YEAR
			NeedService.update(entity, dt)

			-- 1. Si tiene una accion en curso, avanzala (viaje o paseo).
			ActionService.tick(entity, dt, worldTime)

			-- 2. Si quedo libre, que decida algo nuevo.
			if entity.CurrentAction == nil then
				local action = DecisionService.decide(entity, worldTime)
				if action then
					entity.CurrentAction = action
					if action.Type == "TravelToEat" then
						print(string.format("[DECISION] %s decide viajar a %s (%.0f de distancia).",
							entity.Id, action.TargetPlace, action.Distance))
					elseif action.Type == "Wander" then
						print(string.format("[DECISION] %s decide vagar hacia (%.0f,%.0f).",
							entity.Id, action.Destination.x, action.Destination.y))
					end
				end
			end
		end
	end
end

-- === Arranque ===
local first = EntityStore.create()
print(string.format("[NACIMIENTO] %s existe. Controller=%s Edad=%.2f Hambre=%.0f Pos=(%.0f,%.0f)",
	first.Id, first.Controller, first.Age, first.Needs.Hunger, first.Position.x, first.Position.y))
print(string.format("[MUNDO] Panaderia en (%.0f,%.0f) con %d panes.",
	World.places.Bakery.Position.x, World.places.Bakery.Position.y, World.places.Bakery.Bread))

-- === El reloj vivo ===
local accumulator = 0
local logTimer = 0

RunService.Heartbeat:Connect(function(realDelta)
	accumulator = accumulator + realDelta * TIME_SCALE
	while accumulator >= FIXED_DT do
		step(FIXED_DT)
		accumulator = accumulator - FIXED_DT
	end

	logTimer = logTimer + realDelta
	if logTimer >= 1 then
		logTimer = logTimer - 1
		local a = first.CurrentAction
		local estado = a and ("viajando, faltan %.0f"):format(a.Remaining) or "libre"
		print(string.format("[TICK] mundo=%.0f | %s Hambre=%.0f Pos=(%.0f,%.0f) [%s]",
			worldTime, first.Id, first.Needs.Hunger, first.Position.x, first.Position.y, estado))
	end
end)
