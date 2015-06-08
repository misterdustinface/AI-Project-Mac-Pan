local populationTable = {
    { class = "Player",    row = 8,  col = 13, name = "PLAYER1",   traversable = { "FLOOR" } },
    { class = "Enemy",     row = 8,  col = 2,  name = "GUNKY",     traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.5 },
    { class = "Enemy",     row = 10, col = 30, name = "INKY",      traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.75 },
    { class = "Energizer", row = 2,  col = 2,  name = "ENERGIZER", traversable = { "FLOOR" } },
    { class = "Pellet",    row = 2,  col = 40, name = "PELLET",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 20, col = 40, name = "PELLET2",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 20, col = 2,  name = "PELLET3",   traversable = { "FLOOR" } },

}

GAME:setValueOf("SHOULD_SHUFFLE_WALLS", false)

print("Large Room Level")

return populationTable