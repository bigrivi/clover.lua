local StringUtil = require "clover.util.StringUtil" 

local DisplayObjectUtil = {}

--
-- create a cocos node
-- @param path real file system path
--

function DisplayObjectUtil.createNode(path)
	local searches = cc.FileUtils:getInstance():getSearchPaths()
    local searchPath = string.sub(path, 1, StringUtil.rfind(path, '/'))
    local cacheSearches = {}
    for key,value in pairs(searches) do
        cacheSearches[#cacheSearches + 1] = value
        -- choose endwith res or res/
        if string.find(value, "res", -4, true) ~= nil then
            
            cacheSearches[#cacheSearches + 1] = value..searchPath
            cacheSearches[#cacheSearches + 1] = value.."/ui"
        end
    end
    cc.FileUtils:getInstance():setSearchPaths(cacheSearches)
    local cocosNode = cc.CSLoader:createNode(path)
    if cocosNode:getTag() == -1 then
        cocosNode:setTag(1001) --设置默认值
    end
    local timeline = cc.CSLoader:createTimeline(path)
    if cocosNode then
        timeline:setTag(cocosNode:getTag())
        cocosNode:runAction(timeline)
        timeline:gotoFrameAndPause(0)
    end
   
    return cocosNode;
end 


-- 查找控件名字，可以使用'/'来划分路径层级查找，也可以直接指定一个名字，如果子控件没有找到则递归查找
function DisplayObjectUtil.getWidget(selector,root)
    local function search(parent,selector)
        if parent and selector then
            local control
            local realName = string.gsub(selector, '%.', '/')
            parent:enumerateChildren('//' .. realName, function(ret)
                control = ret
                return true
            end)
            return control
        end
    end
    
    local control
    -- [selector].*.[selector]
    local star_uffix = '%.%*%.'
    if string.find(selector,star_uffix) ~= nil then
        
        local parent = root
        local splits = string.split(selector,star_uffix)
        for _,strname in ipairs(splits) do
            parent = search(parent,strname)
        end
        control = parent
    else
        control = search(root,selector)
    end
    return control
end


function DisplayObjectUtil.clone(node)

    local newNode
    if node.clone then
        newNode = node:clone()
        DisplayObjectUtil.supplyClone(newNode,node)
    else
        local descript = node:getDescription()
        if string.find(descript,"Sprite") then
            local texture = node:getTexture()
            local textureRect = node:getTextureRect()
            newNode = cc.Sprite:createWithTexture(texture,textureRect)
            newNode:setFlippedX(node:isFlippedX())
            newNode:setFlippedY(node:isFlippedY())
        else
            newNode = cc.Node:create() 
        end
        
        newNode:setVisible(node:isVisible())
        newNode:setVisible(node:isVisible())
        newNode:setSkewX(node:getSkewX())
        newNode:setSkewY(node:getSkewY())
        newNode:setScaleX(node:getScaleX())
        newNode:setScaleY(node:getScaleY())
        newNode:setScaleZ(node:getScaleZ())
        newNode:setRotation(node:getRotation())
        newNode:setPosition(node:getPosition())
        newNode:setAnchorPoint(node:getAnchorPoint())
        newNode:setContentSize(node:getContentSize())
        newNode:setRotationSkewX(node:getRotationSkewX())
        newNode:setRotationSkewY(node:getRotationSkewY())
        newNode:setLocalZOrder(node:getLocalZOrder())
        
        local children = node:getChildren()
        for _,child in ipairs(children) do
        
            newNode:addChild(DisplayObjectUtil.clone(child))
        end
    end
    
    newNode:setTag(node:getTag())
    newNode:setName(node:getName())
    return newNode
end


function DisplayObjectUtil.supplyClone(node,cloneNode)

    local cloneChildren = cloneNode:getChildren()
    for index,cloneChild in ipairs(cloneChildren) do
        
		local tag = cloneChild:getTag()
		if -1 ~= tag then
			local child = node:getChildByTag(tag)
			if nil == child then
				child = DisplayObjectUtil.clone(cloneChild)
				node:addChild(child)
			else
				DisplayObjectUtil.supplyClone(child,cloneChild)
			end
			child:setOrderOfArrival(index)
			child:setLocalZOrder(cloneNode:getLocalZOrder())
		end
    end
end


function DisplayObjectUtil:playTimelineAnim(name,loop)
	local action 
	loop = loop or true
	if self:getNumberOfRunningActions() > 0 then
		action =  self:getActionByTag(self:getTag())
		action:play(name,loop)
	else
		error("unfound the timeline anim ",name)
	end
	
end 

return DisplayObjectUtil