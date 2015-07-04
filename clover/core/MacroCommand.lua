local class = require "clover.language.class"
local M = class()
function M:init()
	self.injector = {}
end 

function M:execute(evt)
	for i,cl in ipairs(self.list) do
		local command = self.injector:createInstance(cl)
		command:execute(evt)
	end 
end 

function M:addSubCommand(cl)
	self.list = self.list or {}
	table.insert(self.list,cl)
end 

return M