timers = {}

local function doLater(action, time)
    
    table.insert(timers, {

        active = true,

        action = action,
        time = os.time() + time,
    })

    return #timers
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

local function nineSlicedRect(source, target, targetPlayer, x, y, width, height)
    return {
        tfm.exec.addImage(source[1].img, target, x, y, targetPlayer, 1, 1),
        tfm.exec.addImage(source[2].img, target, x+source[1].w, y, targetPlayer, (width-source[1].w-source[3].w)/source[2].w, 1),
        tfm.exec.addImage(source[3].img, target, x+width-source[3].w, y, targetPlayer, 1, 1),
        tfm.exec.addImage(source[4].img, target, x, y+source[1].h, targetPlayer, 1, (height-source[1].h-source[7].h)/source[4].h),
        tfm.exec.addImage(source[5].img, target, x+source[1].w, y+source[1].h, targetPlayer, (width-source[1].w-source[3].w)/source[2].w, (height-source[1].h-source[7].h)/source[4].h),
        tfm.exec.addImage(source[6].img, target, x+width-source[6].w, y+source[1].h, targetPlayer, 1, (height-source[1].h-source[7].h)/source[4].h),
        tfm.exec.addImage(source[7].img, target, x, y+height-source[7].h, targetPlayer, 1, 1),
        tfm.exec.addImage(source[8].img, target, x+source[7].w, y+height-source[8].h, targetPlayer, (width-source[1].w-source[3].w)/source[2].w, 1),
        tfm.exec.addImage(source[9].img, target, x+width-source[9].w, y+height-source[9].h, targetPlayer, 1, 1),
    }
end

local function removeNineSlicedRect(source)

    for _, v in next, source do

        tfm.exec.removeImage(v)
    end
end