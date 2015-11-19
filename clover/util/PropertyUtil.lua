-- class
local PropertyUtil = {}

-- Property cache
PropertyUtil.SETTER_NAMES = {}


function PropertyUtil.setProperties(obj, properties, unpackFlag)
    for name, value in pairs(properties) do
        PropertyUtil.setProperty(obj, name, value, unpackFlag)
    end
end


function PropertyUtil.setProperty(obj, name, value, unpackFlag)
    local setterNames = PropertyUtil.SETTER_NAMES
    if not setterNames[name] then
        local setterName = "set" .. string.upper(string.sub(name,1,1)) .. (#name > 1 and string.sub(name,2) or "")
        setterNames[name] = setterName
    end

    local setterName = setterNames[name]
    local setter = assert(obj[setterName], "Not Found Property!" .. name)
    if not unpackFlag or type(value) ~= "table" or getmetatable(value) ~= nil then
        return setter(obj, value)
    else
        return setter(obj, unpack(value))
    end
end

return PropertyUtil