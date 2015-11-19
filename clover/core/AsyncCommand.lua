local class = require "clover.language.class"
local M = class()
function M:ctor()
end 

function M:execute(evt)
	
end 

function M:setOnComplete(onComplete)
	self.onComplete = onComplete
end 

function M:commandComplete()
	self.onComplete()
end 
return M