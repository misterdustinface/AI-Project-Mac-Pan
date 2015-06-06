local file = require("luasrc/File")
local world = GAME:getWorld()

local levels = {
  "levels/baselevel.txt",
  "levels/stupidlevel.txt",
  "levels/mazelevel.txt",
  "levels/mazelevel.txt",
  "levels/mazelevel.txt",
  "levels/largeroom.txt",
}

local index = (GAME:getValueOf("LEVEL") % #levels) + 1

local levelString = file:toString(levels[index])
world:loadFromString(levelString)
--print(levelString)