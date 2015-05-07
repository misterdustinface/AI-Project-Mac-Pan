local world = GAME:getModifiableWorld()
local player = world:getPactor("PLAYER1")
local searchAlg = require("features/Reloadable/AI/astar")
local GravityMap = require("features/Reloadable/AI/GravityMap")

local getDirectionToMove
local getCoordinateOfPactor

local directions = {}

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

local function degenerate(weight)
    if weight > 0 then
        return weight - 1
    else
        return weight + 1
    end
end

local function playerTick()

    gravityMap:setWeights({ ENEMY = -100, PICKUP = 80})
    gravityMap:setDegeneracyFunction( degenerate )
    gravityMap:generate()
    --gravityMap:print()
    directions["PLAYER1"] = gravityMap:bestMove("PLAYER1")
  
--  local playerExists, playerCoordinate = pcall(getCoordinateOfPactor, "PLAYER1")
--  local goalExists,   goalCoordinate   = pcall(getCoordinateOfPactor, "GOAL")
--  if playerExists and goalExists then
--    local direction = getDirectionToMove(playerCoordinate, goalCoordinate)
--    directions["Player1"] = direction
--  else
--    directions["Player1"] = nil
--  end
end

local function playerPerform()
    if directions["PLAYER1"] then
      player:performAction(directions["PLAYER1"])
    end
end

PLAYER_TICK    = playerTick
PLAYER_PERFORM = playerPerform