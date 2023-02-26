Movement = {
    teleportAmount = 65536

}

function Movement:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Movement:display()
    -- player native position
    gui.text((Display.rightScreen + 200)*2, 10, "xPhysical: " .. PlayerData.xPhysical)
    gui.text((Display.rightScreen + 200)*2, 30, "xCam: " .. PlayerData.xCam)
    gui.text((Display.rightScreen + 200)*2, 50, "zPhysical: " .. PlayerData.zPhysical)
    gui.text((Display.rightScreen + 200)*2, 70, "zCam: " .. PlayerData.zCam)
    
    -- chunk native position
    gui.text((Display.rightScreen + 200)*2, 90, "chunkX: " .. ChunkData.chunkOffsetX)
    gui.text((Display.rightScreen + 200)*2, 110, "chunkZ: " .. ChunkData.chunkOffsetZ)
    gui.text((Display.rightScreen + 200)*2, 130, "total: " .. ChunkData.totalChunkOffset)

    -- gui.text((Display.rightScreen + 200)*2, 150, "chunkData: 0x" .. Utility:format(ChunkData.startChunkData, 7))
    -- gui.text((Display.rightScreen + 200)*2, 170, "chunkDiff: 0x" .. Utility:format(ChunkData.chunkDifference, 7))
end

function Movement:teleportXZ(xDiff,zDiff) -- not changing player height
    local startNPCstruct = PlayerData.startNPCstruct
    Memory:write_s32_le(startNPCstruct + 0x84, PlayerData.xPhysical + xDiff)
    Memory:write_s16_le(startNPCstruct + 0x92, PlayerData.xCam + xDiff)

    Memory:write_s32_le(startNPCstruct + 0x8C, PlayerData.zPhysical + zDiff)
    Memory:write_s16_le(startNPCstruct + 0x9A, PlayerData.zCam + zDiff)
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