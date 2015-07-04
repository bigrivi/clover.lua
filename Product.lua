local class = require "class"
local M = class()
M.config = 0 -- require inject  value
M.userModel = 0 --requrei inject value

function M:init(id,name)
	self.id = id
	self.name = name
end

function M:toString()
	--return "toString()"
	return string.format("ID=>%d,Name=>%s",self.config.id,self.config.name)
end

function M:printUserData()
	print("======== User Data=========")
	print(string.format("ID=>%d,Name=>%s,Age=>%s",self.userModel.id,self.userModel.name,self.userModel.age))
end

return M