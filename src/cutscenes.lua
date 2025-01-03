local Cutscene = {}
Cutscene.__index = Cutscene

function Cutscene.new(name)

    local cutscene = {
        name = name,
        dialogs = {},
        window
    }

    setmetatable(cutscene, Cutscene)

    return cutscene
end

function Cutscene:addDialog(textKey)

    table.insert(self.dialogs, textKey)
end

function Cutscene:nextDialog(name)

    if self.remainDialogs < 1 then

        removeNineSlicedRect(self.window)
        ui.removeTextArea(-1, name)
        ui.removeTextArea(-2, name)
        return
    end
end

function Cutscene:init(name)

    self.window = nineSlicedRect(images.window, ":0", name, 200, 300, 400, 90)

    ui.addTextArea(-1, "<p align='left'>" .. texts[data[name].lang][self.dialogs[#self.dialogs]] .. "</p>", name, 210, 310, 380, 70, 0xf, 0xf, 2, true)

    ui.addTextArea(-2, "<font size='24'><a href='event:dialog" .. self.name .. "'>➝</a></font>", name, 560, 350, 380, 70, 0xf, 0xf, 2, true)

    self.remainDialogs = #self.dialogs - 1
end

local Cutscenes = {}