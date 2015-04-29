--local public = {}
--
--local function percolateUp()
--
--end
--
--local function add(this, element)
--    local head = this:peek()
--    
--    if not head then
--        table.insert(this.heap, element)
--        return
--    end
--    
--    local path = this.comparator(head, element)
--    
--    if path < 0 then
--    
--    else
--    
--    end
--end
--
--local function setComparator(this, comparatorFunction)
--    this.comparator = comparatorFunction
--end
--
--local function peek(this)
--    return this.heap[1]
--end
--
--local function poll(this)
--
--end
--
--local function size(this)
--
--end
--
--local function clear(this)
--    this.size = 0
--end
--
--local function new(this)
--    
--    local newPriorityQueue = {
--        heap = {},
--        size = 0,
--        add = add,
--        offer = add,
--        setComparator = setComparator,
--        peek = peek,
--        poll = poll,
--        size = size,
--        clear = clear,
--    }
--    
--    return newPriorityQueue
--end
--
--public.new = new
--
--return public

-- https://gist.github.com/leegao/1074642

local table = require "table"
local insert = table.insert
local remove = table.remove

local priority_queue = {}

function priority_queue.new(comparator, initial)
    local cmp = comparator or function(a,b) return a < b end

    local pq = setmetatable({}, {
        __index = {
            size = 0,
            push = function(self, v)
                insert(self, v)
                local next = #self
                local prev = (next-next%2)/2
                while next > 1 and cmp(self[next], self[prev]) do
                    self[next], self[prev] = self[prev], self[next]
                    next = prev
                    prev = (next-next%2)/2
                end
            end,
            pop = function(self)
                if #self < 2 then
                    return remove(self)
                end
                local root = 1
                local r = self[root]
                self[root] = remove(self)
                local size = #self
                if size > 1 then
                    local child = 2*root
                    while child <= size do
                        if cmp(self[child], self[root]) then
                            self[root], self[child] = self[child], self[root]
                            root = child
                        elseif child+1 <= size and cmp(self[child+1], self[root]) then
                            self[root], self[child+1] = self[child+1], self[root]
                            root = child+1
                        else
                            break
                        end
                        child = 2*root
                    end
                end
                return r
            end,
            peek = function(self)
                return self[1]
            end,
            isEmpty = function(self)
                return self.size == 0
            end,
        }
    })

    for _,el in ipairs(initial or {}) do
        pq:push(el)
    end

    return pq
end

return priority_queue