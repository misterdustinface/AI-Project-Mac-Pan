local public = {}

local start
local stop
local average
local recordStop

function start(this)
    this.starttime = os.clock()
end

function stop(this)
    local exectime = os.clock() - this.starttime
    recordStop(this, exectime)
    return exectime
end

function recordStop(timer, newtime)
    if timer.isAveraging then
        timer.totaltime = timer.totaltime + newtime
        timer.ticks = timer.ticks + 1
        if timer.ticks % timer.ticksUntilOutput == 0 then
            print(timer.totaltime / timer.ticks)
        end
    end
end

function average(this, ticksUntilOutput)
    this.ticksUntilOutput = ticksUntilOutput
    this.isAveraging = this.ticksUntilOutput ~= nil
end

public.new = function() 
  return {
      totaltime = 0,
      ticks = 0,
      starttime = 0,
      start = start,
      stop  = stop,
      average = average,
  }
end

return public