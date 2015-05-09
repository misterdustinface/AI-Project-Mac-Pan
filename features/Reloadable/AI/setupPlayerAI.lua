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
    return weight/depth
end

local function playerTickWithGravityMap()
    gravityMap:setWeights({ ENEMY = -1, PICKUP = 1})
    gravityMap:setDegeneracyFunction( degenerate )
    gravityMap:generate()
--    gravityMap:print()
    primaryDirection["PLAYER1"] = gravityMap:bestMove("PLAYER1")
    secondaryDirection["PLAYER1"] = gravityMap:bestSecondaryMove("PLAYER1")
end

--local function playerTickWithSearch()
--  local playerCoordinate = GAME:getCoordinateOfPactor("PLAYER1")
--  local goalCoordinate   = GAME:getCoordinateOfPactor("GOAL")
--  if playerCoordinate and goalCoordinate then
--    local direction = getDirectionToMove(playerCoordinate, goalCoordinate)
--    primaryDirection["Player1"] = direction
--  else
--    primaryDirection["Player1"] = "NONE"
--  end
--end

local function playerPerform()    
    if player:getValueOf("DIRECTION") == "NONE" then
        player:performAction(primaryDirection["PLAYER1"])
    else
        player:performAction(primaryDirection["PLAYER1"])
        player:performAction(secondaryDirection["PLAYER1"])
    end
end

PLAYER_TICK    = playerTickWithGravityMap
PLAYER_PERFORM = playerPerform