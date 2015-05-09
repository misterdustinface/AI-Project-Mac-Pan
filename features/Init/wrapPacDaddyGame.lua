require("luasrc/VoidFunctionPointer")
require("luasrc/TickingLoop")

GAME = require("PacDaddyGameWrapper/PacDaddyGameWrapper")
local mainLoop = GAME:getGameLoop()

local function mainLoopAIPerform()      AI_PERFORM()         end
local function mainLoopCheckGameRules() GAME_RULES_TICK()    end
local function mainLoopShuffleWalls()   WALL_SHUFFLE_TICK()  end
local function aiTickComponent()        AI_TICK()            end
local function playerAITickComponent()  PLAYER_AI_TICK()     end

mainLoop:addFunction(VoidFunctionPointer(mainLoopAIPerform))
mainLoop:addFunction(VoidFunctionPointer(mainLoopCheckGameRules))
mainLoop:addFunction(VoidFunctionPointer(mainLoopShuffleWalls))

AI_TICK_LOOP = TickingLoop(0, VoidFunctionPointer(aiTickComponent))
PLAYER_AI_TICK_LOOP = TickingLoop(0, VoidFunctionPointer(playerAITickComponent))

GAME:addComponent("AI", AI_TICK_LOOP)
GAME:addComponent("PLAYER AI", PLAYER_AI_TICK_LOOP)