Utility = {}

function Utility:format(val,len)
    len = len or 1
    return string.format("%0"..len.."X", bit.band(4294967295, val))
end