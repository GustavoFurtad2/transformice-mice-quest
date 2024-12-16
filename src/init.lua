for _, s in next, {"AutoNewGame", "AutoShaman", "AfkDeath", "MortCommand", "PhysicalConsumables"} do
    tfm.exec["disable" .. s]()
end

tfm.exec.newGame [[<C><P G="0,0" Ca="" MEDATA=";;;;-0;0:::1-"/><Z><S/><D><DS X="400" Y="200"/></D><O/><L/></Z></C>]]

ui.setMapName("#micequest")

local data = {}

local images = {

    mouse = {

        w = 22,
        h = 26,

        up = "18d5c83d73b.png",
        down = "18d5c833aa1.png",
        right = "18d5c83891b.png",
    }
}