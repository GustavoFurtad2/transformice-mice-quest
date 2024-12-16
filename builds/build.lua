for _, s in next, {"AutoNewGame", "AutoShaman", "AfkDeath", "MortCommand", "PhysicalConsumables"} do
    tfm.exec["disable" .. s]()
end

tfm.exec.newGame [[<C><P G="0,0" Ca="" MEDATA=";;;;-0;0:::1-"/><Z><S/><D><DS X="400" Y="200"/></D><O/><L/></Z></C>]]

ui.setMapName("#micequest")

local data = {}

local images = {

    mouse = {

        up = "18d5c83d73b.png",
        down = "18d5c833aa1.png",
        right = "18d5c83891b.png",
    }
}

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

local Player = {}
Player.__index = Player

function Player:new(name)

    local player = setmetatable({

        name = name,

        health = 100,
        maxHealth = 100,

        isDead = false,

        character = {

            direction = "down"
        },

        backpack = {}

    }, Player)

    return player
end

function Player:init()
    
    tfm.exec.respawnPlayer(self.name)

    tfm.exec.freezePlayer(self.name, true, false)

    tfm.exec.addImage(images.mouse[self.character.direction], "%" .. self.name, -13.75, -16.25, name, 1.25, 1.25)
end

function Player:kill()

    tfm.exec.killPlayer(self.name)

    self.isDead = true
end

function Player:setHealth(health)

    self.health = math.min(health, self.maxHealth)
end

function Player:addHealth(health)

    self.health = math.min(self.health + health, self.maxHealth)
end

function Player:subHealth(health)

    self.health = self.health - health

    if self.health <= 0 then
        self:killPlayer()
    end
end

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

