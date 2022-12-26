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
    chunk_x_offs = 0
    if chunkId == 1 or chunkId == 3 then chunk_x_offs = 128 end
    chunk_y_offs = 0
    if chunkId > 1 then chunk_y_offs = 96 end
    for col = 0,31 do 
        for row = 0,31 do 
            tileData = memory.readword(addr+row*2 + col*64)
            tileId = bit.band(tileData,0xff)
	        collision = bit.rshift(tileData,8)
            tileColor = self:getTileColor(tileId,collision)
            gui.box(chunk_x_offs+row*4,chunk_y_offs+col*3,chunk_x_offs+row*4+5,chunk_y_offs+col*3+4,tileColor,0)
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