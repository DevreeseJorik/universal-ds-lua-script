BoundingBoxes =  {
    BoundingBoxColors = {
        background = 0x80B0B0FF,
        border = 0xB0B0B0FF,
    }
}

function BoundingBoxes:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function BoundingBoxes:displayPlayer()
    local centerX = Display.left + Display.width/2
    local centerY = Display.height/2
    local w = 16
    local h = 14
    gui.drawRectangle(
        centerX - w/2,
        centerY - h/2,
        w,
        h, 
        self.BoundingBoxColors.border,
        self.BoundingBoxColors.background
    )
end

function BoundingBoxes:display()
    NPCs:display()
    EventTriggers:display()
    self:displayPlayer()
end

function BoundingBoxes:displayObjects(table,x,y,z,colors)
    local object
    local w = 16
    local h = 14
    local foreshortenX = math.cos(math.rad(0))
    local foreshortenY = math.sin(math.rad(60))
    local centerX = Display.left + Display.width/2 - w/2 * foreshortenX
    local centerY = Display.height/2 - h/2 * foreshortenY

    for i=1, #table do
        object = table[i]
        xObj = object.x
        zObj = object.z

        self:displayObject(
            centerX + (xObj - x)*w*foreshortenX, 
            centerY + (zObj - z)*h*foreshortenY, 
            w*foreshortenX,
            h*foreshortenY, 
            colors
        )
    end
end

function BoundingBoxes:displayObject(x,y,w,h,colors)
    -- local left = Display.left
    -- local right = left + Display.width
    -- local top = Display.top
    -- local bottom = Display.height
    -- if (x + w) < left or x > right or (y + h) < top or y > bottom then
    --     return
    -- end
    -- x = math.max(x, left)
    -- y = math.max(y, top)
    -- w = math.min(w, right - x)
    -- h = math.min(h, bottom - y)
    gui.drawRectangle(x, y, w, h, colors.border, colors.background)
end