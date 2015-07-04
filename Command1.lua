local class = clover.class
local logger = clover.Logger("Command1")

local M = class()


function M:init()
end 


function M:execute(event)
	logger:info("execute h1")
end 

return M