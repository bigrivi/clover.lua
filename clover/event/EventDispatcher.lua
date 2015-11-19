

-- import
local table = require "clover.language.table"
local class = require "clover.language.class"
local Event = require "clover.event.Event"
local EventListener = require "clover.event.EventListener"

-- class
local EventDispatcher = class()

-- static variables
local EVENT_CACHE = {}

---
-- The constructor.
function EventDispatcher:ctor()
    self.eventListenersMap = {}
end


function EventDispatcher:addEventListener(eventType, callback, source, priority)
    assert(eventType)
    assert(callback)
	
	--check spliter
	if string.find(eventType,"|")~=nil then
		local spliter = string.split(eventType,"|")
		for i,v in ipairs(spliter) do
			self:addEventListener(v,callback,source,priority)
		end 
		return 
	end 

    self.eventListenersMap = self.eventListenersMap or {}

    if self:hasEventListener(eventType, callback, source) then
        return false
    end
    if not self.eventListenersMap[eventType] then
        self.eventListenersMap[eventType] = {}
    end

    local listeners = self.eventListenersMap[eventType]
    local listener = EventListener(eventType, callback, source, priority)

    for i, v in ipairs(listeners) do
        if listener.priority < v.priority then
            table.insert(listeners, i, listener)
            return true
        end
    end

    table.insert(listeners, listener)
    return true
end


function EventDispatcher:removeEventListener(eventType, callback, source)
    assert(eventType)
    self.eventListenersMap = self.eventListenersMap or {}
    local listeners = self.eventListenersMap[eventType] or {}
	if callback == nil then
		self.eventListenersMap[eventType] = nil
	end 

    for i, listener in ipairs(listeners) do
        if listener.type == eventType and listener.callback == callback and listener.source == source then
            table.remove(listeners, i)
            return true
        end
    end
    return false
end


function EventDispatcher:setEventListener(eventType, callback, source, priority)
    local propertyName = "_eventListener_" .. assert(eventType)
    local oldListener = self[propertyName]

    if oldListener and oldListener.callback == callback
        and oldListener.source == source
        and oldListener.priority == priority then
        return
    end

    if oldListener then
        self:removeEventListener(oldListener.type, oldListener.callback, oldListener.source)
    end

    if callback then
        local newListener = EventListener(eventType, callback, source, priority)
        self[propertyName] = newListener
        self:addEventListener(newListener.type, newListener.callback, newListener.source, newListener.priority)
    end
end


function EventDispatcher:hasEventListener(eventType, callback, source)
    assert(eventType)

    self.eventListenersMap = self.eventListenersMap or {}
    local listeners = self.eventListenersMap[eventType]
    if not listeners or #listeners == 0 then
        return false
    end

    if callback == nil and source == nil then
        return true
    end

    for i, listener in ipairs(listeners) do
        if listener.callback == callback and listener.source == source then
            return true
        end
    end
    return false
end


function EventDispatcher:dispatchEvent(event, data)
    if not self.eventListenersMap then
        return
    end

    local eventName = type(event) == "string" and event
    if eventName then
        event = EVENT_CACHE[eventName] or Event(eventName)
        EVENT_CACHE[eventName] = nil
    end

    assert(event.type)

    event.stopFlag = false
    event.target = self.eventTarget or self
    if data ~= nil then
        event.data = data
    end

    self:_dispatchEvents(event)

    if eventName then
        EVENT_CACHE[eventName] = event
    end
	--trigger all
	local allEvent = Event(Event.ALL)
	allEvent.data = event
	self:_dispatchEvents(allEvent)
    event.data = nil
    event.target = nil
    event:setListener(nil, nil)
	
	
end


function EventDispatcher:_dispatchEvents(event)
	local listeners = self.eventListenersMap[event.type] or {}
    for key, obj in ipairs(listeners) do
        if obj.type == event.type then
            event:setListener(obj.callback, obj.source)
            obj:call(event)
            if event.stopFlag == true then
                break
            end
        end
    end
end 

EventDispatcher.on = EventDispatcher.addEventListener
EventDispatcher.off = EventDispatcher.removeEventListener


function EventDispatcher:listerTo(target,eventType,callback)
	target:addEventListener(eventType,callback)
end 

function EventDispatcher:stopListening(target,eventType,callback)
	target:removeEventListener(eventType,callback)
end 
---
function EventDispatcher:clearEventListeners()
    self.eventlistenersMap = {}
end

return EventDispatcher
