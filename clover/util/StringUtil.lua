local StringUtil = {}

function StringUtil.rfind(s, text, fromIndex, plain)
    fromIndex = fromIndex or 1;
    plain = plain or false
    local temp = string.reverse(s);
    local index = string.find(temp, text, fromIndex, plain);
    if index == nil then return nil end
    return #s - index + 1
end

function StringUtil.guid()
	math.randomseed(os.time()) 
    local S4 = function () 
        return string.upper(string.sub(string.format("%04X",(1+math.random())*0xffffff),2))
    end
    return S4() .. S4() .. S4() .. S4() .. S4() .. S4() .. S4() .. S4()
end 


return StringUtil