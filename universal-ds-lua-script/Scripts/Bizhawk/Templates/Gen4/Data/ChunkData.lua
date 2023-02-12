ChunkData = {
    tileData = {
        grass = {
            color = 0xFF80B020,
            ids = {0x2,0x7B}
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
            color = 0xFFE3C000,
            ids = {0x21,0x21}
        },
        deep_snow1 = {
            color = 0xFF8DA9CB,
            ids = {0xA1}
        },
        deep_snow2 = {
            color = 0xFF6483A7,
            ids = {0xA2}
        },
        deep_snow3 = {
            color = 0xFF52749D,
            ids = {0xA3}
        },
        mud = {
            color = 0xFF928970,
            ids = {0xA4}
        },
        mud_block = {
            color = 0xFF927040,
            ids = {0xA5}
        },
        mud_grass = {
            color = 0xFF409000,
            ids = {0xA6}
        },
        mud_grass_block = {
            color = 0xFF559060,
            ids = {0xA7}
        },
        snow = {
            color = 0xFFB9D0EB,
            ids = {0xA8}
        },
        tall_grass = {
            color = 0xFF2AA615,
            ids = {0x3}		
        },
        misc_obj = {
            color = 0xFFFFFFFF,
            ids = {0xE5,0X8E,0X8f}
        },
        spin_tile = {
            color = 0xFFFFD000,
            ids = {0x40,0x41,0x42,0x43}
        },
        ice = {
            color = 0xFF56B3E0,
            ids = {0x20,0x20}
        },
        ice_stair = {
            color = 0xFFFFD000,
            ids = {0x49,0x4A}
        },
        circle_warp = {
            color = 0xFFA0A000,
            ids = {0x67}
        },
        model_fl = {
            color = 0xFFAFB000,
           ids = {0x56,0x57,0x58,} 
        },
        model_floor = {
            color = 0xFFA090F0,
           ids = {0x59}
        },
        special_collision = {
            color = 0xFFA090F0,
           ids = {0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37}
        },
        bike_stall = {
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
        haunted_house = {
            color = 0xFFA292BC,
            ids = {0xB}
        },
        ledge = {
            color = 0xFFD3A000,
            ids = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
        },
        rock_climb = {
            color = 0xFFC76000,
            ids = {0x4B,0x4C}
        },
        bridge = {
            color = 0xFFC79000,
            ids = {0x71,0x72,0x73,0x74,0x75}
        },
        start_bridge = {
            color= 0xC7B000, 
            ids = {0x70}
        },
        bike_bridge = {
            color = 0xFFC7A55,
            ids = {0x76,0x77,0x78,0x79,0x7A,0x7D}
        },
        soil = {
            color = 0xFFB27030,
            ids = {0xA0}
        },
        bike_ramp = {
            color = 0xFFB89000,
            ids = {0xD7,0xD8}
        },
        quick_sand = {
            color = 0xFFA88000,
            ids = {0xD9,0xDA}
        },
    },

    tileIds = {}
}

function ChunkData:new(offsetStartChunkData, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.offsetStartChunkData = offsetStartChunkData

    for k,v in pairs(self.tileData) do
        for i=1,#self.tileData[k]['ids'] do
            self.tileIds[self.tileData[k]['ids'][i]] = self.tileData[k]['color']
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

    self.currentChunk = Memory.read_u8(self.startChunkData + 0xAC)
    self.currentSubChunk = Memory.read_u8(self.startChunkData + 0xAD)
    self.loadedXPosSubpixel = Memory.read_u16_le(self.startChunkData + 0xCC)
    self.loadedXPos = Memory.read_u16_le(self.startChunkData + 0xCE)
    self.loadedYPosSubpixel = Memory.read_u16_le(self.startChunkData + 0xD0)
    self.loadedYPos = Memory.read_u16_le(self.startChunkData + 0xD2)
    self.loadedZosSubpixel = Memory.read_u16_le(self.startChunkData + 0xD4)
    self.loadedZPos = Memory.read_u16_le(self.startChunkData + 0xD6)

    self.isChunkLoading = ({[0] = true,[1] = false})[Memory.read_u8(self.startChunkData + 0xE4)]


end