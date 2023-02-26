Movement = {
    teleportAmount = 32

}

function Movement:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Movement:display()
    local NPCstruct = PlayerData.NPCstruct
    gui.text((Display.rightScreen + 200)*2, 10, "xPhysical: " .. NPCstruct.xPhysical)
    gui.text((Display.rightScreen + 200)*2, 30, "xCam: " .. NPCstruct.xCam)
    gui.text((Display.rightScreen + 200)*2, 50, "zPhysical: " .. NPCstruct.zPhysical)
    gui.text((Display.rightScreen + 200)*2, 70, "zCam: " .. NPCstruct.zCam)
end

function Movement:teleportXZ(xDiff,zDiff) -- not changing player height
    local NPCstruct = PlayerData.NPCstruct
    local startNPCstruct = PlayerData.startNPCstruct
    Memory:write_s32_le(startNPCstruct + 0x84, NPCstruct.xPhysical + xDiff)
    Memory:write_s16_le(startNPCstruct + 0x92, NPCstruct.xCam + xDiff)

    Memory:write_s32_le(startNPCstruct + 0x8C, NPCstruct.zPhysical + zDiff)
    Memory:write_s16_le(startNPCstruct + 0x9A, NPCstruct.zCam + zDiff)
end

function Movement:teleportLeft()
    self:teleportXZ(-self.teleportAmount, 0)
end

function Movement:teleportRight()
    self:teleportXZ(self.teleportAmount, 0)
end

function Movement:teleportUp()
    self:teleportXZ(0, -self.teleportAmount)
end

function Movement:teleportDown()
    self:teleportXZ(0, self.teleportAmount)
end

function Movement:teleportUp()
    self:teleportXZ(0, -self.teleportAmount)
end