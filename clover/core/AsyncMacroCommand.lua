local class = require "clover.language.class"
local M = class()
function M:ctor()
	self.injector = {}
end 

function M:execute(evt)
	self.evt = evt
	self:nextCommand()
end 

function M:nextCommand()
	if #self.list>0 then
		local cl = self.list[1]
		table.remove(self.list,1)
		local command = self.injector:createInstance(cl)
		local function onCompleteHandler()
			self:nextCommand()
		end 
		command:setOnComplete(onCompleteHandler)
		command:execute(self.evt)
	end 
end 

function M:addSubCommand(cl)
	self.list = self.list or {}
	table.insert(self.list,cl)
end 

return M