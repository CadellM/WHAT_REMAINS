-- Time.lua
-- Fuente unica de verdad para las escalas de tiempo del mundo.
-- Aqui viven las PROPORCIONES reales (dia, anio, vidas).
-- La VELOCIDAD de prueba NO vive aqui: esa es TIME_SCALE en Main (la perilla).
-- Todo se mide en "segundos-mundo".

local Time = {}

-- === Escalas base (proporciones reales del juego) ===
-- 1 dia-noche completo = 20 minutos de juego.
Time.SECONDS_PER_DAY = 20 * 60      -- 1200 seg-mundo
-- 1 anio = 40 minutos de juego = 2 dias.
Time.SECONDS_PER_YEAR = 40 * 60     -- 2400 seg-mundo

-- === Esperanzas de vida (en anios) ===
Time.PLAYER_MAX_AGE = 75            -- tope duro del jugador
Time.NPC_MIN_LIFESPAN = 75         -- el NPC vive al menos esto...
Time.NPC_MAX_LIFESPAN = 100        -- ...y a lo mucho esto (con azar)

-- === Embarazo ===
-- Dura entre 1 y 2 dias-mundo (promedio ~1.5 dias = ~30 min de juego).
-- Como todo, con variacion individual: unos embarazos mas cortos, otros mas largos.
Time.PREGNANCY_MIN = 1 * Time.SECONDS_PER_DAY   -- 1 dia-mundo
Time.PREGNANCY_MAX = 2 * Time.SECONDS_PER_DAY   -- 2 dias-mundo

-- === Emparejamiento ===
-- Probabilidad POR SEGUNDO-MUNDO de que dos NPCs compatibles cercanos se emparejen.
-- Anclada a dt (no al tick), asi la perilla de velocidad no altera el ritmo real.
-- Valor ALTO para pruebas (ver parejas pronto); bajalo luego al ritmo de juego.
Time.MATING_CHANCE_PER_SECOND = 0.02

-- Rango de edad fertil.
Time.FERTILE_MIN_AGE = 18
Time.FERTILE_MAX_AGE = 45

-- === Vitalidad ===
-- El hambre empieza a drenar vitalidad cuando pasa este umbral (hambriento de verdad).
Time.STARVATION_HUNGER_THRESHOLD = 100   -- solo al maximo, como pediste
-- Cuanta vitalidad se drena por segundo-mundo mientras el hambre esta al maximo.
Time.STARVATION_DRAIN_PER_SECOND = 0.05
-- Cuanta vitalidad se recupera por segundo-mundo cuando esta bien alimentado.
Time.VITALITY_RECOVER_PER_SECOND = 0.03
-- El NPC se considera "bien alimentado" (y recupera vitalidad) bajo este umbral de hambre.
Time.WELL_FED_HUNGER_THRESHOLD = 50

-- Genera una duracion de embarazo al azar, en segundos-mundo.
function Time.rollPregnancyDuration()
	return math.random(Time.PREGNANCY_MIN, Time.PREGNANCY_MAX)
end

-- Convierte anios a segundos-mundo.
function Time.yearsToSeconds(years)
	return years * Time.SECONDS_PER_YEAR
end

-- Convierte segundos-mundo a anios.
function Time.secondsToYears(seconds)
	return seconds / Time.SECONDS_PER_YEAR
end

-- Dado un worldTime, devuelve que dia del mundo es (dia 1, 2, 3...).
function Time.getDay(worldTime)
	return math.floor(worldTime / Time.SECONDS_PER_DAY) + 1
end

-- Dado un worldTime, dice si es de dia o de noche.
-- Primera mitad del ciclo = dia, segunda mitad = noche.
function Time.isDaytime(worldTime)
	local intoDay = worldTime % Time.SECONDS_PER_DAY
	return intoDay < (Time.SECONDS_PER_DAY / 2)
end

-- Genera una esperanza de vida al azar para un NPC nuevo, en anios.
function Time.rollNpcLifespan()
	return math.random(Time.NPC_MIN_LIFESPAN, Time.NPC_MAX_LIFESPAN)
end

return Time