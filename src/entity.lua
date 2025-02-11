Entity = {}
Entity.__index = Entity

function Entity.new()
    return setmetatable({

        x = 0,
        y = 0,

        w = 0,
        h = 0,

        isDead = false,
        isMoving = false,

        health = 100,
        defense = 0,

        isColliding = false

    }, self)
end

function Entity:kill()

    self.isDead = true
    self.isMoving = false
    self.health = 0
end

function Entity:attack(damage, entity)

    entity.health = entity.health - (entity.defense - damage)

    if entity.health <= 0 then
        entity:kill()
    end
end

function Entity:isColliding(object)

    return self.x + self.w >= object.x and self.x <= object.x + object.w and self.y + self.h >= object.y and self.y <= object.y + object.h
end