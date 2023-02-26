ChunkData = {
    colorMapping = {
        trees = {
            color = 0xFF737B30, -- 545D20
            ids = {}
        },
        grass = {
            color = 0xFF2AA615,
            ids = {0x2,0x7B}
        },
        tallGrass = {
            color = 0xFF2F654A,
            ids = {0x3}	
        },
        default = {
            color = 0xFF000000,
            ids = {0xFF,0x0}
        },
        warps = {
            color = 0xFFFF0000,
            ids ={0x5E,0x5f,0x62,0x63,0x69,0x65,0x6f,0x6D,0x6A,0x6C,0x6E}
        },
        cave = {
            color = 0xFFBB7410,
            ids = {0x6,0x8,0xC}
        },
        water = {
            color = 0xFF4888F0,
            ids = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x19,0x22,0x2A,0x7C}
        },
        sand = {
            color = 0xFFE3B820,
            ids = {0x21,0x21}
        },
        deepSnow1 = {
            color = 0xFF8DA9CB,
            ids = {0xA1}
        },
        deepSnow2 = {
            color = 0xFF6483A7,
            ids = {0xA2}
        },
        deepSnow3 = {
            color = 0xFF52749D,
            ids = {0xA3}
        },
        mud = {
            color = 0xFF928970,
            ids = {0xA4}
        },
        mudBlock = {
            color = 0xFF927040,
            ids = {0xA5}
        },
        mudGrass = {
            color = 0xFF409000,
            ids = {0xA6}
        },
        mudGrassBlock = {
            color = 0xFF559060,
            ids = {0xA7}
        },
        snow = {
            color = 0xFFB9D0EB,
            ids = {0xA8}
        },
        misc = {
            color = 0xFFFFFFFF,
            ids = {0xE5,0X8E,0X8f}
        },
        spinTile = {
            color = 0xFFFFD000,
            ids = {0x40,0x41,0x42,0x43}
        },
        ice = {
            color = 0xFF56B3E0,
            ids = {0x20,0x20}
        },
        iceStair = {
            color = 0xFFFFD000,
            ids = {0x49,0x4A}
        },
        circleWarp = {
            color = 0xFFA0A000,
            ids = {0x67}
        },
        modelFl = {
            color = 0xFFAFB000,
           ids = {0x56,0x57,0x58} 
        },
        modelFloor = {
            color = 0xFFA090F0,
           ids = {0x59}
        },
        specialCollision = {
            color = 0xFFA090F0,
           ids = {0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37}
        },
        bikeStall = {
            color = 0xFF0690A0,
           ids = {0xDB}
        },
        counter = {
            color = 0xFFf7A00,
            ids = {0x80}
        },
        pc = {
           color = 0xFF0690B0,
           ids = {0x83}
        },
        map = {
           color = 0xFF00EEE0,
           ids = {0x85}
        },
        tv = {
           color = 0xFF4290E0,
           ids = {0x86}
        },
        bookcases = {
            color = 0xFF0DDD70,
            ids = {0x88,0xE1,0xE0,0xE2}
        },
        bin = {
            color = 0xFF06B040,
           ids = {0xE4}
        },
        hauntedHouse = {
            color = 0xFFA292BC,
            ids = {0xB}
        },
        ledge = {
            color = 0xFFD3A000,
            ids = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
        },
        rockClimb = {
            color = 0xFFC76000,
            ids = {0x4B,0x4C}
        },
        bridge = {
            color = 0xFFC79000,
            ids = {0x71,0x72,0x73,0x74,0x75}
        },
        startBridge = {
            color= 0xC7B000, 
            ids = {0x70}
        },
        bikeBridge = {
            color = 0xFFC7A55,
            ids = {0x76,0x77,0x78,0x79,0x7A,0x7D}
        },
        soil = {
            color = 0xFFB27030,
            ids = {0xA0}
        },
        bikeRamp = {
            color = 0xFFB89000,
            ids = {0xD7,0xD8}
        },
        quickSand = {
            color = 0xFFA88000,
            ids = {0xD9,0xDA}
        },
    },

    colorMappingLUT = {}
}

function ChunkData:new(offsetStartChunkData, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.offsetStartChunkData = offsetStartChunkData

    for k, v in pairs(self.colorMapping) do
        for _, id in ipairs(v.ids) do
            self.colorMappingLUT[id] = v.color
        end
    end

    return o
end

function ChunkData:update()
    if MemoryState.gameplayState == not "Overworld" then return end
    self.startChunkData = Memory.read_u32_le(MemoryState.base + self.offsetStartChunkData)
    
    self.startChunks = {
        Memory.read_u32_le(self.startChunkData + 0x90),
        Memory.read_u32_le(self.startChunkData + 0x94),
        Memory.read_u32_le(self.startChunkData + 0x98),
        Memory.read_u32_le(self.startChunkData + 0x9C)
    }
    self.totalChunkOffset = Memory.read_s32_le(self.startChunkData + 0xA8)
    self.chunkOffsetWidth = Memory.read_s32_le(self.startChunkData + 0xC0)
    self.chunkOffsetHeight = Memory.read_s32_le(self.startChunkData + 0xC4) 
    if self.chunkOffsetHeight == 0 then self.chunkOffsetHeight = 1 end
    self.chunkOffsetX = self.totalChunkOffset % 32
    self.chunkOffsetZ = math.modf(self.totalChunkOffset / (32*self.chunkOffsetHeight)) % 32

    self.currentChunk = Memory.read_u8(self.startChunkData + 0xAC)
    self.currentSubChunk = Memory.read_u8(self.startChunkData + 0xAD)
    self.loadedXPosSubpixel = Memory.read_u16_le(self.startChunkData + 0xCC)
    self.loadedXPos = Memory.read_u16_le(self.startChunkData + 0xCE)
    self.loadedYPosSubpixel = Memory.read_u16_le(self.startChunkData + 0xD0)
    self.loadedYPos = Memory.read_u16_le(self.startChunkData + 0xD2)
    self.loadedZPosSubpixel = Memory.read_u16_le(self.startChunkData + 0xD4)
    self.loadedZPos = Memory.read_u16_le(self.startChunkData + 0xD6)

    self.isChunkLoading = ({[0] = true,[1] = false})[Memory.read_u8(self.startChunkData + 0xE4)]
end