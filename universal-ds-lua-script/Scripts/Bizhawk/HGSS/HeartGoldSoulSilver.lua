function Game:init()
    self.generation = 4
    self:importFiles()
    MemoryState = MemoryState:new(0x2000BA8,0x20) -- alternative: 0x2000BAC
    Input = Input:new(keyBinds)
    LoadLines = LoadLines:new()
    PlayerData = PlayerData:new(0x25D60)
    
    ChunkData = ChunkData:new(0x24014)
    Chunks = Chunks:new()
end

function Game:importFiles()
    self.templateDir = self.templateDir .. "/Gen" .. self.generation
    dofile(self.templateDir .. "/Data/ChunkData.lua")
    dofile(self.templateDir .. "/Data/PlayerData.lua")
    dofile(self.templateDir .. "/Data/KeyBinds.lua")
    dofile(self.templateDir .. "/Repositories/LoadLines.lua")
    dofile(self.templateDir .. "/Repositories/MemoryState.lua")
    dofile(self.templateDir .. "/Repositories/Chunks.lua")
end

function Game:main()
    MemoryState:update() -- always execute this first to get base pointer
    Display:update()
    PlayerData:update()
    ChunkData:update()
    Input:runChecks()

    MemoryState:display()
    LoadLines:display()
    Chunks:display()
    self:displayGameInfo()
end

