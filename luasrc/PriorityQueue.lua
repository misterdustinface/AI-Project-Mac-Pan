-- https://gist.github.com/leegao/1074642
local push
local pushAll
local setComparator
local pop
local peek
local isEmpty
local size
local clear
local compare

local table = require "table"
local insert = table.insert
local remove = table.remove

local public = {}

function setComparator(this, comparator)
    this.comparator = comparator or (function(a,b) return a < b end)
end

function compare(this, A, B)
    return this.comparator(A, B)
end

function pushAll(this, elements)
    for _, element in ipairs(elements or {}) do
        this:push(element)
    end
end

function push(pq, element)
    local elements = pq.elements
    insert(elements, element)
    if pq:size() > 1 then
        local next = pq:size()
        local prev = (next-(next%2))/2
        while next > 1 and pq:compare(elements[next], elements[prev]) do
            elements[next], elements[prev] = elements[prev], elements[next]
            next = prev
            prev = (next-next%2)/2
        end
    end
end

function pop(pq)
    local size = pq:size()
    local elements = pq.elements
    
    if size == 0 then
        return nil
    elseif size == 1 then
        return remove(elements)
    else
        local root = 1
        local r = elements[root]
        elements[root] = remove(elements)
        size = size - 1
        
        local child = 2*root
        while child <= size do
            if pq:compare(elements[child], elements[root]) then
                elements[root], elements[child] = elements[child], elements[root]
                root = child
            elseif child+1 <= size and pq:compare(elements[child+1], elements[root]) then
                elements[root], elements[child+1] = elements[child+1], elements[root]
                root = child+1
            else
                break
            end
            child = 2*root
        end
    
        return r
    end
end

function peek(pq)
    return pq.elements[1]
end

function isEmpty(pq)
    return pq:size() == 0
end

function size(pq)
    return #(pq.elements)
end

function clear(pq)
    while not pq:isEmpty() do
        pq:pop()
    end
end

function public.new(this)
    return setmetatable({}, {
        __index = {
            elements = {},
            push = push,
            pushAll = pushAll,
            setComparator = setComparator,
            pop = pop,
            peek = peek,
            isEmpty = isEmpty,
            size = size,
            clear = clear,
            compare = compare,
        }
    })
end

return public