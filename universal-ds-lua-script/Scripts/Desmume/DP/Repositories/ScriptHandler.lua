ScriptHandler = {

}

function ScriptHandler:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ScriptHandler:disassembleScriptData()

end

function ScriptHandler:display()

end