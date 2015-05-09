local world = GAME:getWorld()

math.randomseed(os.time())

local function generateCoordinate()
    local ROWS = world:getRows()
    local COLS = world:getCols()
    local row = math.random(ROWS) - 1
    local col = math.random(COLS) - 1
    return row, col
end

local function shuffleWalls()

end

WALL_SHUFFLE_TICK = shuffleWalls