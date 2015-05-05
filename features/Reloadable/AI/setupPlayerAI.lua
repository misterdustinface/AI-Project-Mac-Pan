local world = GAME:getModifiableWorld()
local player = world:getPactor("PLAYER1")
local searchAlg = require("features/Reloadable/AI/astar")

local getDirectionToMove
local getCoordinateOfPactor

local directions = {}

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

local function playerTick()
  local playerExists, playerCoordinate = pcall(getCoordinateOfPactor, "PLAYER1")
  local goalExists,   goalCoordinate   = pcall(getCoordinateOfPactor, "GOAL")
  if playerExists and goalExists then
    local direction = getDirectionToMove(playerCoordinate, goalCoordinate)
    directions["Player1"] = direction
  else
    directions["Player1"] = nil
  end
end

local function playerPerform()
    if directions["Player1"] then
      player:performAction(directions["Player1"])
    end
end

PLAYER_TICK    = playerTick
PLAYER_PERFORM = playerPerform