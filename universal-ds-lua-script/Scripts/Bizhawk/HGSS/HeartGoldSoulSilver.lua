function Game:init()
    self.generation = 4
    self:importFiles()
    MemoryState = MemoryState:new(0x2000BA8,0x20) -- alternative: 0x2000BAC
    Input = Input:new(keyBinds)
    LoadLines = LoadLines:new()
    PlayerData = PlayerData:new(0x25D60)
    
    ChunkData = ChunkData:new(0x24014)
    ChunkData.colorMappingLUT[6] = ChunkData.colorMapping.trees.color
    Chunks = Chunks:new()

    MapData = MapData:new(0x24110)
    Maps = Maps:new(563) -- TODO: find out how many maps there are (563 is the number of maps in Platinum)

    NPCData = NPCData:new(0x25BC8,0x25EAC,0x12C)
    NPCs = NPCs:new()

    EventTriggersData = EventTriggersData:new(0x25114)
    EventTriggers = EventTriggers:new()

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
    dofile(self.dataDir .. "/MapData.lua") -- extend map data with color mapping for HGSS

    dofile(self.templateDir .. "/Data/NPCData.lua")
    dofile(self.templateDir .. "/Repositories/NPCs.lua")

    dofile(self.templateDir .. "/Data/EventTriggerData.lua")
    dofile(self.templateDir .. "/Repositories/EventTriggers.lua")

    dofile(self.templateDir .. "/repositories/BoundingBoxes.lua")

    dofile(self.templateDir .. "/Repositories/Maps.lua")
    
    dofile(self.templateDir .. "/Repositories/Movement.lua")
    
    dofile(self.templateDir .. "/Data/KeyBinds.lua")

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
    EventTriggersData:update()
    Input:runChecks()

    MemoryState:display()
    Maps:display()

    if (updateFrame % 4 == 0) then
        NPCData:update()
        LoadLines:display()
        Chunks:display()
        BoundingBoxes:display()
    end
    Chunks:showDrawCount()

    self:displayGameInfo()
    updateFrame = updateFrame + 1
end
