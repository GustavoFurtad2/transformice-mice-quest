function eventNewPlayer(name)

    tfm.exec.respawnPlayer(name)
    data[name] = data[name] or Player:new(name)

    ui.setMapName("#micequest")
end

for name in next, tfm.get.room.playerList do
    eventNewPlayer(name)
end