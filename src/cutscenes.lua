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