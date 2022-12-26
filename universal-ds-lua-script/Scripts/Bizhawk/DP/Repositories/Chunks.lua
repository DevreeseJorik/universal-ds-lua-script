Chunks = {
    showChunks = true,
    chunks = {},
    chunksLoaded = false,
}

function Chunks:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Chunks:displayChunks()
    for i = 0, 3 do
        self:loadChunk(i)
        if self.chunksLoaded then
            --self:displayChunk(i,self:getMostCommonTileColor(i))
            self:displayChunkClustered(i)
        end
    end
end

function Chunks:loadChunk(chunkId)
    local addr = ChunkData.startChunks[chunkId+1]
    if addr == 0 then self.chunksLoaded = false return end
    self.chunks[chunkId] = Memory.read_bytes_as_array(addr,2048)
    self.chunksLoaded = true
end

-- this is the old way of displaying chunks, with minor optimizations

-- function Chunks:getTileColorCount(chunkId)
--     local chunk = self.chunks[chunkId]
--     local tileColorCounts = {}
--     for i=0,1023 do
--         tileId = self.chunks[chunkId][i*2+1]
--         collision = self.chunks[chunkId][i*2+2]
--         tileColor = self:getTileColor(tileId,collision)
--         if tileColorCounts[tileColor] == nil then 
--             tileColorCounts[tileColor] = 0 
--         end
--         tileColorCounts[tileColor] = tileColorCounts[tileColor] + 1
--     end
--     return tileColorCounts
-- end

-- function Chunks:getMostCommonTileColor(chunkId)
--     local tileColorCounts = self:getTileColorCount(chunkId)
--     local mostCommonTileColor = nil
--     local mostCommonTileColorCount = 0
--     for tileColor,count in pairs(tileColorCounts) do
--         if count > mostCommonTileColorCount then
--             mostCommonTileColor = tileColor
--             mostCommonTileColorCount = count
--         end
--     end
--     return mostCommonTileColor
-- end

-- function Chunks:displayChunk(chunkId,mostCommonTileColor)
--     local w = 3
--     local h = 3
--     local paddingLeft = (32*w)*(chunkId%2)
--     local paddingTop = (32*h)*(math.floor(chunkId/2))
--     local chunk = self.chunks[chunkId]

--     gui.drawRectangle(Display.rightScreen + paddingLeft,paddingTop,32*w,32*h,mostCommonTileColor,mostCommonTileColor)

--     for i=0,1023 do
--         tileId = chunk[i*2+1]
--         collision = chunk[i*2+2]
--         tileColor = self:getTileColor(tileId,collision)

--         if tileColor ~= mostCommonTileColor then
--             gui.drawRectangle(Display.rightScreen + paddingLeft + i%32*w,paddingTop + math.floor(i/32)*h,w-1,h-1,tileColor,tileColor)
--         end
--     end
-- end

-- this is the new way of displaying chunks, with major optimizations by clustering tiles.

function Chunks:clusterTiles(chunkId)
    local chunk = self.chunks[chunkId]
    local clusteredTiles = {}
    local tileId = nil
    local collision = nil
    local tileColor = nil
    local clusterCount = 0
    for i=0,1023 do
        tileId = chunk[i*2+1]
        if tileId ~= nil then 
            collision = chunk[i*2+2]
            tileColor = self:getTileColor(tileId,collision)
            
            clusteredTiles[clusterCount] = {
                x = i%32,
                y = math.floor(i/32),
                horizontalClusterCount = self:getHorizontalClusterCount(chunkId,i,tileColor),
                verticalClusterCount = self:getVerticalClusterCount(chunkId,i,tileColor),
                color = tileColor
            }

            clusterCount = clusterCount + 1
        end 
    end
    return clusteredTiles
end

function Chunks:getHorizontalClusterCount(chunkId,i,color)
    local chunk = self.chunks[chunkId]
    local tempTileId = nil
    local tempCollision = nil
    local tempColor = nil
    local clusterCount = 1
    for j = 1, 31 - i%32 do
        tempTileId = chunk[i*2+j*2+1]
        if tempTileId == nil then return clusterCount end
        tempCollision = chunk[i*2+j*2+2]
        tempColor = self:getTileColor(tempTileId,tempCollision)
        if tempColor ~= color then return clusterCount end
        chunk[i*2+j*2+1] = nil
        chunk[i*2+j*2+2] = nil
        clusterCount = clusterCount + 1
    end
    return clusterCount
end

function Chunks:getVerticalClusterCount(chunkId,i,color)
    local chunk = self.chunks[chunkId]
    local tempTileId = nil
    local tempCollision = nil
    local tempColor = nil
    local clusterCount = 1
    for j = 1, 31 - math.floor(i/32) do
        tempTileId = chunk[i*2+j*64+1]
        if tempTileId == nil then return clusterCount end
        tempCollision = chunk[i*2+j*64+2]
        tempColor = self:getTileColor(tempTileId,tempCollision)
        if tempColor ~= color then return clusterCount end
        chunk[i*2+j*64+1] = nil
        chunk[i*2+j*64+2] = nil
        clusterCount = clusterCount + 1
    end
    return clusterCount
end

function Chunks:displayChunkClustered(chunkId)
    local clusteredTiles = self:clusterTiles(chunkId)
    local w = 3
    local h = 3
    local paddingLeft = (32*w)*(chunkId%2)
    local paddingTop = (32*h)*(math.floor(chunkId/2))
    for i=0,#clusteredTiles do
        local tile = clusteredTiles[i]
        if tile ~= nil then
            gui.drawRectangle(Display.rightScreen + paddingLeft + tile.x*w,paddingTop + tile.y*h,tile.horizontalClusterCount*w-1,tile.verticalClusterCount*h-1,tile.color,tile.color)
        end
    end
       
end 

function Chunks:getTileColor(tileId,collision)
	if tileId == 0x00 then 
		if collision > 0x7F then return 0xFFCCCCCC end
        return 0xFF000000
	end 
    local tileColor = ChunkData.tileIds[tileId]
    if tileColor then return tileColor end
	if collision > 0x7F then return 0xFFCCCCCC end
    return 0xFF000000
end

function Chunks:toggleChunks()
    self.showChunks = not self.showChunks
end 

function Chunks:display()
    if MemoryState.gameplayState == not "Overworld" then return end
    if self.showChunks then self:displayChunks() end 
end