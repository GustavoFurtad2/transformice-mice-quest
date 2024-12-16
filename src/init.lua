for _, s in next, {"AutoNewGame", "AutoShaman", "AfkDeath", "MortCommand", "PhysicalConsumables"} do
    tfm.exec["disable" .. s]()
end

tfm.exec.newGame [[<C><P /><Z><S><S L="800" H="48" X="401" Y="376" T="0" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DS Y="337" X="400" /></D><O /></Z></C>]]

ui.setMapName("#micequest")

local data = {}