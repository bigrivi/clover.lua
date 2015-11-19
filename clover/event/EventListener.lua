
-- import
local class = require "clover.language.class"

-- class
local EventListener = class()


function EventListener:ctor(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority or 0
end


function EventListener:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

return EventListener