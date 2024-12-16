timers = {}

local function doLater(action, time)
    
    table.insert(timers, {

        active = true,

        action = action,
        time = os.time() + time,
    })
end

local function checkTimers()

    local currentTime = os.time()

    local toRemove = {}

    for i, timer in next, timers do

        if timer.active and currentTime >= timer.time then

            timer.action()
            table.insert(toRemove, i)
        end
    end

    for i in next, toRemove do
        table.remove(timers, i)
    end
end