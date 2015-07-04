local ss = 100
require "functions"
local Product = require "Product"
local UserModel = require "UserModel"
local Glass = require "Glass"
local Event = require "Event"

--local product1 = Product(100,"PC")
--print(product1:toString())
--local product2 = Product(101,"Phone")
--print(product2:toString())
----math.randomseed(os.time())
--local math = setmetatable({},{__index = _G.math})
--local status, err = pcall(function () error({code=121}) end)
--print(err.code) --> 121

--local status, err = pcall(function () a = 'a'+1 end)
--print(err)
--[[
local status, err = xpcall(
function () error("my error") end,
function() print(debug.traceback()) end
)
--print(status)
]]--

local infuse = require "infuse"
infuse.injector:mapValue("config",{ id = 120145,name = 'andy'})
infuse.injector:mapClass("product",Product,true)
infuse.injector:mapClass("userModel",UserModel,true)
local userModel = infuse.injector:getValueFromClass(UserModel)
userModel:addEventListener(Event.PropertyChange,function(evt)
	dump(evt.data)
end)
print(userModel.age)
print(userModel:instanceOf(UserModel))
local instance = infuse.injector:getValue("product")
local instance1 = infuse.injector:getValue("product")
print(instance1:toString())
instance1:printUserData()
print("-------------------")
local userModel1 = infuse.injector:getValue("userModel")
userModel1:addEventListener(Event.PropertyChange,function(evt)
	dump(evt.data)
end)
userModel1.age = 22
userModel1.age = 22
userModel1.age = 22
userModel1.age = 222
print(userModel1.age)
print(userModel1.name)



