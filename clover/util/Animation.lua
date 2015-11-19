--[[
------------对Cocos2dx 动画的封装-----------------
---Use age

当前可用Action
moveBy       ==> 	cc.MoveBy
moveTo       ==> 	cc.MoveTo
scaleTo      ==> 	cc.ScaleTo
scaleBy      ==> 	cc.ScaleBy
rotateBy     ==> 	cc.RotateBy
rotateTo     ==> 	cc.RotateTo
fadeIn       ==> 	cc.FadeIn
fadeOut      ==> 	cc.FadeOut
tintBy       ==> 	cc.TintBy
tintTo       ==> 	cc.TintTo
blink        ==> 	cc.Blink
jumpBy       ==> 	cc.JumpBy
jumpTo       ==> 	cc.JumpTo
removeSelf   ==> 	cc.RemoveSelf
callFunc     ==>    cc.CallFunc

1 . 正常使用(线性)
 Animation(sprite):fadeOut(1.1):fadeIn(1.1)....,
2. 循环
 Animation(sprite):fadeOut(1.1):fadeIn(1.1):loop(循环次数)
3. 无穷循环
 Animation(sprite):fadeOut(1.1):fadeIn(1.1):yoyo()
3. 动画序列
  :sequence(
			new.Animation(sprite):fadeOut(1.1):fadeIn(1.1),
            new.Animation(sprite):rotateBy(360, 1.1):rotateBy(-360, 1.1),
            new.Animation(sprite):moveBy(300, 300, 1.1):moveBy(-300, -300, 1.1)
        )

3. 并行动画
  :parallel(
			Animation(sprite):fadeOut(1.1):fadeIn(1.1),
            Animation(sprite):rotateBy(360, 1.1):rotateBy(-360, 1.1),
            Animation(sprite):moveBy(300, 300, 1.1):moveBy(-300, -300, 1.1)
        )
4. 等待
   :wait(second)
   
5. 根据轨迹的运动
local path = {{x=0,y=0},{x=100,y=100},{x=300,y=450},{x=600,y=30},{x=700,y=250}}
for _i,pos in ipairs(path) do
	anim = anim:moveTo(pos.x,pos.y,1.3)
end
anim:play()

---------------------------------------------
]]--
local class = require "clover.language.class"

local ACTION_EASING = {}
ACTION_EASING["BACKIN"]           = {cc.EaseBackIn, 1}
ACTION_EASING["BACKINOUT"]        = {cc.EaseBackInOut, 1}
ACTION_EASING["BACKOUT"]          = {cc.EaseBackOut, 1}
ACTION_EASING["BOUNCE"]           = {cc.EaseBounce, 1}
ACTION_EASING["BOUNCEIN"]         = {cc.EaseBounceIn, 1}
ACTION_EASING["BOUNCEINOUT"]      = {cc.EaseBounceInOut, 1}
ACTION_EASING["BOUNCEOUT"]        = {cc.EaseBounceOut, 1}
ACTION_EASING["ELASTIC"]          = {cc.EaseElastic, 2, 0.3}
ACTION_EASING["ELASTICIN"]        = {cc.EaseElasticIn, 2, 0.3}
ACTION_EASING["ELASTICINOUT"]     = {cc.EaseElasticInOut, 2, 0.3}
ACTION_EASING["ELASTICOUT"]       = {cc.EaseElasticOut, 2, 0.3}
ACTION_EASING["EXPONENTIALIN"]    = {cc.EaseExponentialIn, 1}
ACTION_EASING["EXPONENTIALINOUT"] = {cc.EaseExponentialInOut, 1}
ACTION_EASING["EXPONENTIALOUT"]   = {cc.EaseExponentialOut, 1}
ACTION_EASING["IN"]               = {cc.EaseIn, 2, 1}
ACTION_EASING["INOUT"]            = {cc.EaseInOut, 2, 1}
ACTION_EASING["OUT"]              = {cc.EaseOut, 2, 1}
ACTION_EASING["RATEACTION"]       = {cc.EaseRateAction, 2, 1}
ACTION_EASING["SINEIN"]           = {cc.EaseSineIn, 1}
ACTION_EASING["SINEINOUT"]        = {cc.EaseSineInOut, 1}
ACTION_EASING["SINEOUT"]          = {cc.EaseSineOut, 1}

local Animation = class()


function Animation:ctor(target)
	self.target = target
	self.commands = {}
	self._loop = 1
	self._currentCommandIdx = 0
end

function Animation:newEasing(action, easingName, more)
	local key = string.upper(tostring(easingName))
	if string.sub(key, 1, 6) == "CCEASE" then
		key = string.sub(key, 7)
	end
	local easing
	if ACTION_EASING[key] then
		local cls, count, default = unpack(ACTION_EASING[key])
		if count == 2 then
			easing = cls:create(action, more or default)
		else
			easing = cls:create(action)
		end
	end
	return easing or action
end

function Animation:moveBy(moveX,moveY,sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.MoveBy:create(sec,cc.p(moveX,moveY))
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		return target:runAction(sequence)
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:moveTo(moveX,moveY,sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.MoveTo:create(sec,cc.p(moveX,moveY))
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:scaleTo(scaleX,scaleY,sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.ScaleTo:create(sec,scaleX,scaleY)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:scaleBy(scaleX,scaleY,sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.ScaleBy:create(sec,scaleX,scaleY)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:rotateBy(rotate,sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.RotateBy:create(sec,rotate)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:rotateTo(rotate,sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.RotateTo:create(sec,rotate)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:fadeIn(sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.FadeIn:create(sec)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:fadeOut(sec,easing)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.FadeOut:create(sec)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:wait(sec)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.DelayTime:create(sec)
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec)
	self:addCommand(command)
	return self
end

function Animation:removeSelf(isNeedCleanUp)
	isNeedCleanUp = isNeedCleanUp or true
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.RemoveSelf:create(isNeedCleanUp)
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun)
	self:addCommand(command)
	return self
end


function Animation:callFunc(cb)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.CallFunc:create(cb)
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun)
	self:addCommand(command)
	return self
end


function Animation:tintTo(red,green,blue,sec)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.TintTo:create(sec,red,green,blue)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:tintBy(red,green,blue,sec)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.TintBy:create(sec,red,green,blue)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:blink(count,sec)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.Blink:create(sec,count)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:jumpBy(sec, position, height, jumps)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.JumpBy:create(sec, position, height, jumps)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:jumpTo(sec, position, height, jumps)
	local actionFun = function(target,sec,easing,complateFuntion)
		local action = cc.JumpTo:create(sec, position, height, jumps)
		if easing  then
			action = self:newEasing(action,easing)
		end
		local callFuncAction = cc.CallFunc:create(complateFuntion)
		local sequence = cc.Sequence:create(action,callFuncAction)
		target:runAction(sequence)
		return sequence
	end
	local command = self:newActionCommand(actionFun,sec,easing)
	self:addCommand(command)
	return self
end

function Animation:addCommand(command)
	table.insert(self.commands,command)
	return self
end

function Animation:play(params)
	self._running = true
	self._stoped = false
	if params and params.onComplete then
		self._onComplete = params.onComplete
	end
	self:executeCommand(1)
end

function Animation:clear()
   self.commands = {}
   self._loop = 1
end

function Animation:stop()
	
	self._running = false
	self._stoped = true
	self._currentCommand.stop(self)    
	return self
end

function Animation:loop(value)
	self._loop = value
	return self
end

function Animation:yoyo()
	self._loop = -1
	return self
end

function Animation:parallel(...)
	local animations = {...}
	local command = self:newCommand(
		-- start
		function(obj, callback)
			local count = 0
			local max = #animations
			local completeHandler = function(e)
				count = count + 1
				if count >= max then
					callback(obj)
				end
			end
			for i, a in ipairs(animations) do
				a:play({onComplete = completeHandler})
			end
		end,
		-- stop
		function(obj)
			for i, a in ipairs(animations) do
				a:stop()
			end
		end
	)
	self:addCommand(command)
	return self
end


function Animation:sequence(...)
	local animations = {...}
	local currAnim = nil
	local completeHandler = nil
	local command = self:newCommand(
		-- start
		function(obj, callback)
			local count = 0
			local max = #animations
			completeHandler = function(e)
				count = count + 1
				if count > max then
					currAnim = nil
					callback(obj)
				else
					currAnim = animations[count]
					currAnim:play({onComplete = completeHandler})
				end
			end
			completeHandler()
		end,
		-- stop
		function(obj)
			currAnim:stop()
		end
	)
	self:addCommand(command)
	return self
end

function Animation:executeCommand(index)
	self._currentCommandIdx = index
	local command = self.commands[self._currentCommandIdx]
	self._currentCommand = command
	if command then
		command.play(self,self.commandComplete)
	end
end

function Animation:commandComplete()
	if self._currentCommandIdx<#self.commands then
		self:executeCommand(self._currentCommandIdx+1)
	else
		if self._loop>=1 or self._loop==-1  then
			if self._loop>0 then
				self._loop = self._loop-1
				if self._loop==0 then
					if self._onComplete then 
					   self._onComplete(event) 
					end
					return
				end
			end
			self:executeCommand(1)
			
		end
	end
end

function Animation:newCommand(playFunc,stopFunc)
	local emptyFunc = function()end
	stopFunc = stopFunc or emptyFunc
	return {play=playFunc,stop=stopFunc}
end

function Animation:newActionCommand(actionFunc,sec,easing)
	local action = nil
	return self:newCommand(
	function(obj,callBack)
		local completeFunc = function()
			callBack(obj)
		end
			action = actionFunc(self.target,sec,easing,completeFunc)
	end
	,
	function(obj)
		self.target:stopAction(action)
	end
	)
end

return Animation
