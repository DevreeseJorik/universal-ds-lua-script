keyBinds.keyConfigContinues = {
        {keys = {"Shift","Down"},  func = function() ScriptHandler:incrementInitBytesToRead() end},
        {keys = {"Shift","Up"},    func = function() ScriptHandler:decrementInitBytesToRead() end},
        {keys = {"Shift","Space"}, func = function() ScriptHandler:resetInitBytesToRead() end},
    }
