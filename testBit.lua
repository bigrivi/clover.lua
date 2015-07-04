local BitUtils = require "BitUtils"
local UserModel = require "UserModel"

local model = UserModel()


local state = BitUtils.bit(3)
state = BitUtils.setbit(state,10)
print(BitUtils.hasbit(state,10))
print(BitUtils.hasbit(state,3))

