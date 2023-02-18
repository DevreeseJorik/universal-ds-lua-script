Maps = {
    showMaps = true,
    rows = 20,
    columns = 10

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
    local startAddress = MapData.currentMatrixAddr - (self.rows * matrixHeight + self.columns) -- should do * 2 for 16 bit, but we only want the center so we'd need to devide by 2 again, so we can just skip it
    
    for i = 0, self.rows-1 do
        for j = 0, self.columns-1 do
            local mapId = Memory.read_u16_le(startAddress + (i * matrixHeight + j) * 2)
            local color = self:getMapColor(mapId)
            
            if i == self.rows / 2 and j == self.columns / 2 then
                color = 0xFFFFFFFF
            end
           
            if mapId > 999 then
                mapId = "999"
            end
            local x = j * 19
            local y = i * 9
            gui.text((Display.rightScreen + x + 2)*2, (Display.height + y + 10)*2, mapId, color)
        end
    end
end 

function Maps:getMapColor(mapId)
    if mapId > self.maxMapId then
        return MapData.colorMapping.jubilifeCity.color -- Maps above real maps are treated as jubilife city
    end
    local color = MapData.colorMappingLUT[mapId]
    return color or MapData.colorMapping.default.color -- If no color is found, use default
end
