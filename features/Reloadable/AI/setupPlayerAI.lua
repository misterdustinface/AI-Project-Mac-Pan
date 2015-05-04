local world = GAME:getModifiableWorld()
local player = world:getPactor("PLAYER1")
local searchAlg = require("features/Reloadable/AI/astar")

local getDirectionToMove
local getCoordinateOfPactor

function getCoordinateOfPactor(name)
  local row = world:getRowOf(name) + 1
  local col = world:getColOf(name) + 1
  return { row = row, col = col}
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
    player:performAction(direction)
  end
end

PLAYER_TICK = playerTick

--print(getDirectionToMove({row = 2, col = 2}, {row = 5, col = 2}))
--print("!!! DONE !!!")