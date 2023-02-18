Movement = {
    teleportAmount = 32

}

function Movement:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Movement:teleportXZ(xDiff,zDiff) -- not changing player height
    local NPCstruct = PlayerData.NPCstruct
    local startNPCstruct = PlayerData.startNPCstruct
    Memory:write_s32_le(startNPCstruct + 0x84, NPCstruct.x_phys_32 + xDiff)
    Memory:write_s16_le(startNPCstruct + 0x92, NPCstruct.x_cam_16 + xDiff)

    Memory:write_s32_le(startNPCstruct + 0x8C, NPCstruct.z_phys_32 + zDiff)
    Memory:write_s16_le(startNPCstruct + 0x9A, NPCstruct.z_cam_16 + zDiff)
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