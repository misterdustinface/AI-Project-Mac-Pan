local Queue = require("luasrc/Queue")
local world = GAME:getModifiableWorld()
local player = world:getPactor("PLAYER1")

-- START FUNCTION DECLARATIONS BITCHES

--SANTA'S LITTLE HELPER FUNCTIONS

local wrapBoundary
local getTileToRightOf
local getTileToLeftOf
local getTileAbove
local getTileBelow
local getCoordinateID
local visitIfPossible
local getTileID
local isVisitable
local getDirectionToMove
local determineDirectionToMove
local initDataStructures
local getStartSuccessor
local markAsVisited
local wasVisited
local getPredecessorOf
local setLeftPredecessorAsRight
local getCoordinateOfPactor

  -- ALGORITHMS
local bfs

-- END FUNCTION DECLARATIONS BITCHES

-- START BFS DATA STRUCTURES
local visited
local ready
local predecessors
-- END BFS DATA STRUCTURES

local board

function getDirectionToMove(start, destination)
  board = world:getTiledBoard()
  initDataStructures()
  bfs(start)
  local bestNextTile = getStartSuccessor(start, destination)
  return determineDirectionToMove(start, bestNextTile)
end

function setLeftPredecessorAsRight(left, right)
  predecessors[getTileID(left)] = right
end

function getStartSuccessor(start, destination)
  local tile = destination
  while getPredecessorOf(tile) ~= start do
    --print("CURRENT SUCCESSOR: ", tile.row, tile.col)
    tile = getPredecessorOf(tile)
  end
  return tile
end

function getPredecessorOf(tile)
  return predecessors[getTileID(tile)]
end

function determineDirectionToMove(current, nextTile)
  if current.row < nextTile.row then
    return "DOWN"
  elseif current.row > nextTile.row then
    return "UP"
  elseif current.col < nextTile.col then
    return "RIGHT"
  elseif current.col > nextTile.col then
    return "LEFT"
  else
    return "UP"
  end
end

function markAsVisited(tile)
  visited[getTileID(tile)] = tile
end

function wasVisited(tile)
  return visited[getTileID(tile)]
end

function bfs(start)
  ready:enqueue(start)
  markAsVisited(start)
  predecessors[getTileID(start)] = nil
  
  while not ready:isEmpty() do
    local current = ready:dequeue()
    visitIfPossible(current, getTileToLeftOf(current))
    visitIfPossible(current, getTileToRightOf(current))
    visitIfPossible(current, getTileAbove(current))
    visitIfPossible(current, getTileBelow(current))
  end
end

function visitIfPossible(current, neighbor)
  if isVisitable(neighbor) then
    --print("VISITING: " .. current.row .. ", " .. current.col)
    ready:enqueue(neighbor)
    markAsVisited(neighbor)
    setLeftPredecessorAsRight(neighbor, current)
  end
end

function getTileID(tile)
  if tile then
    return tile.row .. "," .. tile.col
  end
end

function initDataStructures()
  visited = {}
  ready = Queue:new()
  predecessors = {}
end

function isVisitable(tile)
  -- isWall is expecting 0 based indexing
  return not world:isWall(tile.row - 1, tile.col - 1) and not wasVisited(tile)
end

function getTileToRightOf(currentTile)
  return wrapBoundary({row = currentTile.row, col = currentTile.col + 1})
end

function getTileToLeftOf(currentTile)
  return wrapBoundary({row = currentTile.row, col = currentTile.col - 1})
end

function getTileAbove(currentTile)
  return wrapBoundary({row = currentTile.row - 1, col = currentTile.col})
end

function getTileBelow(currentTile)
  return wrapBoundary({row = currentTile.row + 1, col = currentTile.col})
end

function wrapBoundary(tile)
  if tile.row < 1 then
    tile.row = board.length
  elseif tile.row > board.length then
    tile.row = 1
  end
  
  if tile.col < 1 then
    tile.col = board[1].length
  elseif tile.col > board[1].length then
    tile.col = 1
  end
  
  return tile
end

function getCoordinateOfPactor(name)
  local row = world:getRowOf(name) + 1
  local col = world:getColOf(name) + 1
  return { row = row, col = col}
end

local function playerTick()
  local playerCoordinate = getCoordinateOfPactor("PLAYER1")
  local goalExists, goalCoordinate = pcall(getCoordinateOfPactor, "GOAL")
  if goalExists then
    local direction = getDirectionToMove(playerCoordinate, goalCoordinate)
    player:performAction(direction)
  end
end

PLAYER_TICK = playerTick

--print(getDirectionToMove({row = 2, col = 2}, {row = 5, col = 2}))
--print("!!! DONE !!!")