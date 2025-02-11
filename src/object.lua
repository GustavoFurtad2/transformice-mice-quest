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