local world = GAME:getModifiableWorld()

local Player = require("PacDaddyGameWrapper/Player")
local Enemy  = require("PacDaddyGameWrapper/Enemy")
local PointsPickup = require("PacDaddyGameWrapper/PointsPickup")

local player = Player:new()
world:addPactor("PLAYER1", player)
world:setPactorSpawn("PLAYER1", 17, 14)
world:respawnPactor("PLAYER1")
world:setTileAsTraversableForPactor("FLOOR", "PLAYER1")

local Pickup = require("PacDaddyGameWrapper/PointsPickup")
local pickup = Pickup:new()
local pactorName = "GOAL"
world:addPactor("GOAL", pickup)
world:setPactorSpawn("GOAL", 1, 1)
world:respawnPactor("GOAL")
world:setTileAsTraversableForPactor("FLOOR", "GOAL")

local pickup2 = Pickup:new()
local pactorName = "GOAL2"
world:addPactor("GOAL2", pickup2)
world:setPactorSpawn("GOAL2", 1, 18)
world:respawnPactor("GOAL2")
world:setTileAsTraversableForPactor("FLOOR", "GOAL2")

local pickup3 = Pickup:new()
local pactorName = "GOAL3"
world:addPactor("GOAL3", pickup3)
world:setPactorSpawn("GOAL3", 10, 18)
world:respawnPactor("GOAL3")
world:setTileAsTraversableForPactor("FLOOR", "GOAL3")

local frienemy = Enemy:new()
world:addPactor("FRIENEMY", frienemy)
world:setPactorSpawn("FRIENEMY", 12, 13)
world:setPactorSpeed("FRIENEMY", 0.5)
world:respawnPactor("FRIENEMY")
world:setTileAsTraversableForPactor("FLOOR", "FRIENEMY")
world:setTileAsTraversableForPactor("ENEMY_SPAWN", "FRIENEMY")

local frienemy2 = Enemy:new()
world:addPactor("FRIENEMY2", frienemy2)
world:setPactorSpawn("FRIENEMY2", 9, 13)
world:setPactorSpeed("FRIENEMY2", 0.3)
world:respawnPactor("FRIENEMY2")
world:setTileAsTraversableForPactor("FLOOR", "FRIENEMY2")
world:setTileAsTraversableForPactor("ENEMY_SPAWN", "FRIENEMY2")
--
--local tilenames = GAME:getTileNames()
--local board = GAME:getTiledBoard()
--local Pickup = require("PacDaddyGameWrapper/PointsPickup")
--
--for row = 1, board.length do
--    for col = 1, board[1].length do
--        local tileEnum = board[row][col]
--        local tileName = tilenames[tileEnum+1]
--        
--        if tileName == "FLOOR" then
--            local pickup = Pickup:new()
--            local pactorName = "PICKUP".."R:"..row.."C:"..col
--            world:addPactor(pactorName, pickup)
--            world:setPactorSpawn(pactorName, row-1, col-1)
--            world:respawnPactor(pactorName)
--        end
--        
--    end
--end