local populationTable = {
    { class = "Player",    row = 2, col = 16,  name = "PLAYER1",   traversable = { "FLOOR" } },
    { class = "Enemy",     row = 8,  col = 2,   name = "BLINKY",     traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.75 },
    { class = "Enemy",     row = 8,  col = 2,   name = "PINKY",      traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.40 },
    { class = "Energizer", row = 2,  col = 2,   name = "ENERGIZER", traversable = { "FLOOR" } },
    { class = "Pellet",    row = 2,  col = 13,  name = "PELLET",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 8,  col = 7,   name = "PELLET2",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 17, col = 17,  name = "PELLET3",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 17, col = 2,   name = "PELLET4",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 17, col = 20,  name = "PELLET5",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 2,  col = 20,  name = "PELLET6",   traversable = { "FLOOR" } },
}

GAME:setValueOf("SHOULD_SHUFFLE_WALLS", true)

return populationTable