local RatioUtil = {}

function RatioUtil.widthToHeight(size)
	return size.width/size.height
end 

function RatioUtil.heightToWidth(size)
	return size.height/size.width
end 

function RatioUtil.scale(size,percent,snapToPixel)
	snapToPixel = snapToPixel or true
	return RatioUtil._defineSize(size.width*percent,size.height*percent,snapToPixel)
end 


function RatioUtil.scaleWidth(size,height,snapToPixel)
	snapToPixel = snapToPixel or true
	return RatioUtil._defineSize(height*RatioUtil.widthToHeight(size),height,snapToPixel)
end 

function RatioUtil.scaleHeight(size,width,snapToPixel)
	snapToPixel = snapToPixel or true
	return RatioUtil._defineSize(width,width*RatioUtil.heightToWidth(size),snapToPixel)
end 

function RatioUtil.scaleToFill(size,bounds,snapToPixel)
	snapToPixel = snapToPixel or true
	local scaled = RatioUtil.scaleHeight(size,bounds.width,snapToPixel)
	if scaled.height<bounds.height then
		scaled = RatioUtil.scaleWidth(size,bounds.height,snapToPixel)
	end 
	return scaled
end 

function RatioUtil.scaleToFit(size,bounds,snapToPixel)
	snapToPixel = snapToPixel or true
	local scaled = RatioUtil.scaleHeight(size,bounds.width,snapToPixel)
	if scaled.height>bounds.height then
		scaled = RatioUtil.scaleWidth(size,bounds.height,snapToPixel)
	end 
	return scaled
end 

function RatioUtil._defineSize(width,height,snapToPixel)
	local rect = cc.size(width, height)
	rect.width = snapToPixel and math.round(width) or width
	rect.height = snapToPixel and math.round(height) or height
	return rect
end 

return RatioUtil
