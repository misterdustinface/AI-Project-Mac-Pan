require("luasrc/VoidFunctionPointer")
require("luasrc/TickingLoop")
GAME = require("PacDaddyGameWrapper/PacDaddyGameWrapper")
local mainLoop = GAME:getModifiableGameLoop()

local function mainLoopAIPerform()      AI_PERFORM()         end
local function mainLoopCheckGameRules() GAME_RULES_TICK()    end
local function mainLoopShuffleWalls()   WALL_SHUFFLE_TICK()  end
local function aiTickComponent()        AI_TICK()            end

mainLoop:addFunction(VoidFunctionPointer(mainLoopAIPerform))
mainLoop:addFunction(VoidFunctionPointer(mainLoopCheckGameRules))
mainLoop:addFunction(VoidFunctionPointer(mainLoopShuffleWalls))

AI_TICK_LOOP = TickingLoop(0, VoidFunctionPointer(aiTickComponent))

GAME:addComponent("AI", AI_TICK_LOOP)