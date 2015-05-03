-- https://gist.github.com/leegao/1074642
local push
local pushAll
local setComparator
local pop
local peek
local isEmpty
local size
local clear

local table = require "table"
local insert = table.insert
local remove = table.remove

local public = {}

function setComparator(this, comparator)
    this.comparator = comparator or function(a,b) return a < b end
end

function pushAll(this, elements)
    for _, element in ipairs(elements or {}) do
        this:push(element)
    end
end

function push(pq, element)
    insert(pq, element)
    local next = #pq
    local prev = (next-next%2)/2
    while next > 1 and pq.comparator(pq[next], pq[prev]) do
        pq[next], pq[prev] = pq[prev], pq[next]
        next = prev
        prev = (next-next%2)/2
    end
end

function pop(pq)
    if #pq < 2 then
        return remove(pq)
    end
    local root = 1
    local r = pq[root]
    pq[root] = remove(pq)
    local size = #pq
    if size > 1 then
        local child = 2*root
        while child <= size do
            if pq.comparator(pq[child], pq[root]) then
                pq[root], pq[child] = pq[child], pq[root]
                root = child
            elseif child+1 <= size and pq.comparator(pq[child+1], pq[root]) then
                pq[root], pq[child+1] = pq[child+1], pq[root]
                root = child+1
            else
                break
            end
            child = 2*root
        end
    end
    return r
end

function peek(pq)
    return pq[1]
end

function isEmpty(pq)
    return pq:size() == 0
end

function size(pq)
    return pq.size
end

function clear(pq)
    while not pq:isEmpty() do
        pq:pop()
    end
end

function public.new(this)
    return setmetatable({}, {
        __index = {
            size = 0,
            push = push,
            pushAll = pushAll,
            setComparator = setComparator,
            pop = pop,
            peek = peek,
            isEmpty = isEmpty,
            size = size,
            clear = clear,
        }
    })
end

return public