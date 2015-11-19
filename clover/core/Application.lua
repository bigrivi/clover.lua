local class = require "clover.language.class"
local Commands = require "clover.core.Commands"
local EventDispatcher = require "clover.event.EventDispatcher"
local infuse = require "clover.util.infuse"
local M = class()

function M:ctor()
	infuse.injector:mapValue("facade",self)
	infuse.injector:mapValue("injector",infuse.injector)
	infuse.injector:mapClass("dispatcher",EventDispatcher,true)
	infuse.injector:mapClass("commands",Commands,true)
	self.command = infuse.injector:getValue("commands")
    self.dispatcher = infuse.injector:getValue("dispatcher")
	self.injector = infuse.injector:getValue("injector")
	self:start()
end 

function M:createPlugin(pluginClass,...)
	local instance = self.injector:createInstance(pluginClass,...)
	return instance
end 

function M:createView(viewClass,node,viewOption)
	local injector = self.injector:createChild()
	injector:mapValue("el",node)
	if viewOption then
		injector:mapValue("viewOption",viewOption)
	end 
	local instance = injector:createInstance(viewClass)
	return instance
end 


function M:start()
	
end 

function M:dispose()
	infuse.injector:removeMapping("instance")
	infuse.injector:removeMapping("injector")
	infuse.injector:removeMapping("dispatcher")
	infuse.injector:removeMapping("commands")
end 

return M