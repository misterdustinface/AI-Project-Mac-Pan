local public = {}
local Queue = require("luasrc/Queue")

local setWeights
local setDegeneracyFunction
local generate
local getGeneratedMap
local printMap

local resetMap
local applyGravityFieldToMap
local applyGravityIfEligible
local applyGravity
local canBodyAffectTile
local getGravityFieldLimitFunction
local clearActors
local enqueueActor
local dequeueActor
local hasActors
local clearVisited
local setVisited
local wasVisited
local setCurrentBody
local getCurrentBody
local degenerateGravityWeight
local addWeightToMap

local function getCoordinateOfPactor(name)
    local world = GAME:getModifiableWorld()
    local row = world:getRowOf(name) + 1
    local col = world:getColOf(name) + 1
    return { row = row, col = col }
end

local function wrapCol(gravMap, col)  
  if col < 1 then
    col = gravMap.worldBoard[1].length
  elseif col > gravMap.worldBoard[1].length then
    col = 1
  end
  return col
end

local function wrapRow(gravMap, row)
  if row < 1 then
    row = gravMap.worldBoard.length
  elseif row > gravMap.worldBoard.length then
    row = 1
  end
  return row
end

function generate(gravMap)
    resetMap(gravMap)
    local world = GAME:getModifiableWorld()
    local pactorNames = world:getPactorNames()    
    
    for i = 1, pactorNames.length do
        local body = pactorNames[i]
        local pactorExists, pactor = pcall(world.getPactor, world, body)
        if pactorExists then
            local typeExists, bodyType = pcall(pactor.getValueOf, pactor, "TYPE")
            if typeExists then
              local bodyWeight = gravMap.weights[bodyType]
              if bodyWeight then
                  setCurrentBody(gravMap, body)
                  local coor = getCoordinateOfPactor(body)
                  coor.weight = bodyWeight
                  applyGravityFieldToMap(gravMap, coor)
              end
            end
        end
    end
    
    return getGeneratedMap(gravMap)
end

function getGravityFieldLimitFunction(startWeight)
    local startedWithPositiveWeight = startWeight > 0
    if startedWithPositiveWeight then
        return (function(newWeight) return newWeight <= 0 end)
    else
        return (function(newWeight) return newWeight >= 0 end)
    end
end

function applyGravityFieldToMap(gravMap, coor)
    local hasHitFieldLimit = getGravityFieldLimitFunction(coor.weight)
    clearActors(gravMap)
    clearVisited(gravMap)
    coor.depth = 0
    applyGravity(gravMap, coor)
    while hasActors(gravMap) do
        local current = dequeueActor(gravMap)
        applyGravityIfEligible(gravMap, current, hasHitFieldLimit)
    end
end

function resetMap(gravMap)
    local world = GAME:getModifiableWorld()
    local board = world:getTiledBoard()
    local rows = board.length
    local cols = board[1].length

    gravMap.worldBoard = board
    gravMap.map = {}
    
    for row = 1, rows do
        gravMap.map[row] = {}
        for col = 1, cols do
            gravMap.map[row][col] = 0
        end
    end
end

function applyGravityIfEligible(gravMap, coor, hasHitFieldLimit)
    if not wasVisited(gravMap, coor) and not hasHitFieldLimit(coor.weight) then
        applyGravity(gravMap, coor)
    end
end

function applyGravity(gravMap, coor)
    setVisited(gravMap, coor)
    if canBodyAffectTile(getCurrentBody(gravMap), coor) then
        addWeightToMap(gravMap, coor)
        local depth = coor.depth + 1
        local weight = degenerateGravityWeight(gravMap, coor.weight, depth)
        local row = coor.row
        local col = coor.col
        enqueueActor(gravMap, { row = wrapRow(gravMap, row + 1), col = col, weight = weight, depth = depth })
        enqueueActor(gravMap, { row = wrapRow(gravMap, row - 1), col = col, weight = weight, depth = depth })
        enqueueActor(gravMap, { row = row, col = wrapCol(gravMap, col + 1), weight = weight, depth = depth })
        enqueueActor(gravMap, { row = row, col = wrapCol(gravMap, col - 1), weight = weight, depth = depth })
    end
end

function canBodyAffectTile(body, coor)
    local world = GAME:getModifiableWorld()
    local ok, traversable = pcall(world.isTraversableForPactor, world, coor.row - 1, coor.col - 1, body)
    return ok and traversable
end

function setWeights(gravMap, weights)
    gravMap.weights = weights
end
function setDegeneracyFunction(gravMap, degeneracyFunction)
    gravMap.degeneracyFunction = degeneracyFunction
end
function getGeneratedMap(gravMap)
    return gravMap.map
end
function clearActors(gravMap)
    gravMap._actors:clear()
end
function enqueueActor(gravMap, actor)
    gravMap._actors:enqueue(actor)
end
function dequeueActor(gravMap)
    return gravMap._actors:dequeue()
end
function hasActors(gravMap)
    return not gravMap._actors:isEmpty()    
end
function clearVisited(gravMap)
    gravMap.visited = {}
end
function setVisited(gravMap, coor)
    gravMap.visited[coor.row .. "," .. coor.col] = true
end
function wasVisited(gravMap, coor)
    return gravMap.visited[coor.row .. "," .. coor.col]
end
function setCurrentBody(gravMap, body)
    gravMap.currentPactor = body
end
function getCurrentBody(gravMap)
    return gravMap.currentPactor
end
function degenerateGravityWeight(gravMap, weight, depth)
    return gravMap.degeneracyFunction(weight, depth)
end
function addWeightToMap(gravMap, coor)
    local row = coor.row
    local col = coor.col
    local weight = coor.weight
    gravMap.map[row][col] = gravMap.map[row][col] + weight
end

function printMap(gravMap)
    local map = gravMap:getGeneratedMap()
    for rowNum, rowTable in ipairs(map) do
        local t = {}
        for colNum, value in ipairs(rowTable) do
            table.insert(t, value)
        end
        print("[R: " .. rowNum .. "]", table.unpack(t))
    end
    print()
end

local function isTravsersableForPactor(row, col, pactor)
    return canBodyAffectTile(pactor, {row = row, col = col})
end

local function bestDirectionForPactorGivenCoordinate(gravMap, pactorName, coordinate)
    local bestMove = { direction = "NONE", weight = 0 }

    if coordinate then
        local map = gravMap:getGeneratedMap()

        if isTravsersableForPactor(coordinate.row - 1, coordinate.col, pactorName) then
            local weight = map[coordinate.row - 1][coordinate.col]
            if weight > bestMove.weight then
                bestMove.weight = weight
                bestMove.direction = "UP"
            end
        end
        
        if isTravsersableForPactor(coordinate.row + 1, coordinate.col, pactorName) then
            local weight = map[coordinate.row + 1][coordinate.col]
            if weight > bestMove.weight then
                bestMove.weight = weight
                bestMove.direction = "DOWN"
            end
        end
        
        if isTravsersableForPactor(coordinate.row, coordinate.col + 1, pactorName) then
            local weight = map[coordinate.row][coordinate.col + 1]
            if weight > bestMove.weight then
                bestMove.weight = weight
                bestMove.direction = "RIGHT"
            end
        end
        
        if isTravsersableForPactor(coordinate.row, coordinate.col - 1, pactorName) then
            local weight = map[coordinate.row][coordinate.col - 1]
            if weight > bestMove.weight then
                bestMove.weight = weight
                bestMove.direction = "LEFT"
            end
        end
    
    end
    
    return bestMove.direction
end

local function bestMove(gravMap, pactorName)
    local exists, coordinate = pcall(getCoordinateOfPactor, pactorName)
    if not exists then 
        coordinate = nil 
    end
    return bestDirectionForPactorGivenCoordinate(gravMap, pactorName, coordinate)
end

local coordinateModifiers = {
    UP    = function(gravMap, coordinate) coordinate.row = wrapRow(gravMap, coordinate.row - 1) end,
    DOWN  = function(gravMap, coordinate) coordinate.row = wrapRow(gravMap, coordinate.row + 1) end,
    LEFT  = function(gravMap, coordinate) coordinate.col = wrapCol(gravMap, coordinate.col - 1) end,
    RIGHT = function(gravMap, coordinate) coordinate.col = wrapCol(gravMap, coordinate.col + 1) end,
}

local function bestSecondaryMove(gravMap, pactorName)
    local exists, coordinate = pcall(getCoordinateOfPactor, pactorName)
    if not exists then 
        coordinate = nil 
    end

    local direction = bestMove(gravMap, pactorName)
    local coordinateModifier = coordinateModifiers[direction]
    if type(coordinateModifier) == 'function' then
        coordinateModifier(gravMap, coordinate)
    end
    
    return bestDirectionForPactorGivenCoordinate(gravMap, pactorName, coordinate)
end

public.new = function(this)
    return {
        setWeights = setWeights,
        setDegeneracyFunction = setDegeneracyFunction,
        generate = generate,
        getGeneratedMap = getGeneratedMap,
        bestMove = bestMove,
        bestSecondaryMove = bestSecondaryMove,
        print = printMap,
        _actors = Queue:new(),
    }
end

return public