local file = require("luasrc/File")
local world = GAME:getModifiableWorld()

local levelString = file:toString("levels/stupidlevel.txt")
world:loadFromString(levelString)
--print(levelString)