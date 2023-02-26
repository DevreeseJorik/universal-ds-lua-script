LoadLines = {
    showLoadLines = true,
    showMapLines = true,
    showChunkLines = false,
    showGridLines = false,
    gridColor = "blue",
    loadLineColor = "red",
    mapLineColor = "purple",
    chunkLineColor = "orange"
}

function LoadLines:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function LoadLines:toggleLoadLines()
    self.showLoadLines = not self.showLoadLines
end

function LoadLines:toggleMapLines()
    self.showMapLines = not self.showMapLines
end

function LoadLines:toggleChunkLines()
    self.showChunkLines = not self.showChunkLines
end

function LoadLines:toggleGridLines()
    self.showGridLines = not self.showGridLines
end

function LoadLines:displayLoadLines()
    local relativePosX = 16 - PlayerData.NPCstruct.xCam%32
    local relativePosY = 16 - PlayerData.NPCstruct.zCam%32
    local x = relativePosX*16-8
    local y = relativePosY*13-8
    Display:drawLineCenteredIfWithinBounds(relativePosX*16-8,0,0,Display.height,self.loadLineColor,1,0)
    Display:drawLineCenteredIfWithinBounds(0,relativePosY*13-8,Display.width,0,self.loadLineColor,0,1,1,0)
end 

function LoadLines:displayMapLines()
    local relativePosX = 16 - (PlayerData.NPCstruct.xPhysical-16)%32
    local relativePosY = 16 - (PlayerData.NPCstruct.zPhysical-16)%32
    Display:drawLineCenteredIfWithinBounds(relativePosX*16-8,0,0,Display.height,self.mapLineColor,1,0)
    Display:drawLineCenteredIfWithinBounds(0,relativePosY*13-8,Display.width,0,self.mapLineColor,0,1,1,0)
end 

function LoadLines:displayChunkLines()
    local relativePosX = 16 - (PlayerData.NPCstruct.xCam-16)%32
    local relativePosY = 16 - (PlayerData.NPCstruct.zCam-16)%32
    Display:drawLineCenteredIfWithinBounds(relativePosX*16-8,0,0,Display.height,self.chunkLineColor,1,0)
    Display:drawLineCenteredIfWithinBounds(0,relativePosY*13-8,Display.width,0,self.chunkLineColor,0,1,1,0)
end 

function LoadLines:displayGridLines()
    for i = 0,15 do Display:drawLine(i*16+8,0,0,Display.height, self.gridColor) end 
	for i = 0,14 do Display:drawLine(0,i*13+9,Display.width,0, self.gridColor) end
end 

function LoadLines:display()
    if self.showGridLines then self:displayGridLines() end
    if self.showLoadLines then self:displayLoadLines() end
    if self.showMapLines then self:displayMapLines() end
    if self.showChunkLines then self:displayChunkLines() end
end