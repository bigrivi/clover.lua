local ColorUtil = {}

function ColorUtil.construct(type,...)
	local arguments = {...}
	local length = #arguments
	if  length >10 then
		error("参数不允许超过10个")
	end 
	if length == 0 then
		return type()
	elseif length == 1 then
		return type(arguments[1])
	elseif length == 2 then
		return type(arguments[1],arguments[2])
	elseif length == 3 then
		return type(arguments[1],arguments[2],arguments[3])
	elseif length == 4 then
		return type(arguments[1],arguments[2],arguments[3],arguments[4])
	elseif length == 5 then
		return type(arguments[1],arguments[2],arguments[3],arguments[4],arguments[5])
	elseif length == 6 then
		return type(arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6])
	elseif length == 7 then
		return type(arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6],arguments[7])
	elseif length == 8 then
		return type(arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6],arguments[7],arguments[8])
	elseif length == 9 then
		return type(arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6],arguments[7],arguments[8],arguments[9])
	elseif length == 10 then
		return type(arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6],arguments[7],arguments[8],arguments[9],arguments[10])
	end 
end 

return ColorUtil