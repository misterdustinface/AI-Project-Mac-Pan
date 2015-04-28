local function callAllAITicks()
    ENEMY_TICK()
    PLAYER_TICK()
end

AI_TICK = callAllAITicks