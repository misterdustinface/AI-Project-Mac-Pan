local world = GAME:getModifiableWorld()
local player = world:getPactor("PLAYER1")
local searchAlg = require("features/Reloadable/AI/astar")
local GravityMap = require("features/Reloadable/AI/GravityMap")

local getDirectionToMove
local getCoordinateOfPactor

local primaryDirection   = { ["PLAYER1"] = "NONE" }
local secondaryDirection = { ["PLAYER1"] = "NONE" }

local gravityMap = GravityMap:new()

function getCoordinateOfPactor(name)
  local row = world:getRowOf(name) + 1
  local col = world:getColOf(name) + 1
  return { row = row, col = col }
end

function getDirectionToMove(start, goal)
  local board = world:getTiledBoard()
  searchAlg:setBoard(board)
  searchAlg:setStart(start)
  searchAlg:setGoal(goal)
  return searchAlg:bestMove()
end

local function degenerate(weight, depth)
    if weight > 0 then
        return weight/depth
    else
        return weight + depth
    end
end

local function playerTickWithGravityMap()
    gravityMap:setWeights({ ENEMY = -4000, PICKUP = 2000})
    gravityMap:setDegeneracyFunction( degenerate )
    gravityMap:generate()
    gravityMap:print()
    primaryDirection["PLAYER1"] = gravityMap:bestMove("PLAYER1")
    secondaryDirection["PLAYER1"] = gravityMap:bestSecondaryMove("PLAYER1")
end

--local function playerTickWithSearch()
--  local playerExists, playerCoordinate = pcall(getCoordinateOfPactor, "PLAYER1")
--  local goalExists,   goalCoordinate   = pcall(getCoordinateOfPactor, "GOAL")
--  if playerExists and goalExists then
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