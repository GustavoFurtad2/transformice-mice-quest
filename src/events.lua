function eventNewPlayer(name)

    data[name] = data[name] or Player:new(name)

    data[name]:init()

    ui.setMapName("#micequest")
end

function eventLoop()

    checkTimers()
end

for name in next, tfm.get.room.playerList do
    eventNewPlayer(name)
end