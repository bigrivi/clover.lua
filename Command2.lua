local class = clover.class
local logger = clover.Logger("Command2")

local M = class()


function M:init()
end 

function M:execute(event)
	logger:info("execute h2")
end 

return M