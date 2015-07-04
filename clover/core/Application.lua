local class = require "clover.language.class"
local Commands = require "clover.core.Commands"
local Mediators = require "clover.core.Mediators"
local EventDispatcher = require "clover.event.EventDispatcher"
local infuse = require "clover.util.infuse"
local M = class()

function M:init()
	infuse.injector:mapValue("instance",self)
	infuse.injector:mapValue("injector",infuse.injector)
	infuse.injector:mapClass("dispatcher",EventDispatcher,true)
	infuse.injector:mapClass("commands",Commands,true)
	infuse.injector:mapClass("mediators",Mediators,true)
	self.command = infuse.injector:getValue("commands")
    self.dispatcher = infuse.injector:getValue("dispatcher")
	self.injector = infuse.injector:getValue("injector")
	self.mediators = infuse.injector:getValue("mediators")
	self:start()
end 

function M:createPlugin(pluginClass,...)
	self.injector:createInstance(pluginClass,...)
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