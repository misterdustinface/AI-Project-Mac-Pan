local GravityMap = require("features/Reloadable/AI/GravityMap")
local world = GAME:getWorld()
math.randomseed(os.time())

local primaryDirection   = { }
local secondaryDirection = { }

local isFleeing = { }
local fleeTicks = { }
-- local fleeCorner = { } --"CORNER1", "CORNER2", "CORNER3", "CORNER4"


local frightenedMap = GravityMap:new()
local calmMap = GravityMap:new()

local function degenerate(weight, depth)
    return weight / (depth+1)
end

local function tickGravityMap()
    frightenedMap:setWeights({ PLAYER = -9000 })
    frightenedMap:setDegeneracyFunction( degenerate )
    frightenedMap:generate()

    calmMap:setWeights({ PLAYER = 9000 })
    calmMap:setDegeneracyFunction( degenerate )
    calmMap:generate()
end

local function applyGravmapTo(myName)
    local gravityMap
    local pactor = world:getPactor(myName)

    if not isFleeing[myName] then
        isFleeing[myName] = (math.random(45) == 1)
        if isFleeing[myName] then
            fleeTicks[myName] = 3 + math.random(27)
        end
    end
    
    if pactor:getValueOf("IS_FRIGHTENED") or isFleeing[myName] then
        gravityMap = frightenedMap
    else
        gravityMap = calmMap
    end

    if isFleeing[myName] then
        fleeTicks[myName] = fleeTicks[myName] - 1
        if fleeTicks[myName] <= 0 then
            isFleeing[myName] = false
        end
    end

    primaryDirection[myName] = gravityMap:bestMove(myName)
--    secondaryDirection[myName] = gravityMap:bestSecondaryMove(myName)
end

local function enemyTickWithGravityMap()
    tickGravityMap()
    local enemiesInfo = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    for i = 1, enemiesInfo.length do
        local pactor = GAME:getPactor(enemiesInfo[i]:getValueOf("NAME"))
        applyGravmapTo(pactor:getValueOf("NAME"))
    end
end

local function forcePactorPerform(name)
    local pactor = world:getPactor(name)
    
    if not primaryDirection[name] then
        primaryDirection[name] = "NONE"
    end
    if not secondaryDirection[name] then
        secondaryDirection[name] = "NONE"
    end
    
    if pactor then    
        if pactor:getValueOf("DIRECTION") == "NONE" then
            pactor:performAction(primaryDirection[name])
        else
            pactor:performAction(primaryDirection[name])
            --pactor:performAction(secondaryDirection[name])
        end  
    end
end

local function forceEnemyPerform()
    local enemiesInfo = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    for i = 1, enemiesInfo.length do
        local pactor = GAME:getPactor(enemiesInfo[i]:getValueOf("NAME"))
        forcePactorPerform(pactor:getValueOf("NAME"))
    end
end

ENEMY_TICK    = enemyTickWithGravityMap
ENEMY_PERFORM = forceEnemyPerform