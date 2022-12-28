ScriptHandler = {
    menuX = 0,
    menuY = 205,
    addressColor = 0xFFFFFFFF,
    commandColor = 0xFFFF00FF,
    paramColors = {[0] = 0xFFFF8888,[1] = 0xFF88FF88},
    jumpColor = 0xFF00FF00,
    returnColor = "yellow",
    haltColor = "red",
    nextScriptCommandColors = {[true] = "red", [false] = "green"},
    curString = "",
    gridIndex = 0,
    maxBytesPerLine = 16,
    maxLines = 16,
    gridData = {
        addresses = {},
        dissasembledData = {},
    },

}

function ScriptHandler:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ScriptHandler:detectExecution()

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

function ScriptHandler:incrementGridIndexes(size,addr)
    size = size or 2
    self.gridX = self.gridX + size
    if self.gridX >= self.maxBytesPerLine then
        self.gridX = 0
        self.gridY = self.gridY + 1
    end

    if self.gridX == 0 then 
        -- insert address into self.gridData.addresses
        table.insert(self.gridData.addresses,add)
    end
end

function ScriptHandler:newLineGrid()
    self.gridX = 0
    self.gridY = self.gridY + 1
end

function ScriptHandler:updateGrid_Bytes(bytes, color, addr, size)
    size = size or 2
    if not self.gridData.dissasembledData[color] then
        self.gridData.dissasembledData[color] = {}
    end

    for i = 0, size - 1 do
        if not self.gridData.dissasembledData[color][self.gridY] then
            self.gridData.dissasembledData[color][self.gridY] = {}
        end
        table.insert(self.gridData.dissasembledData[color][self.gridY], {Utility:format(bytes[i],2), self.gridX})
        self:incrementGridIndexes(1,addr+i)
    end

end

function ScriptHandler:updateGrid_Str(text, color)
    if not self.gridData.dissasembledData[color] then
        self.gridData.dissasembledData[color] = {}
    end
    if not self.gridData.dissasembledData[color][self.gridY] then
        self.gridData.dissasembledData[color][self.gridY] = {}
    end
    self:newLineGrid()
    table.insert(self.gridData.dissasembledData[color][self.gridY], {text, self.gridX})
    self:newLineGrid()
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

function ScriptHandler:readMultiFromBatch(addr, size)
    -- returns a table of bytes
    local bytes = {}
    local value = 0
    for i = 0, size - 1 do
        bytes[i] = self.bytesBatch[addr + i]
        value = value + bit.lshift(bytes[i], i * 8)
    end
    return bytes , value
end

function ScriptHandler:disassembleScriptData()
    -- Script Data
    local bytes = {}
    local value = 0
    local scriptOffset = 0
    local jumpOffset = 0
    local returnOffset = 0
    local returnJumpOffset = 0
    --- Script Command Data
    local scriptCommand = 0
    local params = {}
    local paramsGrouped = {}
    local paramValues = {}

    -- Grid Position
    self.bytesBatch = Memory.read_bytes_as_dict(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, 0x100) -- get batch of bytes, indexed by address
    self.gridX = 0
    self.gridY = 0

    self.gridData = {
        addresses = {},
        dissasembledData = {},
    }

    while self.gridY < self.maxLines do
        bytes, scriptCommand = self:readMultiFromBatch(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, 2)

        self:updateGrid_Bytes(bytes, self:getScriptCommandColor(scriptCommand), ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, 2)
        scriptOffset = scriptOffset + 2

        params = ScriptData:getParams(scriptCommand)
        paramsGrouped = self:getParamSizes(params)
        paramValues = {}

        for i = 1, #paramsGrouped do
            bytes, value = self:readMultiFromBatch(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, paramsGrouped[i])
            paramValues[i] = value
            self:updateGrid_Bytes(bytes, "gray", ScriptData.startOfScriptAddr + scriptOffset + jumpOffset, paramsGrouped[i])
            scriptOffset = scriptOffset + paramsGrouped[i]
        end

        if self:isValidJump(scriptCommand, paramValues[1]) then
            if self:isFunctionCall(scriptCommand) then
                returnOffset = scriptOffset
                returnJumpOffset = jumpOffset
            end
            jumpOffset = jumpOffset + paramValues[#paramValues-1]
        end

        if self:isReturn(scriptCommand) then 
            if (returnOffset + returnJumpOffset) == 0 then
                
                self:updateGrid_Str("return to ? (undefined behaviour)", self.returnColor, "")
                
            else 
                scriptOffset = returnOffset
                jumpOffset = returnJumpOffset
                
                self:updateGrid_Str("return to 0x" .. Utility:format(ScriptData.startOfScriptAddr + scriptOffset + jumpOffset,16), self.returnColor, "")
                
                returnOffset = 0
                returnJumpOffset = 0
            end
        end
    end
end

function ScriptHandler:displayDissasembledScriptData()
    local tempString
    -- loop through grid data, get index and color

    for color, _ in pairs(self.gridData.dissasembledData) do
        tempString = ""
        -- loop through all lines for this color
        for y = 0, self.maxLines do
            local lineData = self.gridData.dissasembledData[color][y]
            tempString = tempString .. self:createLine(lineData)
        end
        gui.text(self.menuX, self.menuY, tempString, color)
    end
end

function ScriptHandler:createLine(lineData)
    local tempLine = string.rep(" ", 3*self.maxBytesPerLine)
    local data
    local text
    local x
    if lineData then
        -- create a string containing 3*self.maxBytesPerLine characters
        for j = 1, #lineData do
            data = lineData[j]
            text = data[1]
            x = data[2]
            -- replace the characters in tempLine at x*3 with text
            tempLine = tempLine:sub(1,x*3-1) .. text .. tempLine:sub(x*3+#text)
        end    
    end
    return tempLine .. "\n"
end


function ScriptHandler:display()
    -- this code is optimized for speed, not readability. Don't blame me for gui.text() being slow.
    if not ScriptData.showScriptData then return end
    local nextScriptCommandColor = self.nextScriptCommandColors[ScriptData.hasReturned]
    gui.text(0,60,"Next Script Command: " .. Utility:format(ScriptData.nextScriptCommandAddr,8), nextScriptCommandColor)
    gui.text(0,80,"Script Data")
    gui.text(10,100,"Jump Addr: 0x" .. Utility:format(ScriptData.jumpAddr,1))
    gui.text(10,120,"Jump Amount: 0x" .. Utility:format(ScriptData.jumpAmount,1))
    gui.text(10,140,"Start of Script: 0x" .. Utility:format(ScriptData.startOfScriptAddr,1) .. " ([Base] + 0x" .. Utility:format(ScriptData.startOfScriptAddr - MemoryState.base,1) .. ")")
    gui.text(10,160,"script Data Pointer: 0x" .. Utility:format(ScriptData.scriptDataPointer,1))
    gui.text(10,180,"script Data: 0x" .. Utility:format(ScriptData.scriptDataAddr,1))
    self:disassembleScriptData()
    self:displayDissasembledScriptData()
end