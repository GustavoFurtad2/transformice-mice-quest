function eventNewPlayer(name)

    data[name] = data[name] or Player:new(name)

    data[name]:init()

    ui.setMapName("#micequest")
end

function eventKeyboard(name, key, down, x, y)

    data[name]:keyboard(key, down, x, y)
end

function eventTextAreaCallback(id, name, event)

    local isDialog = event:sub(1, 6) == "dialog"

    local cutsceneName = event:sub(7)

    if isDialog then

        Cutscenes[cutsceneName]:nextDialog(name)
    end
end

function eventLoop()

    checkTimers()
end

for name in next, tfm.get.room.playerList do
    eventNewPlayer(name)
end