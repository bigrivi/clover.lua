require "functions"

local Commands = require "Commands"
local StartUpCmd = require "StartUpCmd"
local EventDispatcher = require "EventDispatcher"
local Event = require "Event"
local infuse = require "infuse"
local UserModel = require "UserModel"

infuse.injector:mapValue("injector",infuse.injector)
infuse.injector:mapClass("dispatcher",EventDispatcher,true)
infuse.injector:mapClass("commands",Commands,true)
infuse.injector:mapClass("userModel",UserModel,true)

local command = infuse.injector:getValue("commands")
local dispatcher = infuse.injector:getValue("dispatcher")
command:add("StartUp",StartUpCmd)
dispatcher:dispatchEvent(Event("StartUp"),{ name = "andy"})