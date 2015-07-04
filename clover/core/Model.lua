-- import
local class = require("clover.language.class")
local EventDispatcher = require "clover.event.EventDispatcher"
local Event = require "clover.event.Event"

local M = class(EventDispatcher)
setmetatable(M,M)

M.__properies = {}

local call = function(self,...)
   local proxy = {}
   local obj = {
       __proxy = proxy,
       __index = self
   }
   local meta = {
       __index = self.propertyAccess,
       __newindex = self.propertyChange,
       __object = obj
   }
   setmetatable(proxy, meta)
   setmetatable(obj, obj)
   if proxy.init then
      proxy:init(...)
   end
   return proxy
end

function M:new(...)
	local obj = {__index = self,__call = call}
	setmetatable(obj,obj)
	if obj.init then
		obj:init(...)
	end
	return obj
end

function M:init()
	EventDispatcher:init()
end 

function M:propertyChange(key, value)
    local object = getmetatable(self).__object
	local oldValue = object[key]
    object[key] = value
	if oldValue~=value then
		print("property "..key.." change=>")
		--dump(value)
		self:dispatchEvent(Event(Event.PropertyChange),{property = key,oldValue = oldValue,newValue = value})
	end 
end


function M:propertyAccess(key)
    local object = getmetatable(self).__object
    return object[key]
end


function M:isProperty(key)
    return self.__properies[key] 
end


function M:setPropertyNames(...)
    for i, key in ipairs(...) do
        if type(key) == "string" then
            self:setPropertyName(key)
        elseif type(key) == "table" then
            self:setPropertyName(key.name)
        end
    end
end


function M:setPropertyName(key)
	self.__properies[key] = true
end

return M

