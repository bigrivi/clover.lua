local M = {}
setmetatable(M,M)

local call = function(self,...)
	return self:new(...)
end

M.__call = function(...)
	local clazz = {}
	local base = {...}
	for i=#base,1,-1 do
		for k,v in pairs(base[i]) do
			clazz[k] = v
		end
	end
	if #base>0 then
		clazz.__base = base[1]
	end
	clazz.__call = call
	clazz.__class = clazz
	setmetatable(clazz,clazz)
	return clazz
end

function M:new(...)
	local obj = {__index = self}
	setmetatable(obj,obj)
	if obj.init then
		obj:init(...)
	end
	obj.new = nil
	obj.init = nil
	return obj
end

function M:instanceOf(class)
    if self == class then
        return true
    end
	
	if self.__class == class then
        return true
    end
	
    if self.__index == class then
        return true
    end
    if self.__base then
        return self.__base:instanceOf(class)
    end
    return false
end

return M