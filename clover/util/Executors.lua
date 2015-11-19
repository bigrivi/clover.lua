local Executors = {}

function Executors.setInterval(handler,delay, repeatCount)
	repeatCount = repeatCount or 0
	delay = delay or 0
	local currentCount = repeatCount
	local schedulerId
	schedulerId =  cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		if repeatCount > 0 then
			currentCount = currentCount - 1
			if currentCount<=0 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerId)
			end 
		end 
		handler(currentCount)
	end,delay,false)
	return schedulerId
end 

function Executors.clearInterval(schedulerId)
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerId)
end 

function Executors.setTimeOut(handler,delay)
	local schedulerId
	schedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerId)
		handler()
	end,delay,false)
end 


return Executors