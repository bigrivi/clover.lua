local NumberUtil = {}

function NumberUtil.round(number)
    
    local num = math.floor(number)
    if number - num > 0.499995 then
        return num + 1
    end
    return num
end

-- 判断浮点数是否相等
function NumberUtil.isEqual(number1,number2)
    
    if type(number1) == "number" and type(number2) == "number" then
        return NumberUtil.round(number1*10000) == NumberUtil.round(number2*10000)
    end
    return false
end


function NumberUtil.randomWithinRange(min, max) 
	return min + (math.random() * (max - min));
end 
		
function NumberUtil.randomIntegerWithinRange(min, max) 
	return math.floor(math.random() * (1 + max - min) + min);
end 

function NumberUtil.addLeadingZero(value)
	if value < 10 then
		return '0' + value 	
    else		
		return tostring(value)
	end 
end 

return NumberUtil
