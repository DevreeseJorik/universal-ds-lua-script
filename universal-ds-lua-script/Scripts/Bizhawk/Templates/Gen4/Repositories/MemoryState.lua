MemoryState = {
    base,
    gameplayState,
    memoryOffset,
    staticAddresses = {
        ugInitAddress = 0x2250E86
    },
    offsets = {
        memorystateCheck = 0x22A00,
        
    },
    values = {
        ugInitValue = 0x1F,
        memorystateCheckValue = 0x2C9EC
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
	if Memory.read_u32_le(base + self.offsets["memorystateCheck"]) == (base + self.values["memorystateCheckValue"]) then -- check for ug/bt ptr
		if Memory.read_s8(self.staticAddresses["ugInitAddress"]) == self.values["ugInitValue"] then
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
    gui.text(1,38,"Base: 0x" .. Utility:format(self.base,8) .. " - " .. self.gameplayState)
end