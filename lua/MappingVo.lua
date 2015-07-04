local class = require "class"
local M = class()
function M:init(prop,value,cl,singleton)
	self.prop = prop
	self.value = value
	self.cl = cl
	self.singleton = singleton
end
return M