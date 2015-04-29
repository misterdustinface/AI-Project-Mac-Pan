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
local clearDataStructures
local getStartSuccessor
local markAsVisited
local setLeftPredecessorAsRight

  -- ALGORITHMS
local bfs
local aStar

-- END FUNCTION DECLARATIONS BITCHES

--local openTiles = luajava.newInstance("java.util.PriorityQueue")
--local closedTiles = luajava.newInstance("java.util.Stack")

-- START BFS DATA STRUCTURES
local visited
local ready
local predecessors
-- END BFS DATA STRUCTURES

local board

function getDirectionToMove(start, destination)
  board = world:getTiledBoard()
  clearDataStructures()
  bfs(start)
  return determineDirectionToMove(start, getStartSuccessor(start, destination))
end

local function playerTick()
end

function aStar(start, destination)
  board = world:getTiledBoard()
end

function setLeftPredecessorAsRight(left, right)
  predecessors[getTileID(left)] = getTileID(right)
end

function getStartSuccessor(start, destination)
  local startSuccessor = predecessors[getTileID(destination)]
  while predecessors[getTileID(startSuccessor)] ~= getTileID(start) do
    print("CURRENT SUCCESSOR: " .. startSuccessor)
    startSuccessor = predecessors[getTileID(startSuccessor)]
  end
  return startSuccessor
end

function determineDirectionToMove(current, nextTile)
  if current.row < nextTile.row then
    return "DOWN"
  end
  
  if current.row > nextTile.row then
    return "UP"
  end
  
  if current.col < nextTile.col then
    return "RIGHT"
  end
  
  if current.col > nextTile.col then
    return "LEFT"
  end
end

function markAsVisited(tile)
  visited[getTileID(tile)] = tile
end

function bfs(start)
  ready:enqueue(start)
  markAsVisited(start)
  predecessors[start] = {row = -1, col = -1}
  
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
    print("VISITING: " .. current.row .. ", " .. current.col)
    ready:enqueue(neighbor)
    markAsVisited(neighbor)
    setLeftPredecessorAsRight(neighbor, current)
  end
end

function getTileID(tile)
  return tile.row .. "," .. tile.col
end

function clearDataStructures()
  visited = {}
  ready = Queue:new()
  predecessors = {}
end

function isVisitable(tile)
  -- isWall is expecting 0 base indexing
  return not world:isWall(tile.row - 1, tile.col - 1) and not visited[getTileID(tile)]
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

print(getDirectionToMove({row = 2, col = 2}, {row = 5, col = 2}))

PLAYER_TICK = playerTick