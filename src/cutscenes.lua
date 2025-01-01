local Cutscene = {}
Cutscene.__index = Cutscene

function Cutscene.new()

    return setmetatable({dialogs = {}, window}, Cutscene)
end

function Cutscene:addDialog(textKey)

    table.insert(self.dialogs, textKey)
end

function Cutscene:play(name)

    self.window = nineSlicedRect(images.window, ":0", name, 200, 300, 400, 90)

    ui.addTextArea(-1, "<p align='left'>" .. texts[data[name].lang][self.dialogs[#self.dialogs]] .. "</p>", name, 210, 310, 380, 70, 0xf, 0xf, 2, true)
end

local Cutscenes = {}