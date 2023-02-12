MemoryState = {
    base,
    gameplayState,
    memoryOffset,
    staticAddresses = {
        ug_init_addr = 0x2250E86
    },
    offsets = {
        memorystate_check = 0x22A00,
        
    },
    values = {
        ug_init_val = 0x1F,
        memorystate_check_value = 0x2C9EC
    }
}

function MemoryState:new(savedDataPointerReference, savedDataPointerOffset, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.savedDataPointerReference = savedDataPointerReference
    self.savedDataPointerOffset = savedDataPointerOffset
    return o
end

function MemoryState:setMemoryState(base)
	if Memory.read_u32_le(base + self.offsets["memorystate_check"]) == (base + self.values["memorystate_check_value"]) then -- check for ug/bt ptr
		if Memory.read_s8(self.staticAddresses["ug_init_addr"]) == self.values["ug_init_val"] then
            self.gameplayState = "Underground"
            self.memoryOffset = 0x8124
			return
		end
        self.gameplayState = "Battle Tower" 
        self.memoryOffset = 0x8124
		return 
	end 
    self.gameplayState = "Overworld"
    self.memoryOffset = 0
	return 
end

function MemoryState:update()
    self.base = Memory.read_u32_le(Memory.read_u32_le(self.savedDataPointerReference) + self.savedDataPointerOffset)
    self:setMemoryState(self.base)
end

function MemoryState:display()
    gui.text(0,38,"Base: 0x" .. Utility:format(self.base,8) .. " - " .. self.gameplayState)
end