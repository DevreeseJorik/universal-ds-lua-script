Memory = {}

function Memory:readascii(addr,length)
    length = length or 2
    text = ""
    for i=0, length-1 do
        text = text .. self:readchar(memory.readbyte(addr+i))
    end
    return text
end 

function Memory:readchar(ascii)
    if ascii == 0 then return " " end 
    return string.char(ascii) 
end