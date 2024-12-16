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