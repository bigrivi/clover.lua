local class = require "class"
local M = class()

function M:init()
	self.listeners = {}
end

function M:add(listener)
	table.insert(self.listeners,listener)
end

function M:remove(listener)
	for i,value in ipairs(self.listeners) do
		if value == listener then
			table.remove(self.listeners,i)
			break
		end
	end
end

function M:dispatch(...)
	for i,listener in ipairs(self.listeners) do
		listener(...)
	end
end

function M:dispose()
   self.listeners = nil
end
return M