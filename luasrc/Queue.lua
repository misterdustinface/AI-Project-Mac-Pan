local public = {}

local function new(this) 

    local newQueue = {
      elements = {},
      size = function(thisQueue)
        return #(thisQueue.elements)
      end,
      enqueue = function(thisQueue, element)
        table.insert(thisQueue.elements, element)
      end,
      dequeue = function(thisQueue)
        return table.remove(thisQueue.elements, 1)
      end, 
      peek = function(thisQueue)
        return thisQueue.elements[1]
      end,
      isEmpty = function(thisQueue)
        return thisQueue:size() == 0
      end,
      toString = function(thisQueue)
        return table.concat(thisQueue.elements, "\n")
      end,
      get = function(thisQueue, index)
        return thisQueue.elements[index]
      end,
      clear = function(thisQueue)
        thisQueue.elements = {}
      end
    }

    return newQueue 
end

public.new = new

return public