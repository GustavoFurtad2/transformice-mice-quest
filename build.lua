function build(files)

    local initTime = os.clock()

    local sucess = pcall(function()

        local content = ""
        local build = io.open("builds/build.lua", "w")

        for _, name in next, files do

            local file = io.open("src/" .. name)
            content = content .. "-- [" .. name .. "] \n" .. file:read("*a") .. "\n\n"
            file:close()

        end

        build:write(content)
    end)

    print("Compiled in " .. os.clock() - initTime .. " ms")
    print(sucess and "Compiled with sucess!" or "Compilation failed!")
end

local files = {
    "init.lua", 
    "images.lua", 
    "texts.lua", 
    "utils.lua", 
    "object.lua",
    "entity.lua",
    "cutscenes.lua", 
    "cutscenes/prologue.lua",
    "player.lua", 
    "events.lua"
}

build(files)

return