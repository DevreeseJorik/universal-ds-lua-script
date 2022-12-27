ScriptHandler = {

}

function ScriptHandler:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ScriptHandler:detectExecution()

end

function ScriptHandler:disassembleScriptData()

end

function ScriptHandler:display()
    gui.text(0,60,"Next Script Command: " .. Utility:format(ScriptData.nextScriptCommandAddr,8))
    gui.text(0,80,"Script Data")
    gui.text(10,100,"Jump Table: 0x" .. Utility:format(ScriptData.jumpTableAddr,1))
    gui.text(10,120,"Jump Amount: 0x" .. Utility:format(ScriptData.jumpAmount,1))
    gui.text(10,140,"Start of Script: 0x" .. Utility:format(ScriptData.startOfScriptAddr,1))
end