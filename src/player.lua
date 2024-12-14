local Player = {}
Player.__index = Player

local function Player:new(name)

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

    self.health = health <= self.maxHealth and health or self.maxHealth
end

function Player:addHealth(health)

    local sumHealth = self.health + health

    self.health = sumHealth <= self.maxHealth and sumHealth or self.maxHealth
end

function Player:subHealth(health)

    local subHealth = self.health - health

    self.health = subHealth > 0 and sumHealth or 0
end