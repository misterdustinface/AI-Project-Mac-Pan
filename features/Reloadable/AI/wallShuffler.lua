local Queue = require("luasrc/Queue")
local world = GAME:getWorld()
math.randomseed(os.time())

local getNodeOfDegreeTable = {
    [0] = Queue:new(),
    [1] = Queue:new(),
    [2] = Queue:new(),
    [3] = Queue:new(),
    [4] = Queue:new(),
}

local getDegreeOfNodeTable = {}

local function getDegreeOfNode(row, col)
    return getDegreeOfNodeTable[row .. ", " .. col]
end

local function setDegreeOfNode(row, col, degree)
    getDegreeOfNodeTable[row .. ", " .. col] = degree
end

local function insertNode(degree, row, col)
    getNodeOfDegreeTable[degree]:enqueue({ ["row"] = row, ["col"] = col })
    setDegreeOfNode(row, col, degree)
end

local function popNodeOfDegree(degree)
    local node = getNodeOfDegreeTable[degree]:dequeue()
    return node
end

local function hasNodeOfDegree(degree)
    return not getNodeOfDegreeTable[degree]:isEmpty()
end

local function popNodeOfHighestDegree() 
    for i = 4, 1, -1 do
        if hasNodeOfDegree(i) then
            return popNodeOfDegree(i)
        end
    end
end

local function wrapCol(board, col)  
  if col < 1 then
    col = board[1].length
  elseif col > board[1].length then
    col = 1
  end
  return col
end

local function wrapRow(board, row)
  if row < 1 then
    row = board.length
  elseif row > board.length then
    row = 1
  end
  return row
end

local function getTileName(row, col)
    local board = GAME:getTiledBoard()
    row = wrapRow(board, row)
    col = wrapCol(board, col)
    local tileNames = GAME:getTileNames()
    local tileEnum = board[row][col]
    local tileName = tileNames[tileEnum+1]
    return tileName
end


--local function generateCoordinate()
--    local ROWS = world:getRows()
--    local COLS = world:getCols()
--    local row = math.random(ROWS) - 1
--    local col = math.random(COLS) - 1
--    return row, col
--end

local function getTileDegree(row, col)
    local degree = 0
    
    local name = getTileName(row, col)
    if name ~= "FLOOR" then return degree end

    local A = getTileName(row, col + 1)
    local B = getTileName(row, col - 1)
    local C = getTileName(row + 1, col)
    local D = getTileName(row - 1, col)
    
    if A == "FLOOR" then degree = degree + 1 end
    if B == "FLOOR" then degree = degree + 1 end
    if C == "FLOOR" then degree = degree + 1 end
    if D == "FLOOR" then degree = degree + 1 end
   
    return degree
end

local function setup()
    for row = 1, world:getRows() do
        for col = 1, world:getCols() do
            local degree = getTileDegree(row, col)
            insertNode(degree, row, col)
        end
    end
end

local function randomFillFrom(node)
    local possibleDirectionSet = {}
    local degree = getTileDegree(node.row, node.col)
    
    if getTileName(node.row - 1, node.col) == "FLOOR" then
        table.insert(possibleDirectionSet, "UP")
    end
    if getTileName(node.row + 1, node.col) == "FLOOR" then
        table.insert(possibleDirectionSet, "DOWN")
    end
    if getTileName(node.row, node.col - 1) == "FLOOR" then
        table.insert(possibleDirectionSet, "LEFT")
    end
    if getTileName(node.row, node.col + 1) == "FLOOR" then
        table.insert(possibleDirectionSet, "RIGHT")
    end
    
    local randomDirection = possibleDirectionSet[math.random(#possibleDirectionSet)]
    
end

local function shuffleWalls()
    local highDegreeNode = popNodeOfHighestDegree()
    local degree = getTileDegree(highDegreeNode.row, highDegreeNode.col)
    insertNode(degree, highDegreeNode.row, highDegreeNode.col)

    world:swap(2, math.random(world:getCols()) - 1, 4, math.random(world:getCols()) - 1)
end

setup()
WALL_SHUFFLE_TICK = shuffleWalls