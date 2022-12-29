keyBinds = {
    keyConfig = {
        {keys = {"Shift","L"}, func = function() LoadLines:toggleLoadLines() end},
        {keys = {"Shift","G"}, func = function() LoadLines:toggleGridLines() end},
        {keys = {"Shift","C"}, func = function() LoadLines:toggleChunkLines() end},
        {keys = {"Shift","K"}, func = function() LoadLines:toggleMapLines() end},
        {keys = {"Shift","M"}, func = function() Chunks:toggleChunks() end},
    },

    keyConfigContinues = {
        {keys = {"Shift","Down"},  func = function() ScriptHandler:incrementInitBytesToRead() end},
        {keys = {"Shift","Up"},    func = function() ScriptHandler:decrementInitBytesToRead() end},
        {keys = {"Shift","Space"}, func = function() ScriptHandler:resetInitBytesToRead() end},
    }
}
