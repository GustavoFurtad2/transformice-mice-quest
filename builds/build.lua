for _, s in next, {"AutoNewGame", "AutoShaman", "AfkDeath", "MortCommand", "PhysicalConsumables"} do
    tfm.exec["disable" .. s]()
end

tfm.exec.newGame [[<C><P /><Z><S><S L="800" H="48" X="401" Y="376" T="0" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DS Y="337" X="400" /></D><O /></Z></C>]]

ui.setMapName("#micequest")

local data = {}

local Player = {}
Player.__index = Player

function Player:new(name)

    local player = setmetatable({

        name = name,

        health = 100,
        maxHealth = 100,

        isDead = false,

        backpack = {}

    }, Player)

    return player
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

