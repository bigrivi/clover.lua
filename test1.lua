local Product = require "Product"
local UserModel = require "UserModel"
local Glass = require "Glass"

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
print(userModel.age)
userModel.age = 22
local instance = infuse.injector:getValue("product")
local instance1 = infuse.injector:getValue("product")
print(instance1:toString())
instance1:printUserData()

local data = {s=10,k=nil}
for key,value in pairs(data) do
	print(key)
end
