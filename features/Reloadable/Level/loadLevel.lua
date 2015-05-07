local file = require("luasrc/File")
local world = GAME:getModifiableWorld()

local levelString = file:toString("levels/largeroom.txt")
world:loadFromString(levelString)
--print(levelString)