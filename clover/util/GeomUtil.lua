
local ConversionUtil = require "clover.util.ConversionUtil" 

local GeomUtil = {}

function GeomUtil.distance(p1,p2)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    return math.sqrt(dx*dx+dy*dy)
end


function GeomUtil.midpoint(p1,p2)
    return cc.p((p1.x+p2.x)/2,(p1.y+p2.y)/2)
end

function GeomUtil.segmente(p1,p2,seg)

    return cc.p(p1.x + (p2.x-p1.x)*seg,p1.y + (p2.y-p1.y)*seg)
end


function GeomUtil.angle(p1,p2)
    
    if nil == p2 then
        return  math.deg(math.atan2(p1.y,p1.x));
    else
        return  math.deg(math.atan2(p2.y - p1.y,p2.x - p1.x));
    end
end

-- angle
function GeomUtil.direction(p1, p2)

    return (-GeomUtil.angle(p1,p2) - 90) % 360;
end

function GeomUtil.normalizeDegree(degree)
	degree = degree % 360;
	return (degree < 0) and (degree + 360) or degree;
end 

-- angle 两个角度之间的最小夹角
function GeomUtil.intersectionAngle(src, dst)
    
    local srcAngle = src % 360 
    local dstAngle = dst % 360 
    
    local angle = dstAngle - srcAngle
    if angle > 180 then
        angle = 360 - angle
    end
    return angle
end

--
function GeomUtil.intermediate(p1, p2, lenght)

    local dis = GeomUtil.distance(p1,p2)
    if dis < lenght then
        return p2
    end
    
    if GeomUtil.isEqual(p1.x, p2.x) then
        if(p2.y > p1.y) then
            return cc.pAdd(p1,cc.p(0,lenght))
        else
            return cc.pAdd(p1,cc.p(0,-lenght))
        end
    elseif GeomUtil.isEqual(p1.y, p2.y) then
        if(p2.x > p1.x) then
            return cc.pAdd(p1,cc.p(lenght,0)) 
        else
            return cc.pAdd(p1,cc.p(-lenght,0)) 
        end
    else
        local col = lenght / dis
        return cc.p(p1.x + (p2.x-p1.x) * col,p1.y + (p2.y-p1.y) * col)
    end
end

-- 二维向量旋转
function GeomUtil.vec2Rotate(vec2, deg)   

    local sin = math.sin(math.rad(deg))
    local cos = math.cos(math.rad(deg))

    local x = vec2.x * cos - vec2.y * sin
    local y = vec2.x * sin + vec2.y * cos

    return cc.p(x,y)
end

 -- 二维向量旋转
function GeomUtil.rotate(vec2, deg)  

    local sin = math.sin(math.rad(deg))
    local cos = math.cos(math.rad(deg))

    local x = vec2.x * cos - vec2.y * sin
    local y = vec2.x * sin + vec2.y * cos

    return cc.p(x,y)
end

--转笛卡尔坐标换为极坐标

function GeomUtil.polarToCartesian(p)
	local radius = math.sqrt (p.x*p.x + p.y*p.y);
	local theta = math.deg(math.atan2(p.y, p.x));
	return {r = radius, t = theta};
end 


--极坐标转换为笛卡尔坐标

function GeomUtil.polarToCartesian(p)
	local x = p.r * math.cos(math.rad(p.t))
	local y = p.r * math.sin(math.rad(p.t))
	return {x = x, y = y};
end 

return GeomUtil
