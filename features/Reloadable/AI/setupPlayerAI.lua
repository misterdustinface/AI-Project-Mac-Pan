local Queue = require("luasrc/Queue")
local world = GAME:getModifiableWorld()
local player = world:getPactor("PLAYER1")

-- START FUNCTION DECLARATIONS BITCHES
local wrapBoundary
local getTileToRightOf
local getTileToLeftOf
local getTileAbove
local getTileBelow
local getCoordinateID
local visitIfPossible
local getTileID
local isVisitable
-- END FUNCTION DECLARATIONS BITCHES


-- START BFS DATA STRUCTURES

--local openTiles = luajava.newInstance("java.util.PriorityQueue")
--local closedTiles = luajava.newInstance("java.util.Stack")

local visited = {}
local ready = Queue:new()
local predecessors = {}



-- END BFS DATA STRUCTURES

local board

local function aStar(start, destination)
  board = world:getTiledBoard()
end

local function bfs(start, destination)

  ready:enqueue(getTileID(start))
  visited[getTileID(start)] = true
  predecessors[getTileID(start)] = "NONE"
  
  while not ready:isEmpty() do
    local current = ready:dequeue()
    visitIfPossible(getTileToLeftOf(current))
    visitIfPossible(getTileToRightOf(current))
    visitIfPossible(getTileAbove(current))
    visitIfPossible(getTileBelow(current))
  end
end

function visitIfPossible(current, neighbor)
  if isVisitable(neighbor) then
    ready:enqueue(getTileID(neighbor))
    visited[neighbor] = true
    predecessors[getTileID(neighbor)] = getTileID(current)
  end
end

function getTileID(tile)
  return tile.row .. "," .. tile.col
end


function isVisitable(tile)
  return not world:isWall(tile.row, tile.col) and not visited[getTileID(tile)]
end

local function playerTick()

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
    tile.col = board[0].length
  elseif tile.col > board[0].length then
    tile.col = 1
  end
  
  return tile
end

PLAYER_TICK = playerTick