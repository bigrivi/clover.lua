local class = require "clover.language.class"
local M = class()
function M:init()
	self.mdts = {}
	self.dispatcher = {}
	self.injector = {}
end 

function M:create(cl,target)
	local injector = self.injector:createChild()
	injector:mapValue("target",target)
	local mediator = injector:createInstance(cl)
	table.insert(self.mdts,mediator)
	return mediator
end 


function M:dispose()
	self.mdts = nil
	self.dispatcher = nil
	self.injector = nil
end 

return M