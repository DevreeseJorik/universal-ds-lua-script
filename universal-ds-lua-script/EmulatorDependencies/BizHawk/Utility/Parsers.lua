Parser = {

}

-- TODO: modify this so values of type "number" and "bool" are not converted to strings.
function Parser.encode(tbl)
    local str = ""
    if Parser.isNumeric(tbl) then
        return Parser.encodeNumeric(tbl)
    else
        for k, v in pairs(tbl) do
            local key = '"' .. k .. '"'
            if type(v) == "table" then
                str = str .. key .. ":" .. Parser.encode(v) .. ","
            elseif type(v) == "string" then
                str = str .. key .. ":" .. '"' .. v .. '"' .. ","
            elseif type(v) == "boolean" then
                str = str .. key .. ":" .. Parser.toStringJson(v) .. ","
            elseif type(v) == "number" then
                str = str .. key .. ":" .. v .. ","
            end
        end
        return "{" .. string.sub(str, 1, -2) .. "}"
    end
end

function Parser.encodeNumeric(tbl)
    local str = ""
    local startId = 1
    local endId = #tbl
    if tbl[0] ~= nil then
        startId = 0
    end
    for i = startId, endId do
        local v = tbl[i]
        if type(v) == "table" then
            str = str .. Parser.encode(v) .. ","
        elseif type(v) == "string" then
            str = str .. '"' .. v .. '"' .. ","
        elseif type(v) == "boolean" then
            str = str .. Parser.toStringJson(v) .. ","
        elseif type(v) == "number" then
            str = str .. v .. ","
        end
    end
    return "[" .. string.sub(str, 1, -2) .. "]"
end


function Parser.isNumeric(tbl)
    for k, v in pairs(tbl) do
        if (type(k) ~= "number") then
            return false
        end
    end
    return true
end


function Parser.toStringJson(var)
    if var == nil then
        return "null"
    elseif type(var) == "table" then
        return jsonParser.encode(var) 
    elseif type(var) == "boolean" then
        if var then 
                return "true" 
            else 
                return "false"
        end
    elseif type(var) == "string" then 
        return var
    else
        return tostring(var)
    end
end

function Parser.toString(var)
    if var == nil then
        return "null"
    elseif type(var) == "table" then
        return jsonParser.encode(var) 
    elseif type(var) == "boolean" then
        if var then 
                return "True" 
            else 
                return "False"
        end
    elseif type(var) == "string" then 
        return var
    else
        return tostring(var)
    end
end

function Parser.fromString(str, removeTrailingSpaces)
    if removeTrailingSpaces then
        str = string.gsub(str, "^%s*(.-)%s*$", "%1")
    end
    if str == "null" then
        return nil
    elseif str == "true" then
        return true
    elseif str == "false" then
        return false
    elseif tonumber(str) ~= nil then
        return tonumber(str)
    else
        return str
    end
end


function Parser.splitData(data, chars)
    chars = chars or '|'
    -- Split data into parts
    local splitData = {}
	for substring in string.gmatch(data, "[^" .. chars .. "]+") do
		table.insert(splitData, substring)
	end
    -- return parts
    return splitData
end


function Parser.getKeyValuePair(data, splitChars, replaceChars,removeTrailingSpaces)
    splitChars = splitChars or '|'
    replaceChars = replaceChars or ''
    if removeTrailingSpaces == nil then  removeTrailingSpaces = true end
    -- Split data into parts
    data = string.gsub(data, replaceChars, "")
    local splitData = Parser.splitData(data, splitChars)
    local newTable = {}
    local tempKey

    for key, value in pairs(splitData) do
        key = tonumber(key)
        -- Check if the current key is odd
        if key % 2 == 1 then
            tempKey = Parser.fromString(value, removeTrailingSpaces)
        -- Check if the current key is even
        else
            newTable[tempKey] = Parser.fromString(value, removeTrailingSpaces)
        end
    end
    -- return parts
    return newTable
end

-- similar to getKeyValuePair, but the key is now an index, the value is the key-value pair in a table
function Parser.getKeyValuePairIndexed(data,splitChars,replaceChars,removeTRailingSpaces)
    splitChars = splitChars or '|'
    replaceChars = replaceChars or ''
    if removeTRailingSpaces == nil then  removeTRailingSpaces = true end
    -- Split data into parts
    data = string.gsub(data, replaceChars, "")
    local splitData = Parser.splitData(data, splitChars)
    local newTable = {}
    local tempKey

    for key, value in pairs(splitData) do
        key = tonumber(key)
        -- Check if the current key is odd
        if key % 2 == 1 then
            tempKey = Parser.fromString(value, removeTRailingSpaces)
        -- Check if the current key is even
        else
            newTable[key/2] = {tempKey, Parser.fromString(value, removeTRailingSpaces)}
        end
    end
    -- return parts
    return newTable
end

function Parser.doTablesMatch( a, b )
    if (a == nil) and (b == nil) then
        return true
    end
    if a == nil or b == nil then
        return false
    end
    return Parser.encode(a) == Parser.encode(b)
end