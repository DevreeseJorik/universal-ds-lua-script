keyBinds = {
    keyConfig = {
        {keys = {"Shift","L"}, func = function() LoadLines:toggleLoadLines() end},
        {keys = {"Shift","G"}, func = function() LoadLines:toggleGridLines() end},
        {keys = {"Shift","C"}, func = function() LoadLines:toggleChunkLines() end},
        {keys = {"Shift","K"}, func = function() LoadLines:toggleMapLines() end},
        {keys = {"Shift","M"}, func = function() Chunks:toggleChunks() end},
        {keys = {"W"}, func = function() Cheats:toggleNoClip() end},
        {keys = {"Shift","Left"}, func = function() Movement:teleportLeft() end},
        {keys = {"Shift","Right"}, func = function() Movement:teleportRight() end},
        {keys = {"Shift","Up"}, func = function() Movement:teleportUp() end},
        {keys = {"Shift","Down"}, func = function() Movement:teleportDown() end},
    },

    keyConfigContinues = {
    }
}
