local world = GAME:getWorld()
math.randomseed(os.time())

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

local getNodeOfDegreeTable = {
    [0] = {},
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
}

local function getDegreeOfNode(row, col)
    return getTileDegree(row, col)
end

local function insertNode(row, col)
    local degree = getTileDegree(row, col)
    table.insert(getNodeOfDegreeTable[degree], { ["row"] = row, ["col"] = col })
end

local function hasNodeOfDegree(degree)
    return #getNodeOfDegreeTable[degree] > 0
end

local function popNodeOfDegree(degree)
    local node = table.remove(getNodeOfDegreeTable[degree], math.random(1, #getNodeOfDegreeTable[degree]))
    while getDegreeOfNode(node.row, node.col) ~= degree and hasNodeOfDegree(degree) do
        insertNode(node.row, node.col)
        node = table.remove(getNodeOfDegreeTable[degree], math.random(1, #getNodeOfDegreeTable[degree]))
    end
    
    if getDegreeOfNode(node.row, node.col) == degree then return node end
end

local function popNodeOfHighestDegree() 
    local node
    for i = 4, 2, -1 do
        if hasNodeOfDegree(i) then
            node = popNodeOfDegree(i)
        end
        if node then return node end
    end
end

local function popNodeOfLowestDegree()
    local node
    for i = 1, 2, 1 do
        if hasNodeOfDegree(i) then
            node = popNodeOfDegree(i)
        end
        if node then return node end
    end
end

local function setup()
    for row = 1, world:getRows() do
        for col = 1, world:getCols() do
            insertNode(row, col)
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
    
    if degree >= 2 then
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
    
    if degree <= 3 then
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
    
--    local filler   = randomFillNodeFrom(highDegreeNode)
--    local tunneler = randomTunnelNodeFrom(lowDegreeNode)
    
    local possibleFillerDirectionSet = getPossibleFillDirectionSet(highDegreeNode)
    local possibleTunnelerDirectionSet = getPossibleTunnelDirectionSet(lowDegreeNode)
    
    if #possibleFillerDirectionSet > 0 and #possibleTunnelerDirectionSet > 0 then
    
        local randomFillerDirection = possibleFillerDirectionSet[math.random(#possibleFillerDirectionSet)]
        local randomTunnelDirection = possibleTunnelerDirectionSet[math.random(#possibleTunnelerDirectionSet)]
    
        local filler = getPerturbedDirection(highDegreeNode, randomFillerDirection)      
        local tunneler = getPerturbedDirection(lowDegreeNode, randomTunnelDirection)  
        
        local nextFiller = getPerturbedDirection(filler, randomFillerDirection)
        
        while getTileName(filler.row, filler.col) == "FLOOR" and getTileName(nextFiller.row, nextFiller.col) == "FLOOR" do
        
            if getTileName(tunneler.row, tunneler.col) ~= "WALL" then
                repeat
                    insertNode(lowDegreeNode.row,  lowDegreeNode.col)
                    lowDegreeNode = popNodeOfLowestDegree()
                    possibleTunnelerDirectionSet = getPossibleTunnelDirectionSet(lowDegreeNode)
                until #possibleTunnelerDirectionSet > 0
                randomTunnelDirection = possibleTunnelerDirectionSet[math.random(#possibleTunnelerDirectionSet)]
                tunneler = getPerturbedDirection(lowDegreeNode, randomTunnelDirection)
            end
        
            swap(filler, tunneler)
            filler = getPerturbedDirection(filler, randomFillerDirection)
            nextFiller = getPerturbedDirection(filler, randomFillerDirection)
            tunneler = getPerturbedDirection(tunneler, randomTunnelDirection)
    --        filler   = randomFillNodeFrom(filler)
    --        tunneler = randomTunnelNodeFrom(tunneler)
        end
        
    end
    
    insertNode(highDegreeNode.row, highDegreeNode.col)
    insertNode(lowDegreeNode.row,  lowDegreeNode.col)

end

local function wallShuffleTick()
    if GAME:getValueOf("SHOULD_SHUFFLE_WALLS") then
        shuffleWalls()
    end
end

setup()
WALL_SHUFFLE_TICK = wallShuffleTick