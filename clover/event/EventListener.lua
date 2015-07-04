
-- import
local class = require "clover.language.class"

-- class
local EventListener = class()

---
-- The constructor.
-- @param eventType The type of event.
-- @param callback The callback function.
-- @param source The source.
-- @param priority The priority.
function EventListener:init(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority or 0
end

---
-- Call the event listener.
-- @param event Event
function EventListener:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

return EventListener