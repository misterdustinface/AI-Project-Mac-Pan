local public = {}

public.elements = {}

public.size = function(thisQueue)
  return #(thisQueue.elements)
end

public.enqueue = function(thisQueue, element)
  table.insert(thisQueue.elements, element)
end

public.dequeue = function(thisQueue)
  return table.remove(thisQueue.elements, 1)
end

public.peek = function(thisQueue)
  return thisQueue.elements[1]
end

public.isEmpty = function(thisQueue)
  return thisQueue:size() == 0
end

public.toString = function(thisQueue)
  return table.concat(thisQueue.elements, "\n")
end

public.get = function(thisQueue, index)
  return thisQueue.elements[index]
end

public.clear = function(thisQueue)
  thisQueue.elements = {}
end

return public