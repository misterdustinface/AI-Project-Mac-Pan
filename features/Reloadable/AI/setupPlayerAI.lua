local world = GAME:getModifiableWorld()
local player = world:getPactor("PLAYER1")

-- START FUNCTION DECLARATIONS BITCHES
local wrapBoundary
local getTileToRightOf
local getTileToLeftOf
local getTileAbove
local getTileBelow
-- END FUNCTION DECLARATIONS BITCHES


-- START A* DATA STRUCTURES
local openTiles = luajava.newInstance("java.util.PriorityQueue")
local closedTiles = luajava.newInstance("java.util.Stack")
-- END   A* DATA STRUCTURES

local board

local function aStar(start, destination)
  board = world:getTiledBoard()
  
  
end

local function playerTick()

end

local function visit(currentTile)
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

function wrapBoundary(coordinate)
  if coordinate.row < 1 then
    coordinate.row = board.length
  elseif coordinate.row > board.length then
    coordinate.row = 1
  end
  
  if coordinate.col < 1 then
    coordinate.col = board[0].length
  elseif coordinate.col > board[0].length then
    coordinate.col = 1
  end
  
  return coordinate
end

PLAYER_TICK = playerTick