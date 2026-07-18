-- Main.server.lua
-- Cadena de suministros + vagar + mortalidad por edad.
-- Las escalas de tiempo viven en Time.lua. TIME_SCALE es la perilla de velocidad.

local RunService = game:GetService("RunService")
local EntityStore = require(script.Parent.EntityStore)
local NeedService = require(script.Parent.NeedService)
local DecisionService = require(script.Parent.DecisionService)
local ActionService = require(script.Parent.ActionService)
local World = require(script.Parent.World)
local ProductionService = require(script.Parent.ProductionService)
local SupplyService = require(script.Parent.SupplyService)
local Time = require(script.Parent.Time)
local MortalityService = require(script.Parent.MortalityService)

local FIXED_DT = 1.0

-- === LA PERILLA DE VELOCIDAD ===
-- Cuantos segundos-mundo pasan por cada segundo real.
-- ALTA (600) = pruebas rapidas, ves NPCs morir en minutos.
-- Ponla en 1 para el ritmo real del juego. NO cambia ninguna proporcion.
local TIME_SCALE = 3000

local worldTime = 0

local function step(dt)
	worldTime = worldTime + dt

	-- El mundo produce y mueve recursos.
	ProductionService.update(dt)
	SupplyService.update(dt)

	for _, entity in pairs(EntityStore.getAll()) do
		if entity.Controller == "AI" then
			-- Envejecer por el reloj de anio.
			entity.Age = entity.Age + dt / Time.SECONDS_PER_YEAR

			-- Revisar si murio de viejo. Si si, sacarlo y no seguir procesandolo.
			if MortalityService.check(entity) then
				EntityStore.remove(entity.Id)
			else
				NeedService.update(entity, dt)
				ActionService.tick(entity, dt, worldTime)
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
end

-- === Arranque ===
local first = EntityStore.create()
print(string.format("[NACIMIENTO] %s existe. Controller=%s Edad=%.2f Esperanza=%d anios Hambre=%.0f",
	first.Id, first.Controller, first.Age, first.Lifespan, first.Needs.Hunger))
print(string.format("[MUNDO] Escala: 1 anio = %d seg-mundo, 1 dia = %d seg-mundo. Perilla: x%d.",
	Time.SECONDS_PER_YEAR, Time.SECONDS_PER_DAY, TIME_SCALE))

-- === El reloj vivo ===
local accumulator = 0
local logTimer = 0

local worldStopped = false

RunService.Heartbeat:Connect(function(realDelta)
	-- AUTOSTOP: si no queda ningun NPC, el mundo se detiene.
	-- Un mundo sin un solo ser no esta dormido: esta extinto. No hay nada que simular.
	if not worldStopped and EntityStore.count() == 0 then
		worldStopped = true
		print(string.format("[MUNDO EXTINTO] No queda ningun NPC. Mundo detenido en dia %d (mundo=%.0f seg).",
			Time.getDay(worldTime), worldTime))
		print("[NOTA] Aqui, en el futuro, se guardaria el estado final antes de cerrar.")
	end

	-- Si el mundo se detuvo, no simules nada mas.
	if worldStopped then
		return
	end

	accumulator = accumulator + realDelta * TIME_SCALE
	while accumulator >= FIXED_DT do
		step(FIXED_DT)
		accumulator = accumulator - FIXED_DT
	end

	logTimer = logTimer + realDelta
	if logTimer >= 1 then
		logTimer = logTimer - 1
		if EntityStore.get(first.Id) then
			print(string.format("[TICK] mundo=%.0f (dia %d, %s) | %s Edad=%.1f Hambre=%.0f",
				worldTime, Time.getDay(worldTime),
				Time.isDaytime(worldTime) and "dia" or "noche",
				first.Id, first.Age, first.Needs.Hunger))
		else
			print(string.format("[TICK] mundo=%.0f (dia %d) | %s ya murio.",
				worldTime, Time.getDay(worldTime), first.Id))
		end
	end
end)