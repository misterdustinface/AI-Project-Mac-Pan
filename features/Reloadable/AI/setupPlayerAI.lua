local player = GAME:getPactor("PLAYER1")
local searchAlg = require("features/Reloadable/AI/astar")
local GravityMap = require("features/Reloadable/AI/GravityMap")

local getDirectionToMove

local primaryDirection   = { ["PLAYER1"] = "NONE" }
local secondaryDirection = { ["PLAYER1"] = "NONE" }

local gravityMap = GravityMap:new()

function getDirectionToMove(start, goal)
  local board = GAME:getTiledBoard()
  searchAlg:setBoard(board)
  searchAlg:setStart(start)
  searchAlg:setGoal(goal)
  return searchAlg:bestMove()
end

local function degenerate(weight, depth)
    return (5*weight-(depth/7)) / depth
end

local totaltime = 0
local ticks = 0

local function playerTickWithGravityMap()
    local starttime = os.clock()
    
    gravityMap:setWeights({ ENEMY = -10, PICKUP = 50 })
    gravityMap:setDegeneracyFunction( degenerate )
    gravityMap:generate()
    -- gravityMap:print()
    primaryDirection["PLAYER1"] = gravityMap:bestMove("PLAYER1")
    secondaryDirection["PLAYER1"] = gravityMap:bestSecondaryMove("PLAYER1")
    
    local exectime = os.clock() - starttime
    totaltime = totaltime + exectime
    ticks = ticks + 1
    if ticks % 100 == 0 then
        print(totaltime / ticks)
    end
end

local function playerTickWithSearch()
  local starttime = os.clock()
  
  local playerCoordinate = GAME:getCoordinateOfPactor("PLAYER1")
  local goalCoordinate   = GAME:getCoordinateOfPactor("GOAL")
  if playerCoordinate and goalCoordinate then
    local direction = getDirectionToMove(playerCoordinate, goalCoordinate)
    primaryDirection["PLAYER1"] = direction
  else
    primaryDirection["PLAYER1"] = "NONE"
  end
  
  local exectime = os.clock() - starttime
  totaltime = totaltime + exectime
  ticks = ticks + 1
  if ticks % 100 == 0 then
      print(totaltime / ticks)
  end
end

local oppositeDirections = {
    UP = "DOWN",
    RIGHT = "LEFT",
    DOWN = "UP",
    LEFT = "RIGHT",
}

local function playerPerform()    
    if player:getValueOf("DIRECTION") == "NONE" then
        player:performAction(primaryDirection["PLAYER1"])
    else
        player:performAction(primaryDirection["PLAYER1"])
        if oppositeDirections[primaryDirection["PLAYER1"]] ~= secondaryDirection["PLAYER1"] then
            player:performAction(secondaryDirection["PLAYER1"])
        end
    end
end

PLAYER_TICK    = playerTickWithGravityMap
PLAYER_PERFORM = playerPerform