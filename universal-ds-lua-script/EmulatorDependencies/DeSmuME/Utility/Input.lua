Input = {
	key = {},
	lastKey = {},
}

function Input:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Input:getKeys()
	self.lastKey = self.key
	self.key = input.get()
end

function Input:checkKeys(btns)
	pressedKeyCount = 0
	notPrevHeld = false
	for btn =1,#btns do
		if self.key[btns[btn]] then 	
				pressedKeyCount = pressedKeyCount + 1
		end 
		if not self.lastKey[btns[btn]] then
			notPrevHeld = true -- check if at least 1 button wasn't previously held
		end 
	end
	if notPrevHeld then
		return pressedKeyCount
	end 
end 

function Input:checkKeysContinues(btns)
	pressedKeyCount = 0
	for btn =1,#btns do
		if self.key[btns[btn]] then 	
				pressedKeyCount = pressedKeyCount + 1
		end 
	end
	return pressedKeyCount
end 

function Input:checkKey(btn)
	if self.key[btn] and not self.lastKey[btn] then
		return true
	else
		return false
	end
end

function Input:runFunctionsOnKeypress()
	local func  = nil
	local configKeys = nil
	for i,data in pairs(self.keyConfig) do
		func = data.func
		configKeys = data.keys
		if self:checkKeys(configKeys) == #configKeys then
			func()
		end
	end
end

function Input:runFunctionsWhileKeypress()
	local func  = nil
	local configKeys = nil
	for i,data in pairs(self.keyConfigContinues) do
		func = data.func
		configKeys = data.keys
		if self:checkKeysContinues(configKeys) == #configKeys then
			func()
		end
	end
end

function Input:runChecks()
	Input:getKeys()
	Input:runFunctionsOnKeypress()
	Input:runFunctionsWhileKeypress()
end