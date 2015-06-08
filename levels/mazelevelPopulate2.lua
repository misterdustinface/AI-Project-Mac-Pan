local populationTable = {
    { class = "Player",    row = 18, col = 16,  name = "PLAYER1",   traversable = { "FLOOR" } },
    { class = "Enemy",     row = 8,  col = 2,  name = "BLINKY",    traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.75 },
    { class = "Energizer", row = 2,  col = 2,   name = "ENERGIZER", traversable = { "FLOOR" } },
    { class = "Pellet",    row = 2,  col = 13,  name = "PELLET",    traversable = { "FLOOR" } },
    { class = "Pellet",    row = 8,  col = 7,   name = "PELLET2",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 17, col = 17,  name = "PELLET3",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 17, col = 3,   name = "PELLET4",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 18, col = 20,  name = "PELLET5",   traversable = { "FLOOR" } },
    { class = "Pellet",    row = 3,  col = 20,  name = "PELLET6",   traversable = { "FLOOR" } },
}

print("MAZE LEVEL 2")

return populationTable