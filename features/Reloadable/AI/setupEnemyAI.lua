local world = GAME:getModifiableWorld()

local frienemy = world:getPactor("FRIENEMY")
local counter = 0;
local direction = -9999;

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

local function manhattanDistance(A, B)
  return math.abs(A.row - B.row) + math.abs(A.col - B.col)
end

local function travelDirection(direction)
    if direction == 1  then
        frienemy:performAction("UP")
    elseif direction == 2 then
        frienemy:performAction("DOWN")
    elseif direction == 3 then
       frienemy:performAction("LEFT")
    elseif direction == 4 then
        frienemy:performAction("RIGHT")
    end
 end


--psuedo clyde otoboke : 'feigning ignorance'
local function clydeMovement()
    --local player1Pos = { row = world:getRowOf("PLAYER1"),  col = world:getColOf("PLAYER1") }
    --local myPos      = { row = world:getRowOf("FRIENEMY"), col = world:getColOf("FRIENEMY") }
    
   -- if(manhattanDistance(player1Pos, myPos) <= 8) then
   -- flag = true;
   -- print('less than 8 away');
   -- end
    
    if counter > 0 then
    travelDirection(direction)
    counter = counter-1
    
    elseif counter <= 0 then
    counter = math.random(15)  
    direction = math.random(4)
    print(direction)
    end
end
   

frienemy:learnAction("Random", VoidFunctionPointer(clydeMovement))

local function enemyTick()
    frienemy:performAction("Random")
    -- TODO
end

ENEMY_TICK = enemyTick