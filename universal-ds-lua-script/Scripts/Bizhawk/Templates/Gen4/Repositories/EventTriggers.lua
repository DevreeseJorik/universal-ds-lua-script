EventTriggers = {
    talkTriggersColors = {
        background = 0x80FF00FF,
        border= 0xFFFF00FF
    },
    warpTriggersColors = {
        background = 0x80FF0000,
        border= 0xFFFF0000
    },
    walkTriggersColors = {
        background = 0x80FFFF00,
        border= 0xFFFFFF00
    },
}

function EventTriggers:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function EventTriggers:display()
    local xCam = PlayerData.xCam
    local yCam = PlayerData.yCam
    local zCam = PlayerData.zCam
    BoundingBoxes:displayObjects(EventTriggersData.talkTriggers,xCam,yCam,zCam,self.talkTriggersColors)
    BoundingBoxes:displayObjects(EventTriggersData.warpTriggers,xCam,yCam,zCam,self.warpTriggersColors)
    self:displayWalkTriggers(EventTriggersData.walkTriggers,xCam,yCam,zCam,self.walkTriggersColors)
end

function EventTriggers:displayWalkTriggers(table,x,y,z,colors)
    local trigger, xTrigger, yTrigger, zTrigger
    local w = 16
    local h = 14
    local foreshortenX = math.cos(math.rad(0))
    local foreshortenY = math.sin(math.rad(60))
    local centerX = Display.left + Display.width/2 - w/2 * foreshortenX
    local centerY = Display.height/2 - h/2 * foreshortenY

    for i=1, #table do
        trigger = table[i]
        xTrigger = trigger.x
        zTrigger = trigger.z
        numTriggersHorizontal = trigger.numTriggersHorizontal
        numTriggersVertical = trigger.numTriggersVertical
        for j=0, numTriggersHorizontal-1 do
            for k=0, numTriggersVertical-1 do
                BoundingBoxes:displayObject(
                    centerX + (xTrigger + j - x)*w*foreshortenX, 
                    centerY + (zTrigger + k - z)*h*foreshortenY, 
                    w*foreshortenX,
                    h*foreshortenY, 
                    colors
                )
            end
        end
    end
end