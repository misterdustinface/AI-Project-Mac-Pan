require("luasrc/Future")
local Queue = require("luasrc/Queue")

local function setWeights(field, weights)
    field.weights = weights
end

local function setDegeneracyFunction(field, degeneracyFunction)
    field.degeneracyFunction = degeneracyFunction
end

local function setDistanceDirectionFunction(field, distanceDirectionFunction)
	field.distanceDirectionFunction = distanceDirectionFunction
end

local function distanceDispatch(distanceDirectionFunction)
	local promises = Queue:new()
	local pactorpairs = Queue:new()
	local pactors = GAME:getAllPactors()
	
	local recordedPactors = {}
	for i, pactor in ipairs(pactors) do	
		if #recordedPactors > 1 then
			for j, other in ipairs(recordedPactors) do
				local nameA = pactor:getValueOf("NAME")
				local nameB = pactor:getValueOf("NAME")
				local A = GAME:getCoordinateOfPactor(nameA)
				local B = GAME:getCoordinateOfPactor(nameB)
				if A and B then
					promises:enqueue(Future(distanceDirectionFunction, A, B))
					pactorpairs:enqueue({first = nameA, second = nameB})
				end
			end
		end
		
		table.insert(recordedPactors, pactor)
	end
	
	return promises, pactorpairs
end

local function waitForAllPromisesToConcludeAndRecordDistancesAndDirections(promisesQueue)
	local distances = Queue:new()
	local directions = Queue:new()
	while not promisesQueue:isEmpty() do
		if not promisesQueue:peek():isPending() then
			local distance, direction = promisesQueue:dequeue():result()
			distances:enqueue(distance)
			directions:enqueue(direction)
		end
	end
	return distances, directions
end

local function recordDistancesAndDirectionsAtPactorPairs(field, distances, directions, pactorpairs)
	for _, result in ipairs(results) do
		local pactorpair = pactorpairs:dequeue()
		local distance   = distances:dequeue()
		local direction  = directions:dequeue()
		local dd = {distance = distance, direction = direction}
		field.f[pactorpair.first .. " and " .. pactorpair.second] = dd
		field.f[pactorpair.second .. " and " .. pactorpair.first] = dd
	end
end

local function generate(field)
	local promises, pactorpairs = distanceDispatch(field.distanceDirectionFunction)
	local distances, directions = waitForAllPromisesToConcludeAndRecordDistancesAndDirections(promises)
	recordDistancesAndDirectionsAtPactorPairs(field, distances, directions, pactorpairs)
end

local directions = {"UP", "DOWN", "LEFT", "RIGHT"}

local function bestMove(field, myPactorName)
	local pactors = GAME:getAllPactors()
	local bestMoveWeight = -999999999999
	local bestMoveDirection = GAME:getPactor(myPactorName):getValueOf("DIRECTION")
	
	for j, pactor in ipairs(pactors) do
		local othername = pactor:getValueOf("NAME")
		local dd = field.f[myPactorName .. " and " .. othername]
		local weight = field.weights[pactor:getValueOf("TYPE")]
		
		if dd and weight then
			local distance, direction = dd.distance, dd.direction
			for k, dir in ipairs(directions) do
				local dis   = (dir == direction) and (distance - 1) or (distance + 1)
				local force = field.degeneracyFunction(dis, weight)
				if force > bestMoveWeight then 
					bestMoveWeight = force 
					bestMoveDirection = dir
				end
			end
		end
	end
	
	return bestMoveDirection, bestMoveWeight
end

local function exampleDistanceDirectionFunction(A, B)
 -- A and B are coordinates
	local distance = 0
	local direction = "NONE"
	return distance, direction
end

local function new()
    return {
		setWeights = setWeights,
		setDistanceDirectionFunction = setDistanceDirectionFunction,
        generate = generate,
        setDegeneracyFunction = setDegeneracyFunction,
        bestMove = bestMove,
    }
end

return {
	new = new
}