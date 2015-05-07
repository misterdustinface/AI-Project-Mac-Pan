local function callPlayerAITick()
    PLAYER_TICK()
end

local function callAllEnemyAITicks()
    ENEMY_TICK()
end

local function performAllAIMoves()
    ENEMY_PERFORM()
    PLAYER_PERFORM()
end

PLAYER_AI_TICK = callPlayerAITick
AI_TICK        = callAllEnemyAITicks
AI_PERFORM     = performAllAIMoves

AI_TICK_LOOP:setUpdatesPerSecond(15)
PLAYER_AI_TICK_LOOP:setUpdatesPerSecond(15)