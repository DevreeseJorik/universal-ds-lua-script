Chunks = {
    showChunks = true;
    chunks = {}
}

function Chunks:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Chunks:displayChunks()
    local mostCommonTileColor = nil
    for i = 0, 3 do
        self:loadChunk(i)
        self:displayChunk(i,self:getMostCommonTileColor(i))
    end
end

function Chunks:loadChunk(chunkId)
    local addr = ChunkData.startChunks[chunkId+1]
    self.chunks[chunkId] = Memory.read_bytes_as_array(addr,2048)
end

function Chunks:getTileColorCount(chunkId)
    local chunk = self.chunks[chunkId]
    local tileColorCounts = {}
    for i=0,1023 do
        tileId = self.chunks[chunkId][i*2+1]
        collision = self.chunks[chunkId][i*2+2]
        tileColor = self:getTileColor(tileId,collision)
        if tileColorCounts[tileColor] == nil then tileColorCounts[tileColor] = 0 end
        tileColorCounts[tileColor] = tileColorCounts[tileColor] + 1
    end
    return tileColorCounts
end

function Chunks:getMostCommonTileColor(chunkId)
    local tileColorCounts = self:getTileColorCount(chunkId)
    local mostCommonTileColor = nil
    local mostCommonTileColorCount = 0
    for tileColor,count in pairs(tileColorCounts) do
        if count > mostCommonTileColorCount then
            mostCommonTileColor = tileColor
            mostCommonTileColorCount = count
        end
    end
    return mostCommonTileColor
end

function Chunks:displayChunk(chunkId,mostCommonTileColor)
    local w = 3
    local h = 3
    local paddingLeft = (32*w)*(chunkId%2)
    local paddingTop = (32*h)*(math.floor(chunkId/2))
    local chunk = self.chunks[chunkId]

    gui.drawRectangle(Display.rightScreen + paddingLeft,paddingTop,32*w,32*h,mostCommonTileColor,mostCommonTileColor)

    for i=0,1023 do
        tileId = chunk[i*2+1]
        collision = chunk[i*2+2]
        tileColor = self:getTileColor(tileId,collision)

        if tileColor ~= mostCommonTileColor then
            gui.drawRectangle(Display.rightScreen + paddingLeft + i%32*w,paddingTop + math.floor(i/32)*h,w-1,h-1,tileColor,tileColor)
        end
    end

end

function Chunks:getTileColor(tileId,collision)
	if tileId == 0x00 then 
		if collision > 0x7F then return 0xFFCCCCCC end
        return 0xFF000000
	end 
	return ChunkData.tileIds[tileId]
end

function Chunks:toggleChunks()
    self.showChunks = not self.showChunks
end 

function Chunks:display()
    if MemoryState.gameplayState == not "Overworld" then return end
    if self.showChunks then self:displayChunks() end 
end