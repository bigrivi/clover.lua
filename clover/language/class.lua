local table = require("clover.language.table")

local M = {}
setmetatable(M,M)


local setmetatableindex_
setmetatableindex_ = function(t, interface)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, interface)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            --mt.__index = interface.__index
            setmetatable(t, interface)
        elseif mt.__index ~= interface.__index then
            setmetatableindex_(mt, interface.__index)
        end
    end
end


M.__call = function(...)
	local clazz = {}
	local bases = {...}
	for i=#bases,1,-1 do
		table.copy(bases[i],clazz)
	end
	if #bases>0 then
		clazz.__super = bases[2]
	end
	clazz.__call = function(self,...)
		return self:__new(...)
	end
	clazz.__class = clazz
	clazz.__interface = {__index = clazz}
    setmetatable(clazz.__interface, clazz.__interface)
	setmetatable(clazz,clazz)
	return clazz
end

function M:__new(...)
	local obj = {}
	if self._cocos_class then
		obj = self._cocos_class:create()
		setmetatableindex_(obj, self.__interface)
	else
		setmetatable(obj,self.__interface)
	end 
	if obj.ctor then
		obj:ctor(...)
	end
	--obj.new = nil
	--obj.init = nil
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
    if self.__super then
        return self.__super:instanceOf(class)
    end
    return false
end

return M