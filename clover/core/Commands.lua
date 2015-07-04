local class = require "clover.language.class"
local M = class()
function M:init()
	self.list = {}
	self.dispatcher = 0
	self.injector = 0
end 

function M:add(commandName,command)
	if self.list[commandName] then
		return
	end 
	self.list[commandName] = command
	local function handler(evt)
		local command = self.injector:createInstance(self.list[commandName])
		command:execute(evt)
	end 
	self.dispatcher:addEventListener(commandName,handler)
end 

function M:remove(commandName)
	self.list[commandName] = nil
end 

function M:get(commandName)
	return self.list[commandName]
end 

function M:has(commandName)
	return self.list[commandName]~=nil
end 

function M:dispose()
	self.dispatcher.removeEventListener(commandName,handler)
end 

return M







