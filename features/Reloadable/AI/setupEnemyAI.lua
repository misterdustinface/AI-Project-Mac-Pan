local world = GAME:getModifiableWorld()

local directions = {}

local function followPlayer1(name)
    local frienemy = world:getPactor(name)
    if frienemy then
        local player1Pos = { row = world:getRowOf("PLAYER1"),  col = world:getColOf("PLAYER1") }
        local myPos      = { row = world:getRowOf(name), col = world:getColOf(name) }
        
        if player1Pos.row < myPos.row and world:canPactorMoveInDirection(name, "UP") then
            directions[name] = "UP"
        elseif player1Pos.row > myPos.row and world:canPactorMoveInDirection(name, "DOWN") then
            directions[name] = "DOWN"
        end
        
        if player1Pos.col < myPos.col and world:canPactorMoveInDirection(name, "LEFT") then
            directions[name] = "LEFT"
        elseif player1Pos.col > myPos.col and world:canPactorMoveInDirection(name, "RIGHT") then
            directions[name] = "RIGHT"
        end
    end
end

local function enemyTick()
    followPlayer1("FRIENEMY")
end

local function enemyPerform()
    local frienemy = world:getPactor("FRIENEMY")
    if frienemy then
        frienemy:performAction(directions["FRIENEMY"])    
    end
end

ENEMY_TICK    = enemyTick
ENEMY_PERFORM = enemyPerform