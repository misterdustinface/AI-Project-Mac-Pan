local function callAllAITicks()
    ENEMY_TICK()
    PLAYER_TICK()
end

local function performAllAIMoves()
    ENEMY_PERFORM()
    PLAYER_PERFORM()
end

AI_TICK = callAllAITicks
AI_PERFORM = performAllAIMoves

AI_TICK_LOOP:setUpdatesPerSecond(30)