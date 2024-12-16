function build(files)

    local content = ""
    local build = io.open("builds/build.lua", "w")

    for k, v in next, files do

        local file = io.open("src/" .. v .. ".lua")
        content = content .. file:read("*a") .. "\n\n"
        file:close()

    end

    build:write(content)
end

local files = {"init", "utils", "player", "events"}

build(files)

return