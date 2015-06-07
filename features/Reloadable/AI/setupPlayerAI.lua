local player = GAME:getPactor("PLAYER1")
local SearchAlg = require("features/Reloadable/AI/bfs")
local GravityMap = require("features/Reloadable/AI/GravityMap")
local GravityField = require("features/Reloadable/AI/GravityField")
local Stopwatch = require("luasrc/StopwatchTimer")

local getDirectionToMove

local primaryDirection   = { ["PLAYER1"] = "NONE" }
local secondaryDirection = { ["PLAYER1"] = "NONE" }

local gravityMap = GravityMap:new()
local gravityField = GravityField:new()

function getDirectionToMove(start, goal)
  local searchAlg = SearchAlg:new()
  local board = GAME:getTiledBoard()
  searchAlg:setBoard(board)
  searchAlg:setStart(start)
  searchAlg:setGoal(goal)
  return searchAlg:bestMove()
end

local function degenerate(weight, depth)
    return weight / (depth+1)
    --return (5*weight-(depth/7)) / (depth+1)
end


local timer = Stopwatch:new()
timer:average(10)

local high = 0
local function getPickupGravity()
    local numPactors = GAME:getPactorNames().length
    if numPactors > high then
        high = numPactors
    end
    return 50 * (high / numPactors)
end

local function playerTickWithGravityMap()
    timer:start()
    if GAME:getValueOf("PLAYER_ENERGIZED") then
        gravityMap:setWeights({ ENEMY = 0, PELLET = getPickupGravity(), ENERGIZER = -10 })
    else
        gravityMap:setWeights({ ENEMY = -10, PELLET = getPickupGravity(), ENERGIZER = 10 })
    end
    gravityMap:setDegeneracyFunction( degenerate )
    gravityMap:generate()
--    gravityMap:print()
    primaryDirection["PLAYER1"] = gravityMap:bestMove("PLAYER1")
    secondaryDirection["PLAYER1"] = gravityMap:bestSecondaryMove("PLAYER1")
    
    timer:stop()
end

local function trueDistanceFunction(A, B)
  local distance, direction = getDirectionToMove(A, B)
  return distance, direction
end

local function playerTickWithGravityField()
  timer:start()
      if GAME:getValueOf("PLAYER_ENERGIZED") then
        gravityField:setWeights({ ENEMY = 0, PELLET = getPickupGravity(), ENERGIZER = -10 })
    else
        gravityField:setWeights({ ENEMY = -10, PELLET = getPickupGravity(), ENERGIZER = 10 })
    end
    gravityField:setDegeneracyFunction( degenerate )
    gravityField:setDistanceDirectionFunction( trueDistanceFunction )
    gravityField:generate()
  
    primaryDirection["PLAYER1"] = gravityField:bestMove("PLAYER1")
  
  timer:stop()
end

local function playerTickWithSearch()
  timer:start()
  local playerCoordinate = GAME:getCoordinateOfPactor("PLAYER1")
  local goalCoordinate   = GAME:getCoordinateOfPactor("GOAL")
  if playerCoordinate and goalCoordinate then
    local direction = getDirectionToMove(playerCoordinate, goalCoordinate)
    primaryDirection["PLAYER1"] = direction
  else
    primaryDirection["PLAYER1"] = "NONE"
  end
  timer:stop()
end

local oppositeDirections = {
    UP = "DOWN",
    RIGHT = "LEFT",
    DOWN = "UP",
    LEFT = "RIGHT",
}

local function playerPerform()
    if GAME:getValueOf("SHOULD_USE_PLAYER_AI") then
        if player:getValueOf("DIRECTION") == "NONE" then
            player:performAction(primaryDirection["PLAYER1"])
        else
            player:performAction(primaryDirection["PLAYER1"])
            player:performAction(secondaryDirection["PLAYER1"])
        end
    end
end

PLAYER_TICK    = playerTickWithGravityMap
PLAYER_PERFORM = playerPerform