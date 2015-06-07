local Queue = require("luasrc/Queue")

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

function initDataStructures(this)
  this.visited = {}
  this.ready = Queue:new()
  this.predecessors = {}
end

function bfs(this, start)
  visit(this, start)
  
  local foundGoal = false
  
  while not this.ready:isEmpty() and not foundGoal do
    local current = this.ready:dequeue()
    visitIfPossible(this, current, getTileToLeftOf(this, current))
    visitIfPossible(this, current, getTileToRightOf(this, current))
    visitIfPossible(this, current, getTileAbove(this, current))
    visitIfPossible(this, current, getTileBelow(this, current))
    foundGoal = (current.row == this.destination.row and current.col == this.destination.col)
  end
end

function visitIfPossible(this, current, neighbor)
  if isVisitable(this, neighbor) then
    setPredecessorOf(this, neighbor, current)
    visit(this, neighbor)
  end
end

function visit(this, tile)
  this.ready:enqueue(tile)
  markAsVisited(this, tile)
end

function isVisitable(this, tile)
  return isTraversable(tile) and not wasVisited(this, tile)
end

function markAsVisited(this, tile)
  this.visited[getTileID(tile)] = tile
end

function wasVisited(this, tile)
  return this.visited[getTileID(tile)]
end

function getStartSuccessor(this, start, destination)
  local tile = destination
  local distance = 0
  while getPredecessorOf(this, tile) ~= start do
    --print("CURRENT SUCCESSOR: ", tile.row, tile.col)
    tile = getPredecessorOf(this, tile)
  distance = distance + 1
  end
  return tile, distance
end

function setPredecessorOf(this, tile, predecessorTile)
  this.predecessors[getTileID(tile)] = predecessorTile
end

function getPredecessorOf(this, tile)
  return this.predecessors[getTileID(tile)]
end

function getTileToRightOf(this, currentTile)
  return wrapBoundary(this, {row = currentTile.row, col = currentTile.col + 1})
end

function getTileToLeftOf(this, currentTile)
  return wrapBoundary(this, {row = currentTile.row, col = currentTile.col - 1})
end

function getTileAbove(this, currentTile)
  return wrapBoundary(this, {row = currentTile.row - 1, col = currentTile.col})
end

function getTileBelow(this, currentTile)
  return wrapBoundary(this, {row = currentTile.row + 1, col = currentTile.col})
end

function wrapBoundary(this, tile)
  if tile.row < 1 then
    tile.row = this.board.length
  elseif tile.row > this.board.length then
    tile.row = 1
  end
  
  if tile.col < 1 then
    tile.col = this.board[1].length
  elseif tile.col > this.board[1].length then
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
  this.board = xBoard
end

function setStart(this, xStart)
  this.start = xStart
end

function setGoal(this, xGoal)
  this.destination = xGoal
end

function bestMove(this)
  initDataStructures(this)
  bfs(this, this.start)
  local bestNextTile, distance = getStartSuccessor(this, this.start, this.destination)
  return determineDirectionToMove(this.start, bestNextTile), distance
end

local function new()
  return {
    setBoard = setBoard,
    setStart = setStart,
    setGoal = setGoal,
    bestMove = bestMove,
    
    visited = nil,
    ready = nil,
    predecessors = nil,
    board = nil,
    start = nil,
    destination = nil,
  }
end

return {
  new = new
}