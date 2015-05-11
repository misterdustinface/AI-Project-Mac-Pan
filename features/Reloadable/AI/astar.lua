local PriorityQueue = require("luasrc/PriorityQueue")

local astar
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

-- START ASTAR DATA STRUCTURES
local visited
local ready
local predecessors
-- END ASTAR DATA STRUCTURES

local board
local start
local destination

local function tileComparator(A, B)
  if A.f and B.f then
    return A.f < B.f
  elseif A.f then
    return A.f
  else
    return B.f
  end
end

local function manhattanDistance(A, B)
  return math.abs(A.row - B.row) + math.abs(A.col - B.col)
end

local function calculateFScoreOf(tile)
  local pred = getPredecessorOf(tile)
  if pred then
    tile.g = pred.g + 1
    tile.h = manhattanDistance(tile, destination)
    tile.f = tile.g + tile.h
  else
    tile.g = 0
    tile.f = 0
  end
end

function initDataStructures()
  visited = {}
  predecessors = {}
  ready = PriorityQueue:new()
  ready:setComparator(tileComparator)
end

function astar(start)
  visit(start)
  
  local foundGoal = false
  
  while not ready:isEmpty() and not foundGoal do
    local current = ready:pop()
    visitIfPossible(current, getTileToLeftOf(current))
    visitIfPossible(current, getTileToRightOf(current))
    visitIfPossible(current, getTileAbove(current))
    visitIfPossible(current, getTileBelow(current))
    foundGoal = (current.row == destination.row and current.col == destination.col)
  end
end

function visitIfPossible(current, neighbor)
  if isVisitable(neighbor) then
    -- Note to self: when in doubt, check the order in which functions are called
    setPredecessorOf(neighbor, current)
    visit(neighbor)
  end
end

function visit(tile)
  calculateFScoreOf(tile)
  ready:push(tile)
  markAsVisited(tile)
end

function isVisitable(tile)
  return isTraversable(tile) and not wasVisited(tile)
end

function markAsVisited(tile)
  visited[getTileID(tile)] = true
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
  return GAME:isTraversableForPactor(tile.row, tile.col, "PLAYER1")
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
  astar(start)
  local bestNextTile = getStartSuccessor(start, destination)
  return determineDirectionToMove(start, bestNextTile)
end

local public = {}

public.setBoard = setBoard
public.setStart = setStart
public.setGoal  = setGoal
public.bestMove = bestMove

return public