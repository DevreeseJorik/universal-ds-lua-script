Memory = {}

-- Memory reads outside the range will cause performance problems, 
-- so in such cases, no reads are performed and 0 is returned.
local function to_checked_read(func, size)
    return function(addr, dom)
        if addr < 0 or addr + size > 0x100000000 then
            return 0
        end
        return func(addr, dom)
    end
end

Memory.read_u32_be = to_checked_read(memory.read_u32_be, 4)
Memory.read_u32_le = to_checked_read(memory.read_u32_le, 4)
Memory.read_s32_be = to_checked_read(memory.read_s32_be, 4)
Memory.read_s32_le = to_checked_read(memory.read_s32_le, 4)
Memory.read_u16_be = to_checked_read(memory.read_u16_be, 2)
Memory.read_u16_le = to_checked_read(memory.read_u16_le, 2)
Memory.read_s16_be = to_checked_read(memory.read_s16_be, 2)
Memory.read_s16_le = to_checked_read(memory.read_s16_le, 2)
Memory.read_u8 = to_checked_read(memory.read_u8, 1)
Memory.read_s8 = to_checked_read(memory.read_s8, 1)
Memory.read_bytes_as_array = function(addr, length, dom)
    if addr < 0 or addr + length > 0x100000000 then
        return {}
    end
    return memory.read_bytes_as_array(addr, length, dom)
end
Memory.read_bytes_as_dict = function(addr, length, dom)
    if addr < 0 or addr + length > 0x100000000 then
        return {}
    end
    return memory.read_bytes_as_dict(addr, length, dom)
end

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

function Memory:read_multi(addr,size)
    addr = bit.band(addr,0xFFFFFFFF)
    local bytesArray = self.read_bytes_as_array(addr,size)
    local val = 0
    for i=1, size do
        val = val + bytesArray[i] * 256^(i-1)
    end
    return val
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

function Memory:write_u8(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.writebyte(addr-0x2000000, val)
end

function Memory:write_u16_be(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.write_u16_be(addr-0x2000000, val)
end

function Memory:write_u16_le(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.write_u16_le(addr-0x2000000, val)
end

function Memory:write_s16_le(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.write_s16_le(addr-0x2000000, val)
end

function Memory:write_u32_be(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.write_u32_be(addr-0x2000000, val)
end

function Memory:write_u32_le(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.write_u32_le(addr-0x2000000, val)
end

function Memory:write_s32_le(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.write_s32_le(addr-0x2000000, val)
end

function Memory:write_bytes_as_array(addr, val)
    if (addr < 0x2000000) then return end
    mainmemory.write_bytes_as_array(addr-0x2000000, val)
end

function Memory:getByteRange_be(table,index, size)
    local shift = (size - 1) * 8
    local value = 0
    for i = index, index + size - 1 do
        value = bit.bor(value, bit.lshift(tonumber(table[i+1]), shift))
        shift = shift - 8
    end
    return value
end

function Memory:getByteRange(table, index, size)
    local shift = 0
    local value = 0
    for i = index, index + size - 1 do
        value = bit.bor(value, bit.lshift(tonumber(table[i+1]), shift))
        shift = shift + 8
    end
    return value
end

function Memory:getByteRangeSigned(table, index, size)
    local value = self:getByteRange(table, index, size)
    if size == 2 then -- s16
        if bit.band(value, 0x8000) ~= 0 then
            value = -bit.band(bit.bnot(value), 0xFFFF) - 1
        end
    elseif size == 4 then -- s32
        if bit.band(value, 0x80000000) ~= 0 then
            value = -bit.band(bit.bnot(value), 0xFFFFFFFF) - 1
        end
    end
    return value
end