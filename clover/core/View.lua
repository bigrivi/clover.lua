local class = require("clover.language.class")
local EventDispatcher = require "clover.event.EventDispatcher"
local Event = require "clover.event.Event"

local M = class(EventDispatcher)


function M:ctor()
	-- inject 
	self.el = cc.Node:create()
	self.viewOption = {}
	self.facade = {}
	self.dispatcher = {}
	self.injector = {}
end 

function M:getItem(name)
	return clover.utils.DisplayObjectUtil.getWidget(name,self.el)
end 

function M:bindEvents(events)
	for key,handler in pairs(events) do
		local spliter = string.split(key," ")
		if spliter[1] == "touch" then --暂时只支持touch事件
			local eventType = spliter[1]
			local target = self:getItem(spliter[2])
			if target then
				target:addTouchEventListener(
					function (sender,type)
						if type == ccui.TouchEventType.ended then
							self[handler](self)
						end
					end
				)
			end 
		end 
	end 
end 

function M:remove()
	self.destroy()
	self.el:removeFromParent()
end 

function M:render()
	return self
end 


return M