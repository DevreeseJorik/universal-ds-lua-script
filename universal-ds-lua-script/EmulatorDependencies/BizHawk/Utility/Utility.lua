Utility = {}

function Utility:format(val,len)
    len = len or 1
    return string.format("%0"..len.."X", bit.band(4294967295, val))
end

function Utility:isPointer(addr,dom)
    dom = dom or "main"
    if dom == "main" then
        return (addr >= 0x02000000) and (addr < 0x03000000)
    end
end 
