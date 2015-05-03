local Queue = require("luasrc/Queue")
local world = GAME:getModifiableWorld()

local bfs
local wrapBoundary
local getTileToRightOf
local getTileToLeftOf
local getTileAbove
local getTileBelow
local getCoordinateID
local visitIfPossible
local visit
local getTileID
local isVisitable
local getDirectionToMove
local determineDirectionToMove
local initDataStructures
local getStartSuccessor
local markAsVisited
local wasVisited
local getPredecessorOf
local setPredecessorOf
local isTraversable
local setBoard
local setStart
local setGoal
local bestMove

-- START BFS DATA STRUCTURES
local visited
local ready
local predecessors
-- END BFS DATA STRUCTURES

local board
local start
local destination

function initDataStructures()
  visited = {}
  ready = Queue:new()
  predecessors = {}
end

function bfs(start)
  visit(start)
  
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
    visit(neighbor)
    setPredecessorOf(neighbor, current)
  end
end

function visit(tile)
  ready:enqueue(tile)
  markAsVisited(tile)
end

function isVisitable(tile)
  return isTraversable(tile) and not wasVisited(tile)
end

function markAsVisited(tile)
  visited[getTileID(tile)] = tile
end

function wasVisited(tile)
  return visited[getTileID(tile)]
end

function getStartSuccessor(start, destination)
  local tile = destination
  while getPredecessorOf(tile) ~= start do
    --print("CURRENT SUCCESSOR: ", tile.row, tile.col)
    tile = getPredecessorOf(tile)
  end
  return tile
end

function setPredecessorOf(tile, predecessorTile)
  predecessors[getTileID(tile)] = predecessorTile
end

function getPredecessorOf(tile)
  return predecessors[getTileID(tile)]
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

function getTileID(tile)
  if tile then
    return tile.row .. "," .. tile.col
  end
end

function isTraversable(tile)
  -- expecting 0 based indexing
  return world:isTraversableForPactor(tile.row - 1, tile.col - 1, "PLAYER1")
end

function setBoard(this, xBoard)
  board = xBoard
end

function setStart(this, xStart)
  start = xStart
end

function setGoal(this, xGoal)
  destination = xGoal
end

function bestMove(this)
  initDataStructures()
  bfs(start)
  local bestNextTile = getStartSuccessor(start, destination)
  return determineDirectionToMove(start, bestNextTile)
end

local public = {}

public.setBoard = setBoard
public.setStart = setStart
public.setGoal  = setGoal
public.bestMove = bestMove

return public