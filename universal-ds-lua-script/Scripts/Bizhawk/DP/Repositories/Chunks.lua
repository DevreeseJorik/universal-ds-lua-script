Chunks = {
    showChunks = true,
    chunks = {},
    isChunkLoaded = false,
    bg = 0xFF000000,
    showBoundingBoxes = false
}

function Chunks:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Chunks:displayChunks()
    self.drawnRects = 0
    for i = 0, 3 do
        self:loadChunk(i)
        if self.isChunkLoaded then
            self:displayChunkClustered(i)
        end
    end
    gui.text(Display.rightScreen*2 + 10, 192*2, "drawn clustered tiles: " .. self.drawnRects)
end

function Chunks:loadChunk(chunkId)
    local addr = ChunkData.startChunks[chunkId+1]
    if addr == 0 then self.isChunkLoaded = false return end
    self.chunks[chunkId] = Memory.read_bytes_as_array(addr,2048)
    self.isChunkLoaded = true
end

function Chunks:clusterTiles(chunkId)
    local chunk = self.chunks[chunkId]
    local clusteredTiles = {}
    local tileId = nil
    local collision = nil
    local tileColor = nil
    local clusterCount = 0
    local horizontalClusterCount = 0
    local verticalClusterCount = 0
    for i=0,1023 do
        tileId = chunk[i*2+1]
        if tileId ~= nil then 
            collision = chunk[i*2+2]
            tileColor = self:getTileColor(tileId,collision)
            
            horizontalClusterCount = self:getHorizontalClusterCount(chunkId,i,tileColor)
            verticalClusterCount = self:getVerticalClusterCount(chunkId,i,tileColor)
            
            clusteredTiles[clusterCount] = {
                x = i%32,
                y = math.floor(i/32),
                horizontalClusterCount = horizontalClusterCount,
                verticalClusterCount = verticalClusterCount,
                color = tileColor
            }
            self:removeClusteredTiles(chunkId,i,horizontalClusterCount,verticalClusterCount,tileColor)
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
        clusterCount = clusterCount + 1
    end
    return clusterCount
end

function Chunks:removeClusteredTiles(chunkId,i,horizontalClusterCount,verticalClusterCount,color)
    for j = 0, verticalClusterCount-1 do
        for k = 0, horizontalClusterCount-1 do
            self:removeIfPartOfCluster(chunkId,i,j,k,color)
        end
    end
end

function Chunks:removeIfPartOfCluster(chunkId,i,j,k,color)
    local chunk = self.chunks[chunkId]
    local tempTileId = chunk[i*2+j*64+k*2+1]
    local adjacentTileCount = 0
    if tempTileId ~= nil then 
        tempCollision = chunk[i*2+j*64+k*2+2]
        if self:getTileColor(tempTileId,tempCollision) ~= color then return end -- if tile color is not the same as the cluster color, return
        if (j == 0) or (k == 0) then  -- if first row or first column, remove tile, don't check for adjacent tiles
            chunk[i*2+j*64+k*2+1] = nil
            chunk[i*2+j*64+k*2+2] = nil
            return 
        end
        -- if not first row and tile above/left is not nil, increment adjacentTileCount
        if chunk[i*2+(j-1)*64+k*2+1] == nil then adjacentTileCount = adjacentTileCount + 1 end
        if chunk[i*2+j*64+(k-1)*2+1] == nil then adjacentTileCount = adjacentTileCount + 1 end
        if adjacentTileCount == 0 then return end
        chunk[i*2+j*64+k*2+1] = nil
        chunk[i*2+j*64+k*2+2] = nil
    end 
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
            if self.showBoundingBoxes then 
                gui.drawRectangle(Display.rightScreen + paddingLeft + tile.x*w,paddingTop + tile.y*h,tile.horizontalClusterCount*w-1,tile.verticalClusterCount*h-1,"red",tile.color)
            else 
                gui.drawRectangle(Display.rightScreen + paddingLeft + tile.x*w,paddingTop + tile.y*h,tile.horizontalClusterCount*w-1,tile.verticalClusterCount*h-1,tile.color,tile.color)
            end
        end
    end
    self.drawnRects = self.drawnRects + #clusteredTiles
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