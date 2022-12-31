keyBinds = {
    keyConfig = {
        {keys = {"shift","L"}, func = function() LoadLines:toggleLoadLines() end},
        {keys = {"shift","G"}, func = function() LoadLines:toggleGridLines() end},
        {keys = {"shift","C"}, func = function() LoadLines:toggleChunkLines() end},
        {keys = {"shift","K"}, func = function() LoadLines:toggleMapLines() end},
        {keys = {"shift","M"}, func = function() Chunks:toggleChunks() end},
    },

    keyConfigContinues = {
    }
}
