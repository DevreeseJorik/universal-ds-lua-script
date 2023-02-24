TalkTrigger = {
    runtime_id = 0,
    x = 0,
    y = 0,
    z = 0,
    unknown = 0
}

function TalkTrigger:new(runtime_id,x,y,z,unknown,o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.runtime_id = runtime_id
    self.x = x
    self.y = y
    self.z = z
    self.unknown = unknown
    return o
end

UnknownTrigger = {
    x = 0,
    y = 0,
    z = 0
}

function UnknownTrigger:new(x,y,z,o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.x = x
    self.y = y
    self.z = z
    return o
end

WarpTrigger = {
    x = 0,
    z = 0,
    map = 0,
    targetWarpId = 0,
    unknown = 0
}

function WarpTrigger:new(x,z,map,targetWarpId,unknown,o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.x = x
    self.z = z
    self.map = map
    self.targetWarpId = targetWarpId
    self.unknown = unknown
    return o
end

WalkTrigger = {
    unknown1 = 0,
    x = 0,
    z = 0,
    numTriggersVertical = 0,
    numTriggersHorizontal = 0,
    unknown2 = 0,
    flag = 0
}

function WalkTrigger:new(unknown1,x,z,numTriggersVertical,numTriggersHorizontal,unknown2,flag,o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.unknown1 = unknown1
    self.x = x
    self.z = z
    self.numTriggersVertical = numTriggersVertical
    self.numTriggersHorizontal = numTriggersHorizontal
    self.unknown2 = unknown2
    self.flag = flag
    return o
end

EventTriggers = {

}

function EventTriggers:new(offsetObjectReferences,o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.offsetObjectReferences = offsetObjectReferences
    self.talkTriggerSize = 0x14
    self.unknownTriggerSize = 0x20 -- TODO: find size
    self.warpTriggerSize = 0xC
    self.walkTriggerSize = 0x10
    return o
end

function EventTriggers:update()
    self.talkTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x30)
    self.talkTriggerCount = Memory.read_u32_le(self.talkTriggersReferences - 0x4)
    self.talkTriggers = {}

    -- Copy the entire memory section for the talk triggers into a byte array for faster access
    self.talkTriggerMemory = Memory:readByteArray(self.talkTriggersReferences, self.talkTriggerCount * self.talkTriggerSize)
    for i = 0, self.talkTriggerCount - 1 do
        local talkTriggerData = Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize, self.talkTriggerSize)
        self.talkTriggers[i] = TalkTrigger:new(
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x0, 0x4), -- runtime id
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x4, 0x4), -- x
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x8, 0x4), -- y
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0xC, 0x4), -- z
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x10, 0x4) -- unknown
        )
    end
    
    self.unknownTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x34)
    self.unknownTriggerCount = Memory.read_u32_le(self.unknownTriggersReferences - 0x4)
    self.unknownTriggers = {}

    self.unknownTriggerMemory = Memory:readByteArray(self.unknownTriggersReferences, self.unknownTriggerCount * self.unknownTriggerSize)
    for i = 0, self.unknownTriggerCount - 1 do
        local unknownTriggerData = Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize, self.unknownTriggerSize)
        self.unknownTriggers[i] = UnknownTrigger:new(
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x0, 0x4), -- unknown1
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x4, 0x4), -- unknown2
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x8, 0x4), -- unknown3
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0xC, 0x4), -- unknown4
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x10, 0x4), -- unknown5
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x14, 0x4), -- unknown6
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x18, 0x4), -- unknown7
            Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x1C, 0x4) -- unknown8
        )
    end
    
    self.warpTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x38)
    self.warpTriggerCount = Memory.read_u32_le(self.warpTriggersReferences - 0x4)
    self.warpTriggers = {}

    self.warpTriggerMemory = Memory:readByteArray(self.warpTriggersReferences, self.warpTriggerCount * self.warpTriggerSize)
    for i = 0, self.warpTriggerCount - 1 do
        local warpTriggerData = Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize, self.warpTriggerSize)
        self.warpTriggers[i] = WarpTrigger:new(
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x0, 0x2), -- x
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x2, 0x4), -- z
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x4, 0x2) -- map
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x6, 0x2) --  target warp id
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x8, 0x4) -- unknown1
        )
    end
    
    self.walkTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x3C)
    self.walkTriggerCount = Memory.read_u32_le(self.walkTriggersReferences - 0x4)
    self.walkTriggers = {}

    self.walkTriggerMemory = Memory:readByteArray(self.walkTriggersReferences, self.walkTriggerCount * self.walkTriggerSize)
    for i = 0, self.walkTriggerCount - 1 do
        local walkTriggerData = Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize, self.walkTriggerSize)
        self.walkTriggers[i] = WalkTrigger:new(
            Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize + 0x0, 0x2), -- unknown1
            Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize + 0x2, 0x2), -- x
            Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize + 0x4, 0x2), -- z
            Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize + 0x6, 0x2), -- numTriggersVertical
            Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize + 0x8, 0x2), -- numTriggersHorizontal
            Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize + 0xA, 0x2), -- unknown2
            Memory:getByteRange(self.walkTriggerMemory, i * self.walkTriggerSize + 0xC, 0x4) -- flag id
        )
    end
end

