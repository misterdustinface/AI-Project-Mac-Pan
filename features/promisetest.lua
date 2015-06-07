require("luasrc/Future")

local function factorial(x)
	local result
	if x <= 1 then 
		result = 1
	else
		result = x * factorial(x - 1)
	end
	return result
end

local function promiseChecker(promise, name)
	while not (promise:isFulfilled() or promise:isBroken()) do 
		print(name, "Pending?", promise:isPending())
	end
	
	print(name, "RESULT:", promise:result())
	return promise:result()
end

local function test()
	local simplePromise = Future(factorial, 7)
	local x = Future(promiseChecker, simplePromise, "SIMPLE PROMISE")
	local hardPromise = Future(factorial, 20)
	local y = Future(promiseChecker, hardPromise, "HARD PROMISE")
end

test()