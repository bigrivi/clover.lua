local class = require "clover.language.class"

local M = class()

-- Constraints
M.LEVEL_NONE = 0
M.LEVEL_INFO = 1
M.LEVEL_WARN = 2
M.LEVEL_ERROR = 3
M.LEVEL_DEBUG = 4


M.selector = {}
M.selector[M.LEVEL_INFO] = true
M.selector[M.LEVEL_WARN] = true
M.selector[M.LEVEL_ERROR] = true
M.selector[M.LEVEL_DEBUG] = true


M.CONSOLE_TARGET = function(...)
   local arg = {...}
   local message = table.concat(arg," ")
   print(os.date("%x",time).." "..os.date("%X",time).." "..message)
end


M.logTarget = M.CONSOLE_TARGET



function M:init(className)
	self.target = className or ""
end 

function M:info(...)
    if M.selector[M.LEVEL_INFO] then
        M.logTarget(self.target,"[INFO]", ...)
    end
end


function M:warn(...)
    if M.selector[M.LEVEL_WARN] then
        M.logTarget(self.target,"[WARN]", ...)
    end
end


function M:error(...)
    if M.selector[M.LEVEL_ERROR] then
        M.logTarget(self.target,"[ERROR]", ...)
    end
end


function M:debug(...)
    if M.selector[M.LEVEL_DEBUG] then
        M.logTarget(self.target,"[DEBUG]", ...)
    end
end

return M
