Cheats = {
}

function Cheats:new(language, o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    self:initAddresses(language)
    return o
end

function Cheats:initAddresses(language)
    self.addresses = self.addresses[language]
end

function Cheats:checkNoClip()
    self.noClip = Memory.read_u16_le(self.addresses.noClip) == 0x1C20
end

function Cheats:toggleNoClip()
    self:checkNoClip()
    if self.noClip then
        Memory:write_u8(self.addresses.noClip, 0x1000) -- 0x1000 enables no clip
    else
        Memory:write_u8(self.addresses.noClip, 0x1C20) -- 0x1C20 disables no clip
    end
end