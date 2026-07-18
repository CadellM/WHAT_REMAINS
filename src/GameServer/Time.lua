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