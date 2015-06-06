local populationTable = {
    { class = "Player",    row = 8,  col = 13, name = "PLAYER1",   traversable = { "FLOOR" } },
    { class = "Enemy",     row = 8,  col = 2,  name = "BLINKY",    traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.75 },
    { class = "Energizer", row = 2,  col = 13, name = "ENERGIZER", traversable = { "FLOOR" } },
    { class = "Pellet",    row = 2,  col = 2,  name = "PELLET",    traversable = { "FLOOR" } },
}

GAME:setValueOf("SHOULD_SHUFFLE_WALLS", false)

return populationTable