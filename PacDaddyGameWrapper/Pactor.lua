local public = {}

local function new()
    local self = luajava.newInstance("Engine.Pactor")
    self:setAttribute("TYPE", "PACTOR")
    return self
end

public.new = new

return public

