ScriptHandler = {
    scriptDataY = 80,
    dissasemblerY = 245,
    addressColor = 0xFFFFFFFF,
    commandColor = 0xFFFF00FF,
    paramColor = 0xFF888888,
    jumpColor = 0xFF00FF00,
    returnColor = 0xFFFFAA33,
    haltColor = "red",
    returnColors = {[true] = "red", [false] = "green"},
    curString = "",
    gridIndex = 0,
    maxLines = 12,
    incrementDelayFrames = 4,
    delayedFrames = 0,
    initBytesToRead = 0,
    bytesToReadIncrementFactor = 16,
}

function ScriptHandler:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ScriptHandler:updateInitBytesToRead(size)
    self.delayedFrames = self.delayedFrames + 1
    if self.delayedFrames < self.incrementDelayFrames then
        return
    end
    self.delayedFrames = 0
    self.initBytesToRead = math.max(self.initBytesToRead + size, 0)
end

function ScriptHandler:incrementInitBytesToRead()
    self:updateInitBytesToRead(self.bytesToReadIncrementFactor)
end

function ScriptHandler:resetInitBytesToRead()
    self.initBytesToRead = 0
end

function ScriptHandler:decrementInitBytesToRead()
    self:updateInitBytesToRead(-self.bytesToReadIncrementFactor)
end

function ScriptHandler:getScriptCommandColor(scriptCommand)
    if ScriptData.scriptCommands[scriptCommand] ~= nil then
        return ScriptData.scriptCommands[scriptCommand].color
    end
    return "red"
end

function ScriptHandler:getParamSizes(params)
    if #params == 0 then
        return {}
    end
    local groupedParams = {}
    local curParam = params[1]
    local prevParam = curParam
    local curParamSize = 0

    for i = 1, #params do
        curParam = params[i]
        if curParam == prevParam then
            curParamSize = curParamSize + 1
        else
            table.insert(groupedParams, curParamSize)
            curParamSize = 1
        end
        prevParam = curParam
    end
    table.insert(groupedParams, curParamSize)
    return groupedParams
end

function ScriptHandler:incrementGridIndex_Bytes(size,addr)
    size = size or 2
    if (math.floor((self.gridIndex + size )/ 16)) > (math.floor(self.gridIndex / 16)) then
        self.gridIndex = self.gridIndex + 16 - (self.gridIndex % 16)
    else
        self.gridIndex = self.gridIndex + size
    end
    local x = self.gridIndex % 16
    local y = math.floor(self.gridIndex/16)
    if (x == 0) and (y < self.maxLines) then -- display Address
        gui.text(1,y * 24 + self.dissasemblerY, Utility:format(addr+1,8), self.addressColor)
    end 
    return x,y
end

function ScriptHandler:updateGrid_Bytes(bytes, color, addr, size)
    size = size or 2
    local x = self.gridIndex % 16
    local y = math.floor(self.gridIndex/16)
    -- bitshift each byte, using the size, and display it
    local byte = 0
    for i = 0,size-1 do
        byte = bit.band(bit.rshift(bytes, (size-1-i) * 8), 0xFF)
        gui.text(90 + x *24, self.dissasemblerY + y*24, Utility:format(byte,2), color)
        x,y = self:incrementGridIndex_Bytes(1,addr+i)
    end
end

function ScriptHandler:updateGrid_Str(text, color, addr)
    size = size or 2
    local x = self.gridIndex % 16
    local y = math.floor(self.gridIndex/16)
    gui.text(90, self.dissasemblerY + y*24, text, color)

    -- if addr == 0 then 
    --     self.endExecution = true 
    --     return
    -- end

    -- if x == 0 then -- display Address
    --     gui.text(self.dissasemblerX,y * 24 + self.dissasemblerY, Utility:format(addr+1,8), self.addressColor)
    -- end 
    self:goToNewLine(addr)
end

function ScriptHandler:goToNewLine(addr)
    self.gridIndex = self.gridIndex + 16 - (self.gridIndex % 16)
    if (addr ~= nil) then
        local y = math.floor(self.gridIndex/16)
        gui.text(self.dissasemblerX,y * 24 + self.dissasemblerY, Utility:format(addr+1,8), self.addressColor)
    end
end

function ScriptHandler:isValidJump(scriptCommand,flag)
    if (scriptCommand == 0x16 or scriptCommand == 0x1A) then return true end
    if (scriptCommand == 0x1C or scriptCommand == 0x1D) and (flag == 0x0 or flag == 0x3 or flag == 0x5) then return true end
    if (scriptCommand == 0x19) and (flag == PlayerData.NPCstruct.facing_dir_32) then return true end
    return false
end

function ScriptHandler:isFunctionCall(scriptCommand)
    if (scriptCommand == 0x1A or scriptCommand == 0x1D) then return true end
    return false
end

function ScriptHandler:isReturn(scriptCommand)
    if (scriptCommand == 0x1B) then return true end
    return false
end

function ScriptHandler:disassembleScriptData()
    -- Script Data
    local scriptOffset = 0
    local jumpOffset = 0
    local returnOffset = 0
    local returnJumpOffset = 0
    --- Script Command Data
    local scriptCommand = 0
    local params = {}
    local paramsGrouped = {}
    local paramValues = {}

    self.gridIndex = 0

    local bytesRead = 0

    while bytesRead < self.initBytesToRead do -- and (not self.endExecution)
        scriptCommand = Memory:read_multi(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, 2)
        scriptOffset = scriptOffset + 2
        bytesRead = bytesRead + 2
        params = ScriptData:getParams(scriptCommand)
        paramsGrouped = self:getParamSizes(params)
        paramValues = {}

        for i = 1, #paramsGrouped do
            paramValues[i] = Memory:read_multi(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, paramsGrouped[i])
            scriptOffset = scriptOffset + paramsGrouped[i]
            bytesRead = bytesRead + paramsGrouped[i]
        end

        if self:isValidJump(scriptCommand, paramValues[1]) then
            if self:isFunctionCall(scriptCommand) then
                returnOffset = scriptOffset
                returnJumpOffset = jumpOffset
            end
            jumpOffset = jumpOffset + paramValues[#paramValues]
        end

        if self:isReturn(scriptCommand) then 
            scriptOffset = returnOffset
            jumpOffset = returnJumpOffset
            returnOffset = 0
            returnJumpOffset = 0
        end
    end

    -- Grid Position
    self.gridIndex = 0
    --self.endExecution = false
    gui.text(self.dissasemblerX,self.dissasemblerY, Utility:format(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset,8), self.addressColor)

    while (math.floor(self.gridIndex / 16) < self.maxLines) do -- and (not self.endExecution)
        scriptCommand = Memory:read_multi(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, 2)
        self:updateGrid_Bytes(scriptCommand, self:getScriptCommandColor(scriptCommand), ScriptData.startOfScriptAddr + scriptOffset + jumpOffset)
        scriptOffset = scriptOffset + 2
        params = ScriptData:getParams(scriptCommand)
        paramsGrouped = self:getParamSizes(params)
        paramValues = {}

        for i = 1, #paramsGrouped do
            paramValues[i] = Memory:read_multi(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, paramsGrouped[i])
            self:updateGrid_Bytes(paramValues[i], self.paramColor, ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, paramsGrouped[i])
            scriptOffset = scriptOffset + paramsGrouped[i]
        end

        if self:isValidJump(scriptCommand, paramValues[1]) then
            if self:isFunctionCall(scriptCommand) then
                returnOffset = scriptOffset
                returnJumpOffset = jumpOffset
            end
            jumpOffset = jumpOffset + paramValues[#paramValues]
            self:goToNewLine()
            self:updateGrid_Str("jump to 0x" .. Utility:format(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset,8), self.jumpColor, ScriptData.startOfScriptAddr + scriptOffset + jumpOffset)
        end

        if self:isReturn(scriptCommand) then 
            if (returnOffset + returnJumpOffset) == 0 then
                self:goToNewLine()
                self:updateGrid_Str("return to ? (undefined behaviour)", self.returnColor,nil)
                -- self.endExecution = true
            else 
                scriptOffset = returnOffset
                jumpOffset = returnJumpOffset
                self:goToNewLine()
                self:updateGrid_Str("return to 0x" .. Utility:format(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset,8), self.returnColor, ScriptData.startOfScriptAddr + scriptOffset + jumpOffset)
                returnOffset = 0
                returnJumpOffset = 0
            end
        end
    end
end

function ScriptHandler:display()
    if not ScriptData.showScriptData then return end

    gui.text(1,self.scriptDataY,"Script Type: " .. ScriptData.eventType)
    gui.text(10,self.scriptDataY+20,"Next Script Command: 0x" .. Utility:format(ScriptData.nextScriptCommandAddr,8))
    gui.text(10,self.scriptDataY+40,"Jump Addr: 0x" .. Utility:format(ScriptData.jumpAddr,1))
    gui.text(10,self.scriptDataY+60,"Jump Amount: 0x" .. Utility:format(ScriptData.jumpAmount,1))
    gui.text(10,self.scriptDataY+80,"Event Id: 0x" .. Utility:format(ScriptData.eventId,1) .. ", Jump table Id: 0x" .. Utility:format(ScriptData.jumpTableId,1))
    gui.text(10,self.scriptDataY+100,"Start of Script: 0x" .. Utility:format(ScriptData.startOfScriptAddr,1) .. " ([Base] + 0x" .. Utility:format(ScriptData.startOfScriptAddr - MemoryState.base,1) .. ")")

    local returnText = "Script is still running"
    if ScriptData.hasReturned then
        returnText = "Script has returned"
    end

    gui.text(1,self.scriptDataY+120,returnText,self.returnColors[ScriptData.hasReturned])
    self:disassembleScriptData()
end