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