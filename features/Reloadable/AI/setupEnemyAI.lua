local GravityMap = require("features/Reloadable/AI/GravityMap")
local world = GAME:getWorld()

local primaryDirection   = { }
local secondaryDirection = { }

local frightenedMap = GravityMap:new()
local calmMap = GravityMap:new()

local function followPlayer1(name)
    local frienemy = world:getPactor(name)
    if frienemy then
        local player1Pos = { row = world:getRowOf("PLAYER1"),  col = world:getColOf("PLAYER1") }
        local myPos      = { row = world:getRowOf(name), col = world:getColOf(name) }
        
        if player1Pos.row < myPos.row and world:canPactorMoveInDirection(name, "UP") then
            primaryDirection[name] = "UP"
        elseif player1Pos.row > myPos.row and world:canPactorMoveInDirection(name, "DOWN") then
            primaryDirection[name] = "DOWN"
        end
        
        if player1Pos.col < myPos.col and world:canPactorMoveInDirection(name, "LEFT") then
            primaryDirection[name] = "LEFT"
        elseif player1Pos.col > myPos.col and world:canPactorMoveInDirection(name, "RIGHT") then
            primaryDirection[name] = "RIGHT"
        end
    end
end

local function enemyTick()
    followPlayer1("FRIENEMY")
end

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

local function tickPactorAI(myName)
    local gravityMap
    local pactor = world:getPactor(myName)
    
    if pactor:getValueOf("IS_FRIGHTENED") then
        gravityMap = frightenedMap
    else
        gravityMap = calmMap
    end

    primaryDirection[myName] = gravityMap:bestMove(myName)
    secondaryDirection[myName] = gravityMap:bestSecondaryMove(myName)
end

local function enemyTickWithGravityMap()
    tickGravityMap()
    local enemiesInfo = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    for i = 1, enemiesInfo.length do
        local pactor = GAME:getPactor(enemiesInfo[i]:getValueOf("NAME"))
        tickPactorAI(pactor:getValueOf("NAME"))
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