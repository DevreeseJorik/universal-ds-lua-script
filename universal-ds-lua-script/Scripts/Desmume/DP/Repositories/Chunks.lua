Chunks = {
    showChunks = true;
    currentTileColors = {{},{},{},{}}
}

function Chunks:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Chunks:displayChunks()
    gui.box(0,0,256,192,"#000000",0)
    for i = 0, 3 do
        self:displayChunk(ChunkData.startChunks[i+1],i)
    end
end

function Chunks:displayChunk(addr,chunkId)
    local chunkXOffs = 0
    if chunkId == 1 or chunkId == 3 then chunkXOffs = 128 end
    local chunkYOffs = 0
    local tileData
    if chunkId > 1 then chunkYOffs = 96 end
    for col = 0,31 do 
        for row = 0,31 do 
            tileData = memory.readword(addr+row*2 + col*64)
            tileId = bit.band(tileData,0xff)
	        collision = bit.rshift(tileData,8)
            tileColor = self:getTileColor(tileId,collision)
            gui.box(chunkXOffs+row*4,chunkYOffs+col*3,chunkXOffs+row*4+5,chunkYOffs+col*3+4,tileColor,0)
        end
    end 
end

function Chunks:getTileColor(tileId,collision)
	if tileId == 0x00 then 
		if collision > 0x7F then return "#CCCCCC" end
        return
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