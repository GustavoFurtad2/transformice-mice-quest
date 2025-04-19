-- [init.lua] 
for _, s in next, {"AutoNewGame", "AutoShaman", "AfkDeath", "MortCommand", "PhysicalConsumables"} do
    tfm.exec["disable" .. s]()
end

tfm.exec.newGame [[<C><P G="0,0" Ca="" MEDATA=";;;;-0;0:::1-"/><Z><S/><D><DS X="400" Y="200"/></D><O/><L/></Z></C>]]

ui.setMapName("#micequest")

local data = {}

-- [images.lua] 
local images = {

    mouse = {

        w = 22,
        h = 26,

        up = "18d5c83d73b.png",
        down = "18d5c833aa1.png",
        right = "18d5c83891b.png",
    },

    window = {
        {img = "17f85ff6afb.png", w = 28, h = 29},
        {img = "17f86018555.png", w = 8, h = 29},
        {img = "17f8601f67b.png", w = 28, h = 29},
        {img = "17f860256e6.png", w = 28, h = 4},
        {img = "17f8602b3f0.png", w = 8, h = 4},
        {img = "17f86038225.png", w = 28, h = 4},
        {img = "17f8603de5f.png", w = 28, h = 29},
        {img = "17f86043b4a.png", w = 8, h = 29},
        {img = "17f86049374.png", w = 28, h = 29},
    }
}

-- [texts.lua] 
local texts = {

    ["br"] = {

        secret_room_message_1 = "Bem-vindo(a) a sala secreta.",
        secret_room_message_2 = "Meu nome? Não importa.",
        secret_room_message_3 = "Você foi o escolhido para acabar com a ameaça ancestral.",
        secret_room_message_4 = "Não posso mais lutar contra ela... estou muito fraco, por isso te chamei",
        secret_room_message_5 = "Na frente de você, cada estátua representa uma classe diferente",
        secret_room_message_6 = "Cada arma foi forjada por um grande ferreiro do passado, escolha uma."
    },
}

-- [utils.lua] 
timers = {}

local function doLater(action, time)
    
    table.insert(timers, {

        active = true,

        action = action,
        time = os.time() + time,
    })

    return #timers
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

local function nineSlicedRect(source, target, targetPlayer, x, y, width, height)
    return {
        tfm.exec.addImage(source[1].img, target, x, y, targetPlayer, 1, 1),
        tfm.exec.addImage(source[2].img, target, x+source[1].w, y, targetPlayer, (width-source[1].w-source[3].w)/source[2].w, 1),
        tfm.exec.addImage(source[3].img, target, x+width-source[3].w, y, targetPlayer, 1, 1),
        tfm.exec.addImage(source[4].img, target, x, y+source[1].h, targetPlayer, 1, (height-source[1].h-source[7].h)/source[4].h),
        tfm.exec.addImage(source[5].img, target, x+source[1].w, y+source[1].h, targetPlayer, (width-source[1].w-source[3].w)/source[2].w, (height-source[1].h-source[7].h)/source[4].h),
        tfm.exec.addImage(source[6].img, target, x+width-source[6].w, y+source[1].h, targetPlayer, 1, (height-source[1].h-source[7].h)/source[4].h),
        tfm.exec.addImage(source[7].img, target, x, y+height-source[7].h, targetPlayer, 1, 1),
        tfm.exec.addImage(source[8].img, target, x+source[7].w, y+height-source[8].h, targetPlayer, (width-source[1].w-source[3].w)/source[2].w, 1),
        tfm.exec.addImage(source[9].img, target, x+width-source[9].w, y+height-source[9].h, targetPlayer, 1, 1),
    }
end

local function removeNineSlicedRect(source)

    if type(source)[1] == "number" then

        for _, v in next, source do

            tfm.exec.removeImage(v)
        end

        return
    end

    for _, window in next, source do

        for _, v in next, window do
            tfm.exec.removeImage(v)
        end
    end
end

-- [object.lua] 
Object = {}
Object.__index = Object

function Object.new(x, y, w, h, imageOptions)

    local object = {
        image,

        x = x,
        y = y,
        w = w,
        h = h
    }

    object.image = tfm.exec.addImage(table.unpack(imageOptions))

    return setmetatable(object, self)
end

function Object:delete()

    tfm.exec.removeImage(self.image)
end

-- [entity.lua] 
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

-- [cutscenes.lua] 
local Cutscene = {}
Cutscene.__index = Cutscene

function Cutscene.new(name)

    local cutscene = {
        name = name,
        dialogs = {},
    }

    setmetatable(cutscene, Cutscene)

    return cutscene
end

function Cutscene:addDialog(textKey)

    table.insert(self.dialogs, textKey)
end

function Cutscene:nextDialog(name)

    data[name].currentDialog = data[name].currentDialog + 1

    if data[name].currentDialog == #self.dialogs then

        removeNineSlicedRect(data[name].cutscene)
        ui.removeTextArea(-1, name)
        ui.removeTextArea(-2, name)
        data[name].canMove = true
        data[name].isInCutscene = false
        return
    end

    ui.updateTextArea(-1, "<p align='left'>" .. texts[data[name].lang][self.dialogs[data[name].currentDialog]] .. "</p>", name)
end

function Cutscene:init(name)

    table.insert(data[name].cutscene, nineSlicedRect(images.window, ":0", name, 200, 300, 400, 90))

    data[name].canMove = false
    data[name].isInCutscene = true
    data[name].currentDialog = 1

    ui.addTextArea(-1, "<p align='left'>" .. texts[data[name].lang][self.dialogs[1]] .. "</p>", name, 210, 310, 380, 45, 0xf, 0xf, 2, true)

    ui.addTextArea(-2, "<font size='24'><a href='event:dialog" .. self.name .. "'>➝</a></font>", name, 560, 350, 50, 50, 0xf, 0xf, 2, true)

    data[name].currentDialog = data[name].currentDialog + 1
end

local Cutscenes = {}

-- [cutscenes/prologue.lua] 
Cutscenes.prologue = Cutscene.new("prologue")

Cutscenes.prologue:addDialog("secret_room_message_1")
Cutscenes.prologue:addDialog("secret_room_message_2")
Cutscenes.prologue:addDialog("secret_room_message_3")
Cutscenes.prologue:addDialog("secret_room_message_4")
Cutscenes.prologue:addDialog("secret_room_message_5")
Cutscenes.prologue:addDialog("secret_room_message_6")

-- [player.lua] 
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

    for key = 37, 40 do
        tfm.exec.bindKeyboard(self.name, key, false, true)
        tfm.exec.bindKeyboard(self.name, key, true, true)
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

function Player:openProfile(targetPlayer)

    removeNineSlicedRect(self.menu.interface)

    ui.removeTextArea(-20, self.name)
    ui.removeTextArea(-21, self.name)

    table.insert(self.menu.interface, nineSlicedRect(images.window, ":0", self.name, 300, 100, 250, 250))
    table.insert(self.menu.interface, nineSlicedRect(images.window, ":0", self.name, 570, 100, 40, 40))

    ui.addTextArea(-20, "<p align='center'><a href='event:closeProfile'><B><R>X</R></B></a</p>", self.name, 572, 110, 40, 40, 0xf, 0xf, 2, true)
    ui.addTextArea(-21, string.format("<p align='center'><font size='22'><B>%s</B></font></a>", self.name), self.name, 310, 110, 230, 230, 0xf, 0xf, 2, true)

end

function Player:closeProfile()
    
    ui.removeTextArea(-20, self.name)
    ui.removeTextArea(-21, self.name)

    removeNineSlicedRect(self.menu.interface)
end

function Player:openMenu()

    self.isMenuOpen = true

    table.insert(self.menu.interface, nineSlicedRect(images.window, ":0", self.name, 700, 100, 80, 250))

    ui.addTextArea(-20, "<p align='center'>Menu</p>", self.name, 700, 110, 80, 50, 0xf, 0xf, 2, true)
    ui.addTextArea(-21, string.format("<p align='center'><a href='event:profile%s'>Profile</a></p>", self.name), self.name, 700, 135, 80, 50, 0xf, 0xf, 2, true)
end

function Player:closeMenu()

    self.isMenuOpen = false

    removeNineSlicedRect(self.menu.interface)

    ui.removeTextArea(-20, self.name)
    ui.removeTextArea(-21, self.name)
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

    elseif key == 38 then

        self:move("up", down)
    elseif key == 37 then
    
        self:move("left", down)
    elseif key == 40 then
    
        self:move("down", down)
    elseif key == 39 then
    
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

-- [events.lua] 
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

