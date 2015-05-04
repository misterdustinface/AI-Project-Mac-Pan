local world = GAME:getModifiableWorld()

local frienemy = world:getPactor("FRIENEMY")

local function followPlayer1()
    local player1Pos = { row = world:getRowOf("PLAYER1"),  col = world:getColOf("PLAYER1") }
    local myPos      = { row = world:getRowOf("FRIENEMY"), col = world:getColOf("FRIENEMY") }
    
    if player1Pos.row < myPos.row then
        frienemy:performAction("UP")
    elseif player1Pos.row > myPos.row  then
        frienemy:performAction("DOWN")
    elseif player1Pos.col < myPos.col  then
        frienemy:performAction("LEFT")
    elseif player1Pos.col > myPos.col  then
        frienemy:performAction("RIGHT")
    end
end

--psuedo clyde otoboke : “feigning ignorance”
local function moveRandomly()
    local player1Pos = { row = world:getRowOf("PLAYER1"),  col = world:getColOf("PLAYER1") }
    local rand = math.random(4)
    print(rand)
    if rand == 1  then
        frienemy:performAction("UP")
    elseif rand == 2 then
        frienemy:performAction("DOWN")
    elseif rand == 3 then
       frienemy:performAction("LEFT")
    elseif rand == 4 then
        frienemy:performAction("RIGHT")
    end
end

frienemy:learnAction("Random", VoidFunctionPointer(moveRandomly))

local function enemyTick()
    frienemy:performAction("Random")
    -- TODO
end

ENEMY_TICK = enemyTick