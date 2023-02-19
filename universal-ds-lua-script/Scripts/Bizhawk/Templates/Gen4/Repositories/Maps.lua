Maps = {
    showMaps = true,
    rows = 20,
    columns = 16

}

function Maps:new(maxMapId, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.maxMapId = maxMapId
    return o
end

function Maps:display()
    local matrixHeight = MapData.matrixHeight
    local currentMatrixAddr = MapData.currentMatrixAddr
    local startAddress = currentMatrixAddr - (self.rows * matrixHeight + self.columns) -- should do * 2 for 16 bit, but we only want the center so we'd need to devide by 2 again, so we can just skip it
    local address, mapId, color, x, y
    for i = 0, self.rows-1 do
        for j = 0, self.columns-1 do
            address = startAddress + (i * matrixHeight + j) * 2
            mapId = Memory.read_u16_le(address)
            color = self:getMapColor(mapId)
            if address == currentMatrixAddr then
                color = 0xFFFFFFFF
            end
            if mapId > 999 then
                mapId = "999"
            end
            x = j * 19
            y = i * 9
            gui.text((Display.rightScreen + x + 2)*2, (Display.height + y + 10)*2, mapId, color)
        end
    end
end 

function Maps:getMapColor(mapId)
    if mapId > self.maxMapId then
        return MapData.colorMapping.errorHandled.color -- Maps above real maps are treated as jubilife city
    end
    local color = MapData.colorMappingLUT[mapId]
    return color or MapData.colorMapping.default.color -- If no color is found, use default
end
