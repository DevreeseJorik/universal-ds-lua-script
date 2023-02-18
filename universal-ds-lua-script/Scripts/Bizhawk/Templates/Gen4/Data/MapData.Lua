MapData = {
    colorMapping = { -- default for Pokémon Diamond and Pearl
        mysteryZone = {
            color = 0xFF88888866,
            ids = {0}
        },
        blackOut = {
            color = 0xFFFFFF00,
            ids = {332, 333}
        },
        movement = {
            color = 0xFFFF00FF,
            ids = {117, 177, 179, 181, 183, 192, 393,
                474, 475, 476, 477, 478, 479, 480, 481, 482, 483,
                484, 485, 486, 487, 488, 489, 490, 496}
        },
        warp = {
            color = 0xFF00FF00,
            ids = {105, 114, 337, 461, 516, 186, 187}
        },
        bsod = {
            color = 0xFFFF0000,
            ids = {35, 88, 93, 95, 122,133,154, 155, 156, 176, 178, 180, 182,
                    184, 185, 188, 291, 293, 504, 505, 506, 507, 508, 509}
        },
        softLock = {
            color = 0xFFFF0000,
            ids = {150}
        },
        wrongWarp = {
            color = 0xFF666FD,
            ids = {7,37,49,70,102,124,135,152,169,174,190,421,429,436,444,453,460,495}
        },
        jubilifeCity = {
            color = 0xFF66FFBB,
            ids = {3}
        },
        goal = {
            color = 0xFFF7BBF3,
            ids = {
                165, 215, 347
            }
        },
        chain = {
            color = 0xFFDFA000,
            ids = {2, 200, 214, 220, 347, 510, 65, 200, 203, 348, 365,113, 116, 119, 146, 160, 166, 167, 168, 170, 171, 195, 278, 342, 361, 418, 440
        }
        },
    
        default = {
            color = 0xFF00BB00,
            ids = {}
        },
        errorHandled = {
            color = 0xFF66FFBB,
            ids = {3}
        }
    },

    colorMappingLUT = {}

}

function MapData:new(offsetMatrixData,o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.offsetMatrixData = offsetMatrixData

    for k,v in pairs(self.colorMapping) do
        for _,id in pairs(v.ids) do
            self.colorMappingLUT[id] = v.color
        end
    end

    return o
end

function MapData:update()
    self.startMatrixData = MemoryState.base + self.offsetMatrixData + MemoryState.memoryOffset
    self.matrixId = Memory.read_u16_le(self.startMatrixData + 0x52)
    self.matrixWidth = Memory.read_u8(self.startMatrixData + 0x54)
    self.matrixHeight = Memory.read_u8(self.startMatrixData + 0x55)
    self.matrixCenterAddress = self.startMatrixData + 0x56
    
    self.currentMatrixOffsets = {
        x = math.modf(PlayerData.NPCstruct.x_phys_32 / 32) * 2,
        y = math.modf(PlayerData.NPCstruct.z_phys_32 / 32) * 2 * self.matrixHeight 
    }

    self.currentMatrixAddr = self.matrixCenterAddress + self.currentMatrixOffsets.x + self.currentMatrixOffsets.y
end