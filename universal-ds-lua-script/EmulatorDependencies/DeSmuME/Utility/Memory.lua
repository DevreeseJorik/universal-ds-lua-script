Memory = {}

Memory.read_u32_be = memory.readdword
Memory.read_u32_le = memory.readdword
Memory.read_s32_be = memory.readdword
Memory.read_s32_le = memory.readdword
Memory.read_u16_be = memory.readword
Memory.read_u16_le = memory.readword
Memory.read_s16_be = memory.readword
Memory.read_s16_le = memory.readword
Memory.read_u8 = memory.readbyte
Memory.read_s8 = memory.readbyte
Memory.read_bytes_as_array = memory.readbyterange

function Memory:read_8(addr,dom,signed)
    if signed then return self:read_s8(addr,dom) end
    return self:read_u8(addr,dom)
end

function Memory:read_16(addr,dom,signed,bigEndian)
    if bigEndian then 
        if signed then return self:read_s16_be(addr,dom) end
        return self:read_u16_be(addr,dom)
    end
    if signed then return self:read_s16_le(addr,dom) end
    return self:read_u16_le(addr,dom)
end

function Memory:read_32(addr,dom,signed,bigEndian)
    if bigEndian then 
        if signed then return self:read_s32_be(addr,dom) end
        return self:read_u32_be(addr,dom)
    end
    if signed then return self:read_s32_le(addr,dom) end
    return self:read_u32_le(addr,dom)
end

function Memory:readchar(ascii)
    if ascii == 0 then return " " end 
    return string.char(ascii) 
end

function Memory:readascii(addr,length)
    length = length or 2
    text = ""
    for i=0, length-1 do
        text = text .. self:readchar(Memory.read_u8(addr+i))
    end
    return text
end 