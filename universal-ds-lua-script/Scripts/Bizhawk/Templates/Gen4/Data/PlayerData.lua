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

    self.NPCstruct = {
        npcDataReference = Memory.read_u32_le(self.startNPCstruct + 0x8),
        playerDataReference = Memory.read_u32_le(self.startNPCstruct + 0xC),
        spriteId = Memory.read_u32_le(self.startNPCstruct + 0x30),
        movement = Memory.read_u32_le(self.startNPCstruct + 0x48), --crashes after 0x10
        facingDirection = Memory.read_u32_le(self.startNPCstruct + 0x4C),
        lastMovement = Memory.read_u32_le(self.startNPCstruct + 0x50),
        lastFacingDirection = Memory.read_u32_le(self.startNPCstruct + 0x54),
    
        -- last warp coords
        xWarp = Memory.read_u32_le(self.startNPCstruct + 0x6C),
        zWarp = Memory.read_u32_le(self.startNPCstruct + 0x70),
        yWarp = Memory.read_u32_le(self.startNPCstruct + 0x74),
    
        -- final coords (updated last)
        xFinal = Memory.read_u32_le(self.startNPCstruct + 0x78),
        yFinal = Memory.read_u32_le(self.startNPCstruct + 0x7C),
        zFinal = Memory.read_u32_le(self.startNPCstruct + 0x80),
    
        -- coords for interacting with terain/collision + position in ram
        xPhysical= Memory.read_s32_le(self.startNPCstruct + 0x84),
        yPhysical= Memory.read_s32_le(self.startNPCstruct + 0x88),
        zPhysical= Memory.read_s32_le(self.startNPCstruct + 0x8C),
    
        -- coords used for camera position
        -- has subpixel precision
        xCamSubpixel = Memory.read_s16_le(self.startNPCstruct + 0x90),
        xCam = Memory.read_s16_le(self.startNPCstruct + 0x92),
        yCamSxCamSubpixel = Memory.read_s16_le(self.startNPCstruct + 0x94),
        yCam = Memory.read_s16_le(self.startNPCstruct + 0x96),
        zCamSxCamSubpixel = Memory.read_s16_le(self.startNPCstruct + 0x98),
        zCam = Memory.read_s16_le(self.startNPCstruct + 0x9A),
    
        tileId1 = Memory.read_u16_le(self.startNPCstruct + 0xCC),
        tileId2 = Memory.read_u16_le(self.startNPCstruct + 0xCE),
        spritePtr = Memory.read_u32_le(self.startNPCstruct + 0x12C)
    }
end