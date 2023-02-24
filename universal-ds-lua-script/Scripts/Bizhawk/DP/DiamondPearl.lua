function Game:init()
    self.generation = 4
    self:importFiles()
    MemoryState = MemoryState:new(0x2002848,-4)
    Input = Input:new(keyBinds)
    LoadLines = LoadLines:new()
    PlayerData = PlayerData:new(0x24A14)

    ChunkData = ChunkData:new(0x229F0)
    Chunks = Chunks:new()

    MapData = MapData:new(0x22A84)
    Maps = Maps:new(558)

    EventTriggers = EventTriggers:new(0x23C80)

    ScriptData = ScriptData:new()
    ScriptHandler = ScriptHandler:new()

    Cheats = Cheats:new(self.language)
end

function Game:importFiles()
    self.templateDir = self.templateDir .. "/Gen" .. self.generation
    
    dofile(self.templateDir .. "/Repositories/MemoryState.lua")

    dofile(self.templateDir .. "/Data/PlayerData.lua")
    dofile(self.templateDir .. "/Repositories/LoadLines.lua")
    
    dofile(self.templateDir .. "/Data/ChunkData.lua")
    dofile(self.templateDir .. "/Repositories/Chunks.lua")

    dofile(self.templateDir .. "/Data/MapData.lua")
    dofile(self.templateDir .. "/Repositories/Maps.lua")

    dofile(self.templateDir .. "/Data/EventTriggerData.lua")
    --dofile(self.templateDir .. "/Repositories/EventTriggers.lua")

    dofile(self.dataDir .. "/ScriptData.lua")
    dofile(self.dir .. "/Repositories/ScriptHandler.lua")

    dofile(self.templateDir .. "/Repositories/Movement.lua")

    dofile(self.templateDir .. "/Data/KeyBinds.lua")
    dofile(self.dataDir .. "/KeyBinds.lua") -- extend keybinds with script specific keybinds

    dofile(self.templateDir .. "/Repositories/Cheats.lua")
    dofile(self.dataDir .. "/Cheats.lua") -- includes addresses
end

updateFrame = 0

function Game:main()
    MemoryState:update() -- always execute this first to get base pointer
    Display:update()
    PlayerData:update()
    ChunkData:update()
    MapData:update()
    ScriptData:update()

    Input:runChecks()

    MemoryState:display()
    ScriptHandler:display()
    
    Maps:display()
    ScriptHandler:display()

    if (updateFrame % 4 == 0) then
        LoadLines:display()
        Chunks:display()
    end
    Chunks:showDrawCount()

    self:displayGameInfo()
    updateFrame = updateFrame + 1
end

