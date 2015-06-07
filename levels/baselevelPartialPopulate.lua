local populationTable = {
    { class = "Player",    row = 24, col = 15, name = "PLAYER1",    traversable = { "FLOOR" } },
    { class = "Enemy",     row = 13, col = 15, name = "BLINKY",     traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.75 },
    { class = "Enemy",     row = 15, col = 14, name = "INKY",       traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.50 },
    { class = "Enemy",     row = 14, col = 14, name = "GUNKY",      traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.10 },
    { class = "Energizer", row = 24, col = 27, name = "ENERGIZER1", traversable = { "FLOOR" } },
    { class = "Energizer", row = 24, col = 2,  name = "ENERGIZER2", traversable = { "FLOOR" } },
    { class = "Energizer", row = 4,  col = 27, name = "ENERGIZER3", traversable = { "FLOOR" } },
    { class = "Energizer", row = 4,  col = 2,  name = "ENERGIZER4", traversable = { "FLOOR" } },
    { class = "Pellet",    row = 8,  col = 22, name = "PELLET1",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 8,  col = 19, name = "PELLET2",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 8,  col = 10, name = "PELLET3",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 8,  col = 7,  name = "PELLET4",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 20, col = 22, name = "PELLET5",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 20, col = 19, name = "PELLET6",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 20, col = 10, name = "PELLET7",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 20, col = 7,  name = "PELLET8",    traversable = { "FLOOR" } },
}

GAME:setValueOf("SHOULD_SHUFFLE_WALLS", true)

return populationTable