PlayerData = {
}

function PlayerData:new (offsetStartNPCstruct, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.offsetStartNPCstruct = offsetStartNPCstruct
    return o
end

function PlayerData:update()
    self.startNPCstruct = MemoryState.base + self.offsetStartNPCstruct + MemoryState.memoryOffset
    local playerMemory = Memory.read_bytes_as_array(self.startNPCstruct, 0x130)

    self.npcDataReference = Memory:getByteRange(playerMemory, 0x8, 0x4)
    self.playerDataReference = Memory:getByteRange(playerMemory, 0xC, 0x4)
    self.spriteId = Memory:getByteRange(playerMemory, 0x30, 0x4)
    self.movement = Memory:getByteRange(playerMemory, 0x48, 0x4) --crashes after 0x10
    self.facingDirection = Memory:getByteRange(playerMemory, 0x4C, 0x4)
    self.lastMovement = Memory:getByteRange(playerMemory, 0x50, 0x4)
    self.lastFacingDirection = Memory:getByteRange(playerMemory, 0x54, 0x4)

    -- last warp coords
    self.xWarp = Memory:getByteRange(playerMemory, 0x6C, 0x4)
    self.zWarp = Memory:getByteRange(playerMemory, 0x70, 0x4)
    self.yWarp = Memory:getByteRange(playerMemory, 0x74, 0x4)

    -- final coords (updated last)
    self.xFinal = Memory:getByteRange(playerMemory, 0x78, 0x4)
    self.yFinal = Memory:getByteRange(playerMemory, 0x7C, 0x4)
    self.zFinal = Memory:getByteRange(playerMemory, 0x80, 0x4)

    -- coords for interacting with terain/collision + position in ram
    self.xPhysical= Memory:getByteRange(playerMemory, 0x84, 0x4)
    self.yPhysical= Memory:getByteRange(playerMemory, 0x88, 0x4)
    self.zPhysical= Memory:getByteRange(playerMemory, 0x8C, 0x4)

    -- coords used for camera position
    -- has subpixel precision
    self.xCamSubpixel = Memory:getByteRange(playerMemory, 0x90, 0x2)
    self.xCam = Memory:getByteRange(playerMemory, 0x92, 0x2)
    self.yCamSxCamSubpixel = Memory:getByteRange(playerMemory, 0x94, 0x2)
    self.yCam = Memory:getByteRange(playerMemory, 0x96, 0x2)
    self.zCamSxCamSubpixel = Memory:getByteRange(playerMemory, 0x98, 0x2)
    self.zCam = Memory:getByteRange(playerMemory, 0x9A, 0x2)

    self.tileId1 = Memory:getByteRange(playerMemory, 0xCC, 0x2)
    self.tileId2 = Memory:getByteRange(playerMemory, 0xCE, 0x2)
    self.spritePtr = Memory:getByteRange(playerMemory, 0x12C, 0x4)
end