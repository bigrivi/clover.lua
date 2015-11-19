-- import
local class = require("clover.language.class")
local EventDispatcher = require "clover.event.EventDispatcher"
local Event = require "clover.event.Event"

local M = class(EventDispatcher)
local table = require("clover.language.table")
M.idAttribute = "id"

function M:ctor(defaults)
	M.__super.ctor(self)	
	self.attributes = {}
	self._prevAttributes = {}
	self:set(defaults)
end 

function M:set(key,value)
	assert(key,"key is null")
	local attrs,changes
	if type(key) == "table" then
		attrs = key
	else
		attrs = {}
		attrs[key] = value
	end 
	local changing = self.changing
	if not self.changing then
		self._prevAttributes = table.copy(self.attributes)
		self.changed = {}
	end 
	self.changing = true
	changes = {}
	for k,v in pairs(attrs) do
		local current = self.attributes[k]
		if current~=v then
			table.insert(changes,k)
		end 
	end 
	if #changes>0 then
		for i,attr in ipairs(changes) do
			self:dispatchEvent(clover.Event(clover.Event.CHANGE..":"..attr),attrs[attr])
			self.attributes[attr] = attrs[attr]
		end 
	end 
	if changing then
		return self
	end 
	self._pending = {}
	while(self._pending)
	do
		self._pending = false
		self:dispatchEvent(clover.Event(clover.Event.CHANGE,self))
	end
	self.changing = false
	self._pending = false
	return self
end 


function M:unset(key,value)
	self:set(key,value)
end 

function M:clear()
	self.attributes = {}
end 

function M:clone()
	return self.__class(table.copy(self.attributes))
end 


function M:get(attr)
	return self.attributes[attr]
end 

function M:has(attr)
	return self:get(attr)~=nil 
end 

function M:destroy()
	self:dispatchEvent(clover.Event(Event.DESTROY,self))
end 

function M:previous(attr)
	return self._prevAttributes[attr]
end 

return M

