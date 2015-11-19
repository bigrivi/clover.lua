
local table = setmetatable({}, {__index = _G.table})
function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

function table.contains(array,value)
	if table.isArray(array) then
		return table.indexOf(array,value)>=1
	else
		return array[value]
	end 
	return false
end 

function table.length(array)
	if table.isArray(array) then
		return #array
	else
		return #table.keys(array)
	end 
	return false
end 


function table.keyOf(src, val)
    for k, v in pairs(src) do
        if v == val then
            return k
        end
    end
    return nil
end

function table.isEmpty(t)
    if next(t) == nil then
        return true
    end
    return false
end


function table.copy(src, dest)
    dest = dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end


function table.deepCopy(src, dest)
    dest = dest or {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = table.deepCopy(v)
        else
            dest[k] = v
        end
    end
    return dest
end


function table.insertIfAbsent(t, o)
    if table.indexOf(t, o) > 0 then
        return false
    end
    t[#t + 1] = o
    return true
end


function table.insertElement(t, o)
    t[#t + 1] = o
    return true
end


function table.removeElement(t, o)
    local i = table.indexOf(t, o)
    if i > 0 then
        table.remove(t, i)
    end
    return i
end

function table.filter(t,predicate)
	local results = {}
	table.each(t,function(i,v)
		if predicate(i,v) then
			table.insert(results,v)
		end 
	end)
	return results
end 

table.select = table.filter

function table.each(t,iteratee)
	if table.isArray(t) then
		for i,v in ipairs(t) do
			iteratee(i,v,t)
		end 
	else
		for k,v in pairs(t) do
			iteratee(k,v,t)
		end 
	end 
end 

table.forEach = table.each

function table.map(t,iteratee)
	local results = {}
	if table.isArray(t) then
		for i,v in ipairs(t) do
			table.insert(results,iteratee(i,v,t))
		end 
	else
		for k,v in pairs(t) do
			table.insert(results,iteratee(k,v,t))
		end 
	end 
	return results
end 

table.collect = table.map


function table.values(t)
	local results = {}
	if table.isArray(t) then
		for i,v in ipairs(t) do
			table.insert(results,v)
		end 
	else
		for k,v in pairs(t) do
			table.insert(results,v)
		end 
	end 
	return results
end 

function table.keys(t)
	local results = {}
	if table.isArray(t) then
		return {}
	else
		for k,v in pairs(t) do
			table.insert(results,k)
		end 
	end 
	return results
end 


function table.every(t,predicate)
	local results = {}
	table.each(t,function(i,v)
		if not predicate(i,v) then
			return false
		end 
	end)
	return true
end 

table.all = table.every

function table.some(t,predicate)
	local results = {}
	table.each(t,function(i,v)
		if predicate(i,v) then
			return true
		end 
	end)
	return false
end 

table.any = table.some


function table.findIndex(t,predicate)
	local results = {}
	table.each(t,function(i,v)
		if predicate(i,v) then
			return i
		end 
	end)
	return -1
end 

function table.findKey(t,predicate)
	local results = {}
	table.each(t,function(i,v)
		if predicate(k,v) then
			return k
		end 
	end)
	return nil
end 

function table.find(t,predicate)
	local index
	if table.isArray(t) then
		index = table.findIndex(t,predicate)
		if index>=0 then
			return t[index]
		end 
	else
		index = table.findKey(t,predicate)~=nil
		if index~=nil then
			return t[index]
		end 
	end 
	return nil
end 

function table.first(t)
	return t[1]
end 

function table.last(t)
	return t[#t]
end 

function table.sample(t)
	local sample
	if table.isArray(t) then
		sample = table.copy(t)
	else
		sample = table.values(t)
	end
	local length = #sample
	local last = length
	for index=1,length do
		local rand = math.random(index,last)
		local temp = sample[index]
		sample[index] = sample[rand]
		sample[rand] = temp
	end 
	return sample
end 

table.shuffle = table.sample


function table.isMatch(t,attrs)
	local keys = table.keys(attrs)
	for _,key in pairs(keys) do
		if attrs[key]~=t[key] or t[key]==nil then
			return false
		end 
	end 
	return true
end 

function table.matcher(attrs)
	return function(t)
		return table.isMatch(t,attrs)
	end 
end



function table.bininsert(t, value, fcomp)
    -- Initialise compare function
    local fcomp = fcomp or function( a,b ) return a < b end
    --  Initialise numbers
    local iStart,iEnd,iMid,iState = 1,#t,1,0
    -- Get insert position
    while iStart <= iEnd do
        -- calculate middle
        iMid = math.floor( (iStart+iEnd)/2 )
        -- compare
        if fcomp( value,t[iMid] ) then
            iEnd,iState = iMid - 1,0
        else
            iStart,iState = iMid + 1,1
        end
    end
    table.insert( t,(iMid+iState),value )
    return (iMid+iState)
end

function table.isArray(t)
    if type(t)~="table" then return nil,"Argument is not a table! It is: "..type(t) end
    --check if all the table keys are numerical and count their number
    local count=0
    for k,v in pairs(t) do
        if type(k)~="number" then return false else count=count+1 end
    end
    --all keys are numerical. now let's see if they are sequential and start with 1
    for i=1,count do
        --Hint: the VALUE might be "nil", in that case "not t[i]" isn't enough, that's why we check the type
        if not t[i] and type(t[i])~="nil" then return false end
    end
    return true
end


function table.keyIterator(t)
	local i = 0;
	local keys;
	local len = table.length(t)
	if not table.isArray(t) then
		keys = table.keys(t)
	end 
	return function()
		i = i+1
		if i<=len then
			if not table.isArray(t) then
				return keys[i]
			end 
			return i
		end 
		return nil
	end 
end 

return table