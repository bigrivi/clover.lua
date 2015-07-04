require "functions"
clover = require "clover"
local UserModel = require "UserModel"
local StartUpCmd = require "StartUpCmd"
local FightCommand = require "FightCommand"
local TestPlugin = require "TestPlugin"

local AppMediator = require "AppMediator"
local AppView = require "AppView"

function clover.Application:start()
	self.injector:mapClass("userModel",UserModel,true)
	self.command:add("StartUp",StartUpCmd)
	self.command:add("Fight",FightCommand)
	self.dispatcher:dispatchEvent(clover.Event("StartUp"),{ name = "andy"})
	self.dispatcher:dispatchEvent(clover.Event("Fight"),{ round = 1})
	self:createPlugin(TestPlugin,1000,"andy")
	self.mediators:create(AppMediator,AppView())
	
end 


local app = clover.Application()

