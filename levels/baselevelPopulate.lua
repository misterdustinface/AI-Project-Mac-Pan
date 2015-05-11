local populationTable = {
    { class = "Player", row = 24, col = 15, name = "PLAYER1",   traversable = { "FLOOR" } },
    { class = "Enemy",  row = 15, col = 14, name = "FRIENEMY",  traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.5 },
    { class = "Enemy",  row = 15, col = 15, name = "FRIENEMY2", traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.3 },
    { class = "Pickup", row = 2,  col = 2,  name = "GOAL",      traversable = { "FLOOR" }},
    { class = "Pickup", row = 21, col = 8,  name = "GOAL2",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 2,  col = 20, name = "GOAL3",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 21, col = 27, name = "GOAL4",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 15, col = 7,  name = "GOAL5",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 15, col = 1,  name = "GOAL6",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 15, col = 28, name = "GOAL7",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 15, col = 21, name = "GOAL8",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 30, col = 15, name = "GOAL9",     traversable = { "FLOOR" }},
    { class = "Pickup", row = 12, col = 15, name = "GOAL10",    traversable = { "FLOOR" }},
    { class = "Pickup", row = 6,  col = 15, name = "GOAL11",    traversable = { "FLOOR" }},
}

local board = GAME:getTiledBoard()
local tilenames = GAME:getTileNames()

--for row = 1, board.length do
--    for col = 1, board[1].length do
--        local tileEnum = board[row][col]
--        local tileName = tilenames[tileEnum+1]
--        if tileName == "FLOOR" then
--            table.insert(populationTable, 
--              { class = "Pickup", row = row, col = col, name = "PICKUP_".."R:"..row.."C:"..col, traversable = { "FLOOR" } }
--            )
--        end
--    end
--end

return populationTable