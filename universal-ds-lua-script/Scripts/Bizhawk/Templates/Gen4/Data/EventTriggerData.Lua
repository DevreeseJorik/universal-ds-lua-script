TalkTrigger = {
    runtime_id = 0,
    x = 0,
    y = 0,
    z = 0,
    unknown1 = 0,
    unknown2 = 0
}

function TalkTrigger:new(runtime_id,x,z,unknown1,unknown2,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.runtime_id = runtime_id
    obj.x = x
    obj.z = z
    obj.unknown1 = unknown1
    obj.unknown2 = unknown2
    return obj
end

UnknownTrigger = {
    x = 0,
    y = 0,
    z = 0
}

function UnknownTrigger:new(x,y,z,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.x = x
    obj.y = y
    obj.z = z
    return obj
end

WarpTrigger = {
    x = 0,
    z = 0,
    map = 0,
    targetWarpId = 0,
    unknown = 0
}

function WarpTrigger:new(x,z,map,targetWarpId,unknown,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.x = x
    obj.z = z
    obj.map = map
    obj.targetWarpId = targetWarpId
    obj.unknown = unknown
    return obj
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

function WalkTrigger:new(unknown1,x,z,numTriggersVertical,numTriggersHorizontal,unknown2,flag,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.unknown1 = unknown1
    obj.x = x
    obj.z = z
    obj.numTriggersVertical = numTriggersVertical
    obj.numTriggersHorizontal = numTriggersHorizontal
    obj.unknown2 = unknown2
    obj.flag = flag
    return obj
end

EventTriggersData = {

}

function EventTriggersData:new(offsetObjectReferences,obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.offsetObjectReferences = offsetObjectReferences
    self.talkTriggerSize = 0x14
    self.unknownTriggerSize = 0x20 -- TODO: find size
    self.warpTriggerSize = 0xC
    self.walkTriggerSize = 0x10
    return obj
end

function EventTriggersData:update()
    self:updateTalkTriggers()
    self:updateUnknownTriggers()
    self:updateWarpTriggers()
    self:updateWalkTriggers()
end

function EventTriggersData:updateTalkTriggers()
    self.talkTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x30)
    self.talkTriggers = {}
    if self.talkTriggersReferences == 0 then
        self.talkTriggerCount = 0
        return
    end

    self.talkTriggerCount = Memory.read_u32_le(self.talkTriggersReferences - 0x4)

    -- Copy the entire memory section for the talk triggers into a byte array for faster access
    self.talkTriggerMemory = Memory.read_bytes_as_array(self.talkTriggersReferences, self.talkTriggerCount * self.talkTriggerSize)
    for i = 0, self.talkTriggerCount - 1 do
        self.talkTriggers[i+1] = TalkTrigger:new(
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x0, 0x4), -- runtime id
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x4, 0x4), -- x
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x8, 0x4), -- z
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0xC, 0x4), -- unknown1
            Memory:getByteRange(self.talkTriggerMemory, i * self.talkTriggerSize + 0x10, 0x4) -- unknown2
        )
    end
end

function EventTriggersData:updateUnknownTriggers()
    self.unknownTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x34)
    self.unknownTriggers = {}
    if self.unknownTriggersReferences == 0 then
        self.unknownTriggerCount = 0
        return
    end

    self.unknownTriggerCount = Memory.read_u32_le(self.unknownTriggersReferences - 0x4)

    self.unknownTriggerMemory = Memory.read_bytes_as_array(self.unknownTriggersReferences, self.unknownTriggerCount * self.unknownTriggerSize)
    for i = 0, self.unknownTriggerCount - 1 do
        self.unknownTriggers[i+1] = UnknownTrigger:new(
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x0, 0x4), -- unknown1
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x4, 0x4), -- unknown2
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x8, 0x4), -- unknown3
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0xC, 0x4), -- unknown4
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x10, 0x4), -- unknown5
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x14, 0x4), -- unknown6
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x18, 0x4), -- unknown7
            -- Memory:getByteRange(self.unknownTriggerMemory, i * self.unknownTriggerSize + 0x1C, 0x4) -- unknown8
        )
    end
end

function EventTriggersData:updateWarpTriggers()
    self.warpTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x38)
    self.warpTriggers = {}
    if self.warpTriggersReferences == 0 then
        self.warpTriggerCount = 0
        return
    end

    self.warpTriggerCount = Memory.read_u32_le(self.warpTriggersReferences - 0x4)

    self.warpTriggerMemory = Memory.read_bytes_as_array(self.warpTriggersReferences, self.warpTriggerCount * self.warpTriggerSize)
    for i = 0, self.warpTriggerCount - 1 do
        self.warpTriggers[i+1] = WarpTrigger:new(
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x0, 0x2), -- x
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x2, 0x4), -- z
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x4, 0x2), -- map
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x6, 0x2), --  target warp id
            Memory:getByteRange(self.warpTriggerMemory, i * self.warpTriggerSize + 0x8, 0x4) -- unknown1
        )
    end
end

function EventTriggersData:updateWalkTriggers()
    self.walkTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x3C)
    self.walkTriggers = {}
    if self.walkTriggersReferences == 0 then
        self.walkTriggerCount = 0
        return
    end

    self.walkTriggerCount = Memory.read_u32_le(self.walkTriggersReferences - 0x4)

    self.walkTriggerMemory = Memory.read_bytes_as_array(self.walkTriggersReferences, self.walkTriggerCount * self.walkTriggerSize)
    for i = 0, self.walkTriggerCount - 1 do
        self.walkTriggers[i+1] = WalkTrigger:new(
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