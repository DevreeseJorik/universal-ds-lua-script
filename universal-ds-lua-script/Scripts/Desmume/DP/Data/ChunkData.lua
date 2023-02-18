ChunkData = {
    colorMapping = {
        grass = {
            color = '#40a',
            ids = {0x2,0x7B}
        },
        default = {
            color = nil,
            ids = {0xff}
        },
        warps = {
            color = '#f03',
            ids ={0x5E,0x5f,0x62,0x63,0x69,0x65,0x6f,0x6D,0x6A,0x6C,0x6E}
        },
        cave = {
            color = '#bb7410',
            ids = {0x6,0x8,0xC}
        },
        water = {
            color = '#4888f',
            ids = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x19,0x22,0x2A,0x7C}
        },
        sand = {
            color = '#e3c',
            ids = {0x21,0x21}
        },
        deep_snow1 = {
            color = '#8da9cb',
            ids = {0xA1}
        },
        deep_snow2 = {
            color = '#6483a7',
            ids = {0xA2}
        },
        deep_snow3 = {
            color = '#52749d',
            ids = {0xA3}
        },
        mud = {
            color = '#92897',
            ids = {0xA4}
        },
        mud_block = {
            color = '#92704',
            ids = {0xA5}
        },
        mud_grass = {
            color = '#4090',
            ids = {0xA6}
        },
        mud_grass_block = {
            color = '#55906',
            ids = {0xA7}
        },
        snow = {
            color = '#b9d0eb',
            ids = {0xA8}
        },
        tall_grass = {
            color = '#2aa615',
            ids = {0x3}		
        },
        misc_obj = {
            color = 'white',
            ids = {0xE5,0X8E,0X8f}
        },
        spin_tile = {
            color = '#ffd',
            ids = {0x40,0x41,0x42,0x43}
        },
        ice = {
            color = '#56b3e0',
            ids = {0x20,0x20}
        },
        ice_stair = {
            color = '#ffd',
            ids = {0x49,0x4A}
        },
        circle_warp = {
            color = '#a0a',
            ids = {0x67}
        },
        model_fl = {
            color = '#afb',
           ids = {0x56,0x57,0x58,} 
        },
        model_floor = {
            color = '#a090f',
           ids = {0x59}
        },
        special_collision = {
            color = '#a090f',
           ids = {0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37}
        },
        bike_stall = {
            color = '#0690a',
           ids = {0xDB}
        },
        counter = {
            color = '#f7a',
            ids = {0x80}
        },
        pc = {
           color = '#0690b',
           ids = {0x83}
        },
        map = {
           color = '#00eee',
           ids = {0x85}
        },
        tv = {
           color = '#4290e',
           ids = {0x86}
        },
        bookcases = {
            color = '#0ddd7',
            ids = {0x88,0xE1,0xE0,0xE2}
        },
        bin = {
            color = '#06b04',
           ids = {0xE4}
        },
        indoor_encounter = {
            color = '#A292BC',
            ids = {0xB}
        },
        ledge = {
            color = '#D3A',
            ids = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
        },
        rock_climb = {
            color = '#C76',
            ids = {0x4B,0x4C}
        },
        bridge = {
            color = '#C79',
            ids = {0x71,0x72,0x73,0x74,0x75}
        },
        start_bridge = {
            color= "#C7B", 
            ids = {0x70}
        },
        bike_bridge = {
            color = '#C7A55',
            ids = {0x76,0x77,0x78,0x79,0x7A,0x7D}
            -- BikeBridge 0x7C moves to water, 0x7B moved to grass
        },
        soil = {
            color = '#b2703',
            ids = {0xA0}
        },
        bike_ramp = {
            color = '#B890',
            ids = {0xD7,0xD8}
        },
        quick_sand = {
            color = '#A880',
            ids = {0xD9,0xDA}
        },
    },

    tileIds = {}
}

function ChunkData:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    for k,v in pairs(self.colorMapping) do
        for i=1,#self.colorMapping[k]['ids'] do
            self.tileIds[self.colorMapping[k]['ids'][i]] = self.colorMapping[k]['color']
        end
    end

    return o
end

function ChunkData:update()
    if MemoryState.gameplayState == not "Overworld" then return end
    self.startChunkData = memory.readdword(MemoryState.base + 0x229F0)

    self.startChunks = {
        memory.readdword(self.startChunkData +0x90),
        memory.readdword(self.startChunkData +0x94),
        memory.readdword(self.startChunkData +0x98),
        memory.readdword(self.startChunkData +0x9C)
    }
    self.currentChunk = memory.readbyte(self.startChunkData + 0xAC)
    self.currentSubChunk = memory.readbyte(self.startChunkData + 0xAD)
    self.loadedXPosSubpixel = memory.readword(self.startChunkData + 0xCC)
    self.loadedXPos = memory.readword(self.startChunkData + 0xCE)
    self.loadedYPosSubpixel = memory.readword(self.startChunkData + 0xD0)
    self.loadedYPos = memory.readword(self.startChunkData + 0xD2)
    self.loadedZosSubpixel = memory.readword(self.startChunkData + 0xD4)
    self.loadedZPos = memory.readword(self.startChunkData + 0xD6)

    self.isChunkLoading = ({[0] = true,[1] = false})[memory.readbyte(self.startChunkData + 0xE4)]
end