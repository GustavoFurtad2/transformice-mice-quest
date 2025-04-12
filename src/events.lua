function eventNewPlayer(name)

    data[name] = data[name] or Player:new(name)

    data[name]:init()

    ui.setMapName("#micequest")
end

function eventKeyboard(name, key, down, x, y)

    data[name]:keyboard(key, down, x, y)
end

function eventTextAreaCallback(id, name, event)

    if event:sub(1, 6) == "dialog" then

        local cutsceneName = event:sub(7)

        Cutscenes[cutsceneName]:nextDialog(name)
    elseif event:sub(1, 7) == "profile" then

        local playerName = event:sub(8)

        data[name]:openProfile(playerName)

    elseif event == "closeProfile" then

        data[name]:closeProfile()
    end
end

function eventLoop()

    checkTimers()
end

for name in next, tfm.get.room.playerList do
    eventNewPlayer(name)
end