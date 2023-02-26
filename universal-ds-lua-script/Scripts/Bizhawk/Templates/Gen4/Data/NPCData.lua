NPC = {
    spriteId = 0,
    ObjCode = 0,
    moveCode = 0,
    eventType = 0,
    eventFlag = 0,
    eventId = 0,
    movement = 0,
    facingDirection = 0,
    lastMovement = 0,
    lastFacingDirection = 0,

    xSpawn = 0,
    ySpawn = 0,
    zSpawn = 0,

    xFinal = 0,
    yFinal = 0,
    zFinal = 0,

    xPhysical = 0,
    yPhysical = 0,
    zPhysical = 0,

    xCam = 0,
    xCamSubpixel = 0,
    yCam = 0,
    yCamSubpixel = 0,
    zCam = 0,
    zCamSubpixel = 0,

    tileId1 = 0,
    tileId2 = 0,
}

function NPC:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    return obj
end

NPCData = {
}

function NPCData:new(offsetObjectData,offsetNPCData,NPCSize,o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.offsetObjectData = offsetObjectData
    self.offsetNPCData = offsetNPCData
    self.NPCSize = NPCSize or 0x128
    return o
end

function NPCData:update()
    self.NPCs = {}
    self.objectData = MemoryState.base + self.offsetObjectData + MemoryState.memoryOffset
    self.maxNPCCount = Memory.read_u32_le(self.objectData + 0x70)
    self.NPCCount = Memory.read_u32_le(self.objectData + 0x74) -1 -- -1 because the first NPC is the player

    self.NPCAddress = MemoryState.base + self.offsetNPCData + MemoryState.memoryOffset
    self.NPCs = {}

    if (self.NPCCount < 0) or (self.maxNPCCount ~= 64) or (self.NPCCount > self.maxNPCCount) then 
        return 
    end

    local NPCMemory = Memory.read_bytes_as_array(self.NPCAddress, self.NPCSize * self.NPCCount)

    for i = 0, self.NPCCount - 1 do
        self.NPCs[i] = NPC:new()
        self.NPCs[i].spriteId = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x10, 0x2)
        self.NPCs[i].ObjCode = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x12, 0x2)
        self.NPCs[i].moveCode = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x14, 0x2)
        self.NPCs[i].eventType = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x16, 0x2)
        self.NPCs[i].eventFlag = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x18, 0x2)

        self.NPCs[i].eventId = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x20, 0x2)
        self.NPCs[i].movement = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x24, 0x4)
        self.NPCs[i].facingDirection = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x28, 0x4)
        self.NPCs[i].lastMovement = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x2C, 0x4)
        self.NPCs[i].lastFacingDirection = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x30, 0x4)

        self.NPCs[i].xSpawn = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x4C, 0x4)
        self.NPCs[i].ySpawn = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x50, 0x4)
        self.NPCs[i].zSpawn = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x54, 0x4)

        self.NPCs[i].xFinal = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x58, 0x4)
        self.NPCs[i].yFinal = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x5C, 0x4)
        self.NPCs[i].zFinal = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x60, 0x4)

        self.NPCs[i].xPhysical = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x64, 0x4)
        self.NPCs[i].yPhysical = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x68, 0x4)
        self.NPCs[i].zPhysical = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x6C, 0x4)

        self.NPCs[i].xCamSubpixel = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x70, 0x2)
        self.NPCs[i].xCam = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x72, 0x2)
        self.NPCs[i].yCamSubpixel = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x74, 0x2)
        self.NPCs[i].yCam = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x76, 0x2)
        self.NPCs[i].zCamSubpixel = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x78, 0x2)
        self.NPCs[i].zCam = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x7A, 0x2)

        self.NPCs[i].x = self.NPCs[i].xCam
        self.NPCs[i].y = self.NPCs[i].yCam
        self.NPCs[i].z = self.NPCs[i].zCam

        self.NPCs[i].tileId1 = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0xCC, 0x2)
        self.NPCs[i].tileId2 = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0xCE, 0x2)
    end

end

