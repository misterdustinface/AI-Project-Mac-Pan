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

local function popNodeOfLowestDegree()
    for i = 1, 4, 1 do
        if hasNodeOfDegree(i) then
            return popNodeOfDegree(i)
        end
    end
end

local function wrapCol(col)  
  if col < 1 then
    col = world:getCols()
  elseif col > world:getCols() then
    col = 1
  end
  return col
end

local function wrapRow(row)
  if row < 1 then
    row = world:getRows()
  elseif row > world:getRows() then
    row = 1
  end
  return row
end

local function getTileName(row, col)
    local board = GAME:getTiledBoard()
    row = wrapRow(row)
    col = wrapCol(col)
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

local function getPossibleFillDirectionSet(node)
    local possibleFillDirectionSet = {}

    if getTileName(node.row - 1, node.col) == "FLOOR" then
        table.insert(possibleFillDirectionSet, "UP")
    end
    if getTileName(node.row + 1, node.col) == "FLOOR" then
        table.insert(possibleFillDirectionSet, "DOWN")
    end
    if getTileName(node.row, node.col - 1) == "FLOOR" then
        table.insert(possibleFillDirectionSet, "LEFT")
    end
    if getTileName(node.row, node.col + 1) == "FLOOR" then
        table.insert(possibleFillDirectionSet, "RIGHT")
    end
    
    return possibleFillDirectionSet
end

local function getPossibleTunnelDirectionSet(node)
    local possibleTunnelDirectionSet = {}

    if getTileName(node.row - 1, node.col) == "WALL" then
        table.insert(possibleTunnelDirectionSet, "UP")
    end
    if getTileName(node.row + 1, node.col) == "WALL" then
        table.insert(possibleTunnelDirectionSet, "DOWN")
    end
    if getTileName(node.row, node.col - 1) == "WALL" then
        table.insert(possibleTunnelDirectionSet, "LEFT")
    end
    if getTileName(node.row, node.col + 1) == "WALL" then
        table.insert(possibleTunnelDirectionSet, "RIGHT")
    end
    
    return possibleTunnelDirectionSet
end

local function getPerturbedDirection(node, direction)
    local board = GAME:getTiledBoard()
    local pd = { row = node.row, col = node.col }

    if direction == "UP" then
        pd.row = wrapRow(pd.row - 1)
    end
    if direction == "DOWN" then
        pd.row = wrapRow(pd.row + 1)
    end
    if direction == "LEFT" then
        pd.col = wrapCol(pd.col - 1)
    end
    if direction == "RIGHT" then
        pd.col = wrapCol(pd.col + 1)
    end
    
    return pd
end

local function randomFillNodeFrom(node)
    local degree = getTileDegree(node.row, node.col)
    
    if degree > 1 then
        local possibleDirectionSet = getPossibleFillDirectionSet(node)
        if #possibleDirectionSet > 0 then
            local randomDirection = possibleDirectionSet[math.random(#possibleDirectionSet)]
            local nextNode = getPerturbedDirection(node, randomDirection)        
            return nextNode
        end
    end
end

local function randomTunnelNodeFrom(node)
    local degree = getTileDegree(node.row, node.col)
    
    if degree < 4 then
        local possibleDirectionSet = getPossibleTunnelDirectionSet(node)
        if #possibleDirectionSet > 0 then
            local randomDirection = possibleDirectionSet[math.random(#possibleDirectionSet)]
            local nextNode = getPerturbedDirection(node, randomDirection)        
            return nextNode
        end
    end
end

local function swap(A, B)
    if A and B then
        world:swap(A.row - 1, A.col - 1, B.row - 1, B.col - 1)
    end
end

local function shuffleWalls()
    local highDegreeNode = popNodeOfHighestDegree()
    local lowDegreeNode  = popNodeOfLowestDegree()
    local filler   = randomFillNodeFrom(highDegreeNode)
    local tunneler = randomTunnelNodeFrom(lowDegreeNode)
    
    for i = 1, math.random(8) do
        if filler and tunneler then
            setDegreeOfNode(filler.row, filler.col, getTileDegree(tunneler.row, tunneler.col))
            setDegreeOfNode(tunneler.row, tunneler.col, getTileDegree(filler.row, filler.col))
            swap(filler, tunneler)
            filler   = randomFillNodeFrom(filler)
            tunneler = randomTunnelNodeFrom(tunneler)
        end
    end
    
    insertNode(getTileDegree(highDegreeNode.row, highDegreeNode.col), highDegreeNode.row, highDegreeNode.col)
    insertNode(getTileDegree(lowDegreeNode.row, lowDegreeNode.col), lowDegreeNode.row, lowDegreeNode.col)

end

setup()
WALL_SHUFFLE_TICK = shuffleWalls