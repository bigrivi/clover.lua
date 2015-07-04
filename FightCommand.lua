local class = clover.class
local logger = clover.Logger("StartUpCmd")
local MacroCommand = clover.MacroCommand

local Command1 = require "Command1"
local Command2 = require "Command2"
local Command3 = require "Command3"

local M = class(MacroCommand)


function M:init()
	self.injector = {}
	self:addSubCommand(Command1)
	self:addSubCommand(Command2)
	self:addSubCommand(Command3)
end 

return M