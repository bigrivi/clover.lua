local Signal = require "Signal"

local onComponentAdd = Signal()

local function handlerComponentAdd(name)
	print("onComponentAdd:"..name)
end
onComponentAdd:add(handlerComponentAdd)
onComponentAdd:dispatch("Test")
onComponentAdd:dispatch("Test")
onComponentAdd:dispatch("Test")
onComponentAdd:dispatch("Test")


