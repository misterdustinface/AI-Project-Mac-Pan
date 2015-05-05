local function populateTickingLoop(tickingLoop, ...)
    local args = {...}
    for _, val in ipairs(args) do
        if type(val) == "number" then
          tickingLoop:setUpdatesPerSecond(val)
        else
          tickingLoop:addFunction(val)
        end
    end
    return tickingLoop
end

function TickingLoop(...)
    local tickingLoop = luajava.newInstance("base.TickingLoop")
    tickingLoop = populateTickingLoop(tickingLoop, ...)
    return tickingLoop
end