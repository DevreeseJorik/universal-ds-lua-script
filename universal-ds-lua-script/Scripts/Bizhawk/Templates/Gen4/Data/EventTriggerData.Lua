TalkTrigger = {
    eventId = 0,
    x = 0,
    y = 0,
    z = 0,
    unknown1 = 0,
    unknown2 = 0
}

function TalkTrigger:new(eventId,x,z,unknown1,unknown2,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.eventId = eventId
    obj.x = x
    obj.z = z
    obj.unknown1 = unknown1
    obj.unknown2 = unknown2
    return obj
end

NPCSpawnTrigger = {
    x = 0,
    y = 0,
    z = 0
}

-- I can't be bothered to figure out the structure right now since I won't be using this
function NPCSpawnTrigger:new(unknown1,unknown2,unknown3,unknown4,unknown5,unknown6,unknown7,unknown8,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.unknown1 = unknown1
    obj.unknown2 = unknown2
    obj.unknown3 = unknown3
    obj.unknown4 = unknown4
    obj.unknown5 = unknown5
    obj.unknown6 = unknown6
    obj.unknown7 = unknown7
    obj.unknown8 = unknown8
    return obj
end

WarpTrigger = {
    x = 0,
    z = 0,
    map = 0,
    targetWarpId = 0,
    unknown = 0
}

function WarpTrigger:new(x,z,map,targetWarpId,unknown1,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.x = x
    obj.z = z
    obj.map = map
    obj.targetWarpId = targetWarpId
    obj.unknown1 = unknown1
    return obj
end

WalkTrigger = {
    unknown1 = 0,
    x = 0,
    z = 0,
    numTriggersHorizontal = 0,
    numTriggersVertical = 0,
    unknown2 = 0,
    flag = 0
}

function WalkTrigger:new(unknown1,x,z,numTriggersHorizontal,numTriggersVertical,unknown2,flag,obj)
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    obj.unknown1 = unknown1
    obj.x = x
    obj.z = z
    obj.numTriggersHorizontal = numTriggersHorizontal
    obj.numTriggersVertical = numTriggersVertical
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
    self.NPCSpawnTriggerSize = 0x20 -- TODO: find size
    self.warpTriggerSize = 0xC
    self.walkTriggerSize = 0x10
    return obj
end

function EventTriggersData:update()
    self:updateTalkTriggers()
    --self:updateNPCSpawnTriggers() -- We will be displaying the current position, not the spawn position
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
    local talkTriggerMemory = Memory.read_bytes_as_array(self.talkTriggersReferences, self.talkTriggerCount * self.talkTriggerSize)
    for i = 0, self.talkTriggerCount - 1 do
        self.talkTriggers[i+1] = TalkTrigger:new(
            Memory:getByteRange(talkTriggerMemory, i * self.talkTriggerSize + 0x0, 0x4), -- runtime id
            Memory:getByteRange(talkTriggerMemory, i * self.talkTriggerSize + 0x4, 0x4), -- x
            Memory:getByteRange(talkTriggerMemory, i * self.talkTriggerSize + 0x8, 0x4), -- z
            Memory:getByteRange(talkTriggerMemory, i * self.talkTriggerSize + 0xC, 0x4), -- unknown1
            Memory:getByteRange(talkTriggerMemory, i * self.talkTriggerSize + 0x10, 0x4) -- unknown2
        )
    end
end

function EventTriggersData:updateNPCSpawnTriggers()
    self.NPCSpawnTriggersReferences = Memory.read_u32_le(MemoryState.base + self.offsetObjectReferences + MemoryState.memoryOffset + 0x34)
    self.NPCSpawnTriggers = {}
    if self.NPCSpawnTriggersReferences == 0 then
        self.NPCSpawnTriggerCount = 0
        return
    end

    self.NPCSpawnTriggerCount = Memory.read_u32_le(self.NPCSpawnTriggersReferences - 0x4)

    local NPCSpawnTriggerMemory = Memory.read_bytes_as_array(self.NPCSpawnTriggersReferences, self.NPCSpawnTriggerCount * self.NPCSpawnTriggerSize)
    for i = 0, self.NPCSpawnTriggerCount - 1 do
        self.NPCSpawnTriggers[i+1] = NPCSpawnTrigger:new(
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0x0, 0x4), -- unknown1
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0x4, 0x4), -- unknown2
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0x8, 0x4), -- unknown3
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0xC, 0x4), -- unknown4
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0x10, 0x4), -- unknown5
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0x14, 0x4), -- unknown6
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0x18, 0x4), -- unknown7
            Memory:getByteRange(NPCSpawnTriggerMemory, i * self.NPCSpawnTriggerSize + 0x1C, 0x4) -- unknown8
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

    local warpTriggerMemory = Memory.read_bytes_as_array(self.warpTriggersReferences, self.warpTriggerCount * self.warpTriggerSize)
    for i = 0, self.warpTriggerCount - 1 do
        self.warpTriggers[i+1] = WarpTrigger:new(
            Memory:getByteRange(warpTriggerMemory, i * self.warpTriggerSize + 0x0, 0x2), -- x
            Memory:getByteRange(warpTriggerMemory, i * self.warpTriggerSize + 0x2, 0x2), -- z
            Memory:getByteRange(warpTriggerMemory, i * self.warpTriggerSize + 0x4, 0x2), -- map
            Memory:getByteRange(warpTriggerMemory, i * self.warpTriggerSize + 0x6, 0x2), --  target warp id
            Memory:getByteRange(warpTriggerMemory, i * self.warpTriggerSize + 0x8, 0x4) -- unknown1
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

    local walkTriggerMemory = Memory.read_bytes_as_array(self.walkTriggersReferences, self.walkTriggerCount * self.walkTriggerSize)
    for i = 0, self.walkTriggerCount - 1 do
        self.walkTriggers[i+1] = WalkTrigger:new(
            Memory:getByteRange(walkTriggerMemory, i * self.walkTriggerSize + 0x0, 0x2), -- unknown1
            Memory:getByteRange(walkTriggerMemory, i * self.walkTriggerSize + 0x2, 0x2), -- x
            Memory:getByteRange(walkTriggerMemory, i * self.walkTriggerSize + 0x4, 0x2), -- z
            Memory:getByteRange(walkTriggerMemory, i * self.walkTriggerSize + 0x6, 0x2), -- numTriggersHorizontal
            Memory:getByteRange(walkTriggerMemory, i * self.walkTriggerSize + 0x8, 0x2), -- numTriggersVertical
            Memory:getByteRange(walkTriggerMemory, i * self.walkTriggerSize + 0xA, 0x2), -- unknown2
            Memory:getByteRange(walkTriggerMemory, i * self.walkTriggerSize + 0xC, 0x4) -- flag id
        )
    end
end