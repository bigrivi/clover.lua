local class = clover.class
local logger = clover.Logger("StartUpCmd")

local M = class()


function M:init()
	--inject
	self.userModel = {}
end 


function M:execute(event)
	logger:info("app startUp "..self.userModel.name)
end 

return M