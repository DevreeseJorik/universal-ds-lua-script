NPCs = {
    npcsColors = {
        background = 0x800000FF,
        border = 0xFF0000FF
    }
}

function NPCs:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function NPCs:display()
    local xCam = PlayerData.xCam
    local yCam = PlayerData.yCam
    local zCam = PlayerData.zCam
    BoundingBoxes:displayObjects(NPCData.NPCs,xCam,yCam,zCam,self.npcsColors)
end
