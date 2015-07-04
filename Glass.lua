local class = require "class"
local Product = require "Product"
local super = Product
local M = class(super)
function M:init(id,name)
	self.id = id
	self.name = name
end

function M:poke()
	print("poke me...")
end

return M