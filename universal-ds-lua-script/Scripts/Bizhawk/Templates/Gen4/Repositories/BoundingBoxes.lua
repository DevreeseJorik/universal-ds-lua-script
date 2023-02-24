BoundingBoxes =  {

}

function BoundingBoxes:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function BoundingBoxes:display()
    local centerX = Display.left + Display.width/2
    local centerY = Display.height/2
    local w = 16
    local h = 14
    gui.drawRectangle(
        centerX - w/2,
        centerY - h/2,
        w,
        h, 
        0xFF0000FF,
        0xFF0000FF
    )
end