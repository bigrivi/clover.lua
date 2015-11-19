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


M.CONSOLE_TARGET = function(level,category,message,...)
   local args = {...}
   local date = os.date("%m",time).."/"..os.date("%d",time).."/"..os.date("%Y",time)
   local time = os.date("%X",time)
   message = string.format(message,...)
   local log = {date,time,level,category,message}
   print(table.concat(log," "))
end


M.logTarget = M.CONSOLE_TARGET



function M:ctor()
	local category = debug.getinfo(3).source
	self.category = "["..category.."]" or ""
end 

function M:info(message,...)
    if M.selector[M.LEVEL_INFO] then
        M.logTarget("[INFO]",self.category,message, ...)
    end
end


function M:warn(message,...)
    if M.selector[M.LEVEL_WARN] then
        M.logTarget("[WARN]",self.category,message, ...)
    end
end


function M:error(message,...)
    if M.selector[M.LEVEL_ERROR] then
        M.logTarget("[ERROR]",self.category,message, ...)
    end
end


function M:debug(message,...)
    if M.selector[M.LEVEL_DEBUG] then
        M.logTarget("[DEBUG]",self.category,message, ...)
    end
end

return M
