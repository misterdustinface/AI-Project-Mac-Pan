require("PacDaddyGameWrapper/PactorCollisionFunction")
local Pactor = require("PacDaddyGameWrapper/Pactor")

local public = {}

local function new()
    local enemy = Pactor:new()
    enemy:setAttribute("IS_ENEMY", true)
    enemy:setAttribute("TYPE", "ENEMY")
    enemy:setAttribute("VALUE", 200)
    
    local function onPactorCollision(otherPactorAttributes)
        -- NA
    end
    
    enemy:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return enemy
end

public.new = new

return public