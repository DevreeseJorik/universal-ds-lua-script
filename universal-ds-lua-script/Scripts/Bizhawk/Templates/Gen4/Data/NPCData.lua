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
        self.NPCs[i+1] = NPC:new()
        self.NPCs[i+1].spriteId = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x10, 0x2)
        self.NPCs[i+1].ObjCode = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x12, 0x2)
        self.NPCs[i+1].moveCode = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x14, 0x2)
        self.NPCs[i+1].eventType = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x16, 0x2)
        self.NPCs[i+1].eventFlag = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x18, 0x2)

        self.NPCs[i+1].eventId = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x20, 0x2)
        self.NPCs[i+1].movement = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x24, 0x4)
        self.NPCs[i+1].facingDirection = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x28, 0x4)
        self.NPCs[i+1].lastMovement = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x2C, 0x4)
        self.NPCs[i+1].lastFacingDirection = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x30, 0x4)

        self.NPCs[i+1].xSpawn = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x4C, 0x4)
        self.NPCs[i+1].ySpawn = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x50, 0x4)
        self.NPCs[i+1].zSpawn = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x54, 0x4)

        self.NPCs[i+1].xFinal = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x58, 0x4)
        self.NPCs[i+1].yFinal = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x5C, 0x4)
        self.NPCs[i+1].zFinal = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x60, 0x4)

        self.NPCs[i+1].xPhysical = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x64, 0x4)
        self.NPCs[i+1].yPhysical = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x68, 0x4)
        self.NPCs[i+1].zPhysical = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x6C, 0x4)

        self.NPCs[i+1].xCamSubpixel = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x70, 0x2)
        self.NPCs[i+1].xCam = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x72, 0x2)
        self.NPCs[i+1].yCamSubpixel = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x74, 0x2)
        self.NPCs[i+1].yCam = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x76, 0x2)
        self.NPCs[i+1].zCamSubpixel = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x78, 0x2)
        self.NPCs[i+1].zCam = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0x7A, 0x2)

        self.NPCs[i+1].x = self.NPCs[i+1].xCam
        self.NPCs[i+1].y = self.NPCs[i+1].yCam
        self.NPCs[i+1].z = self.NPCs[i+1].zCam

        self.NPCs[i+1].tileId1 = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0xCC, 0x2)
        self.NPCs[i+1].tileId2 = Memory:getByteRange(NPCMemory, i * self.NPCSize + 0xCE, 0x2)
    end

end

