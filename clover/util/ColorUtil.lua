local ColorUtil = {}
local bit = require("bit")

function ColorUtil.getColor(r , g , b , a ) 
	-- (a << 24) | (r << 16) | (g << 8) | b;
	a = bit.lshift(a,24)
	r = bit.lshift(r,16)
	g = bit.lshift(g,8)
	b = b
	return bit.bor(a,r,g,b)
end 
		
		
function ColorUtil.getARGB(color) 
	local c = {}
	c.a = bit.band(bit.rshift(color,24),0xFF)
	c.r = bit.band(bit.rshift(color,16),0xFF)
	c.g = bit.band(bit.rshift(color,8),0xFF)
	c.b = bit.band(color,0xFF)
	return c
end 

function ColorUtil.getRGB(color ) 
	local c = {}
	c.r = bit.band(bit.rshift(color,16),0xFF)
	c.g = bit.band(bit.rshift(color,8),0xFF)
	c.b = bit.band(color,0xFF)
	return c
end 

function ColorUtil.getHexStringFromARGB(a,r,g,b)
	local aa = string.format("%02x",a)
	local rr = string.format("%02x",r)
	local gg = string.format("%02x",g)
	local bb = string.format("%02x",b)
	return "0x"..string.upper(aa..rr..gg..bb)
end 

function ColorUtil.getHexStringFromRGB(r,g,b)
	local rr = string.format("%02x",r)
	local gg = string.format("%02x",g)
	local bb = string.format("%02x",b)
	return "0x"..string.upper(rr..gg..bb)
end 
		
return ColorUtil
