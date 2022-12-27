function Game:init()
    self:importFiles()
    MemoryState = MemoryState:new()
    Input = Input:new(keyBinds)
    ScriptHandler = ScriptHandler:new()
    LoadLines = LoadLines:new()
    PlayerData = PlayerData:new()
    ChunkData = ChunkData:new()
    Chunks = Chunks:new()
end

function Game:importFiles()
    dofile(self.dataDir .. "/ChunkData.lua")
    dofile(self.dataDir .. "/PlayerData.lua")
    dofile(self.dataDir .. "/ScriptData.lua")
    dofile(self.dataDir .. "/KeyBinds.lua")
    dofile(self.dir .. "/Repositories/ScriptHandler.lua")
    dofile(self.dir .. "/Repositories/LoadLines.lua")
    dofile(self.dir .. "/Repositories/MemoryState.lua")
    dofile(self.dir .. "/Repositories/Chunks.lua")
end

function Game:main()
    MemoryState:update() -- always execute this first to get base pointer
    Display:update()
    PlayerData:update()
    ChunkData:update()

    Input:runChecks()

    MemoryState:display()
    ScriptHandler:display()
    LoadLines:display()
    Chunks:display()
    self:displayGameInfo()
end

