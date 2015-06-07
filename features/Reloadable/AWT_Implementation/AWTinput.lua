require("luasrc/tif")
local KEYS = require("AWTLib/AWTKeycodes")

local pressProcessDispatch = {
    [KEYS.UP]    = function() GAME:sendCommand("UP")    end,
    [KEYS.LEFT]  = function() GAME:sendCommand("LEFT")  end,
    [KEYS.DOWN]  = function() GAME:sendCommand("DOWN")  end,
    [KEYS.RIGHT] = function() GAME:sendCommand("RIGHT") end,
    [KEYS.ENTER] = function() GAME:sendCommand("RESTART") end,    

    [KEYS.R]     = function() GAME:sendCommand("RELOAD") end,

    [KEYS.Q]     = function() GAME:sendCommand("QUIT")   end,
    [KEYS.ESC]   = function() GAME:sendCommand("QUIT")   end,

    [KEYS.P]     = function() GAME:sendCommand(tif(GAME:getValueOf("IS_PAUSED"), "PLAY", "PAUSE")) end,
    
    [KEYS.ONE]   = function() GAME:sendCommand("LIVES--") end,
    [KEYS.TWO]   = function() GAME:sendCommand("LIVES++") end,
    
    [KEYS.THREE] = function() GAME:sendCommand("GAMESPEED--") end,
    [KEYS.FOUR]  = function() GAME:sendCommand("GAMESPEED++") end,

    [KEYS.FIVE]  = function() GAME:sendCommand("FPS--") end,
    [KEYS.SIX]   = function() GAME:sendCommand("FPS++") end,

    [KEYS.SEVEN] = function() GAME:sendCommand("LEVEL--") end,
    [KEYS.EIGHT] = function() GAME:sendCommand("LEVEL++") end,
    
    [KEYS.NINE]  = function() GAME:sendCommand("TOGGLE_WALL_SHUFFLE") end, 
    [KEYS.ZERO]  = function() GAME:sendCommand("TOGGLE_PLAYER_AI") end,
}

PRESS_PROCESS_DISPATCH = pressProcessDispatch