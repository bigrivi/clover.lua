local DrawUtil = {}

function DrawUtil.drawPath(drawNode,points,color)
	if #points == 1 then
		return
	end 
	local start = points[1]
	for i=2,#(points) do
		local point = points[i]
		drawNode:drawLine(start,point,color)
		start = point
	end 
end 

return DrawUtil