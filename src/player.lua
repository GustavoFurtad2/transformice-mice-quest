local Player = {}
Player.__index = Player

function Player:new(name)

    local player = setmetatable({

        name = name,

        speed = 35,

        health = 100,
        maxHealth = 100,

        isDead = false,
        isMoving = false,

        canMove = false,

        stopMoveTimerIndex,

        class = "",

        lang = "br", --texts[tfm.get.room.playerList[name].community] or texts.en,

        currentDialog = 1,

        character = {

            frame,
            speedX,
            speedY,
            direction = "down",
        },

        backpack = {},
        cutscene = {},

        isInCutscene = false,

        progress = {

            prologue = {

                chooseClass = false,
            },
        }

    }, Player)

    return player
end

function Player:init()
    
    tfm.exec.respawnPlayer(self.name)

    tfm.exec.freezePlayer(self.name, true, false)

    self.character.frame = tfm.exec.addImage(images.mouse[self.character.direction], "%" .. self.name, -13.75, -16.25, name, 1.25, 1.25)

    for _, key in next, {"W", "A", "S", "D"} do
        tfm.exec.bindKeyboard(self.name, string.byte(key), false, true)
        tfm.exec.bindKeyboard(self.name, string.byte(key), true, true)
    end

    if not self.progress.prologue.chooseClass then

        Cutscenes.prologue:init(self.name)
    end
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

function Player:changeDirection(direction, flipped)

    self.character.direction = direction

    if self.character.frame ~= nil then
        tfm.exec.removeImage(self.character.frame)
    end

    local x, y, w, h = -13.76, -16.25, 1.25, 1.25

    if flipped then

        w = -w

        x = x + math.abs(images.mouse.w * w)

        self.character.direction = "left"
    end

    self.character.frame = tfm.exec.addImage(images.mouse[direction], "%" .. self.name, x, y, name, w, h)
end

function Player:move(direction, down)

    if not self.canMove then
        
        self.isMoving = false
        return
    end

    if self.isMoving and down then

        tfm.exec.movePlayer(self.name, 0, 0, false, speedX or 0, speedY or 0, false)

        doLater(function()
            if not down and self.isMoving then
                tfm.exec.movePlayer(self.name, 0, 0, false, 0, 0, false)
                self.isMoving = false
            end
        end, 500)

        return
    end

    if self.character.direction ~= direction then

        if direction == "up" or direction == "right" or direction == "down" then

            self:changeDirection(direction)
        else

            self:changeDirection("right", true)
        end
    end

    local speedX, speedY

    if direction == "left" then

        speedX = -self.speed
    elseif direction == "right" then

        speedX = self.speed
    elseif direction == "up" then

        speedY = -self.speed
    elseif direction == "down" then

        speedY = self.speed
    end

    self.character.speedX = speedX
    self.character.speedY = speedY

    tfm.exec.movePlayer(self.name, 0, 0, false, speedX or 0, speedY or 0, false)

    doLater(function()
        if not down and self.isMoving then
            tfm.exec.movePlayer(self.name, 0, 0, false, 0, 0, false)
            self.isMoving = false
        end
    end, 500)

    self.isMoving = true
end

function Player:keyboard(key, down, x, y)

    if key == string.byte("W") then

        self:move("up", down)
    elseif key == string.byte("A") then

        self:move("left", down)
    elseif key == string.byte("S") then

        self:move("down", down)
    elseif key == string.byte("D") then

        self:move("right", down)
    end
end