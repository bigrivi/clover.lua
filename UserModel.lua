local Model = clover.Model

local M = Model()
M:setPropertyName("id")
M:setPropertyName("name")
M:setPropertyName("age")
function M:init()
	self:loadData()
end

function M:loadData()
	local data = require "UserData"
	self.id = data.id
	self.name = data.name
	self.age = data.age
end

return M