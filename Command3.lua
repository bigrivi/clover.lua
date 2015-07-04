local class = clover.class
local logger = clover.Logger("Command3")

local M = class()


function M:init()
end 

function M:execute(event)
	logger:info("execute h3")
end 

return M