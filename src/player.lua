local Player = {}
Player.__index = Player

function Player:new(name)

    local player = setmetatable({

        name = name,

        entity = Entity.new(),

        speed = 35,

        maxHealth = 100,

        canMove = false,

        stopMoveTimerIndex,

        class = "",

        lang = "br",

        currentDialog,

        character = {

            frame,
            speedX,
            speedY,
            direction = "down",
        },

        backpack = {},
        cutscene = {},

        isInCutscene = false,
        isMenuOpen = false,

        menu = {interface = {}},

        progress = {

            prologue = {

                chooseClass = false,
            },
        }

    }, Player)

    player.entity.health = player.maxHealth

    return player
end

function Player:init()
    
    tfm.exec.respawnPlayer(self.name)
    self.entity.health = self.maxHealth

    tfm.exec.freezePlayer(self.name, true, false)

    self.character.frame = tfm.exec.addImage(images.mouse[self.character.direction], "%" .. self.name, -13.75, -16.25, name, 1.25, 1.25)

    for _, key in next, {"W", "A", "S", "D"} do
        tfm.exec.bindKeyboard(self.name, string.byte(key), false, true)
        tfm.exec.bindKeyboard(self.name, string.byte(key), true, true)
    end

    tfm.exec.bindKeyboard(self.name, string.byte("M"), false, true)

    if not self.progress.prologue.chooseClass then

        Cutscenes.prologue:init(self.name)
    end
end

function Player:kill()

    tfm.exec.killPlayer(self.name)
    self.entity:kill()
end

function Player:setHealth(health)

    self.entity.health = math.min(health, self.maxHealth)
end

function Player:addHealth(health)

    self:setHealth(self.entity.health + health)
end

function Player:subHealth(health)

    self:setHealth(self.entity.health - health)

    if self.entity.health <= 0 then
        self:kill()
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

        self.entity.isMoving = false
        return
    end

    if self.character.direction ~= direction then

        if direction == "up" or direction == "right" or direction == "down" then

            self:changeDirection(direction)
        else

            self:changeDirection("right", true)
        end
    end

    local speedX, speedY = 0, 0

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

    tfm.exec.movePlayer(self.name, 0, 0, false, speedX, speedY, false)

    doLater(function()
        if not down and self.entity.isMoving then
            tfm.exec.movePlayer(self.name, 0, 0, false, 0, 0, false)
            self.entity.isMoving = false
        end
    end, 500)

    self.entity.isMoving = true
end

function Player:openMenu()

    self.isMenuOpen = true

    table.insert(self.menu.interface, nineSlicedRect(images.window, ":0", self.name, 700, 100, 80, 250))

    ui.addTextArea(-20, "<p align='center'>Menu</p>", self.name, 700, 110, 80, 50, 0xf, 0xf, 2, true)
end

function Player:closeMenu()

    self.isMenuOpen = false

    removeNineSlicedRect(self.menu.interface)

    ui.removeTextArea(-20, self.name)
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

    elseif key == string.byte("M") then

        if not self.isInCutscene then

            if not self.isMenuOpen then

                self:openMenu()
            else

                self:closeMenu()
            end
        end
    end
end