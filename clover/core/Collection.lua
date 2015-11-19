local class = require("clover.language.class")
local EventDispatcher = require "clover.event.EventDispatcher"
local Event = require "clover.event.Event"
local Model = require "clover.core.Model"
local table = require("clover.language.table")

local M = class(EventDispatcher)

local methods = {'forEach', 'each', 'map', 'collect','filter', 'select', 'every', 'all', 'some', 'any','first','last','find','detect','isEmpty','sample','shuffle','indexOf','contains'}

function M:ctor(model,options)
	model = model or Model
	self.model = model
	self._models = {}
	self._length = 0
	self.injector = {}
	options = options or {}
	self.comparator = options.comparator
	self:reset()
end 

function M:add(models,options)
	self:set(models,options)
end 

function M:set(models,options)
	options = options or {}
    local at = options.at
	local attrs,existing,toAdds,model
	local sortable = self.comparator and (at == nil) and options.sort==true;
	toAdds = {}
	if not table.isArray(models) then
		models = {models}
	end 
	for k,v in ipairs(models) do
		attrs = v
		existing = self:get(attrs)
		if existing then --exist the model
			if self:_isModel(v) then
				attrs = v.attributes
			end 
			existing:set(attrs)
		else
			--add new
			model = self:_createModel(v)
			table.insert(toAdds,model)
			self._byId[model:get(self.model.idAttribute)] = model
			self:_addReference(model)
		end 
	end 
	self._length = self._length + #toAdds
	
	for i,model in ipairs(toAdds) do
		if at == nil then --默认向后插入
			table.insert(self._models,model)
		else
			table.insert(self._models,i-1+at,model)
		end 
	end 
	if #toAdds>0 and sortable then
		self:sort({silent = true})
	end 
	
	if not options.silent then
		for i,model in ipairs(toAdds) do
			model:dispatchEvent(Event(Event.ADD),model)
		end 
	end 
end 


function M:remove(models,options)
	options = options or {}
	if not table.isArray(models) then
		models = {models}
	end 
	local model,id,index
	for k,v in ipairs(models) do
		model = self:get(v)
		id = self:modelId(model.attributes)
		self._byId[id] = nil 
		self:_removeReference(model)
		index = self:indexOf(model)
		table.remove(self._models,index,1)
		self._length = self._length - 1
		if not options.silent then
			model:dispatchEvent(Event(Event.REMOVE),model)
		end
	end 
end 

function M:modelId(attrs)
	return attrs[self.model.idAttribute]
end 

function M:get(obj)
	if type(obj) == "number" then
		return self._byId[obj]
	end 
	if self:_isModel(obj) then
		return self._byId[obj:get(self.model.idAttribute)]
	end 
	return self._byId[obj[self.model.idAttribute]]
end 

function M:at(index)
	return self._models[index]
end 

function M:_isModel(model)
	return model.instanceOf and model:instanceOf(model)
end 

function M:_createModel(attrs)
	if self:_isModel(attrs) then
		return attrs
	end 
	return self.injector:createInstance(self.model,attrs)
end 

function M:_addReference(model)
	model:on(Event.ALL,handler(self,self._onModelEvet))
end 

function M:_removeReference(model)
	model:off(Event.ALL,handler(self,self._onModelEvet))
end 

function M:_onModelEvet(evt)
	local targetEvt = evt.data
	local evtType = targetEvt.type
	if evtType == Event.DESTROY then
		self:remove(targetEvt.target)
	end 
	self:dispatchEvent(targetEvt)
end 

function M:reset()
	self._length = 0
	self._models = {} --array
	self._byId = {} --hashMap
end 

--插入到尾部
function M:push(model,options)
	options = options or {}
	options.at = self:length()
	return self:add(model,options)
end 

--删除最后一个
function M:pop(options)
	local last = self:at(self:length())
	self:remove(last,options)
	return last
end 

--删除第一个
function M:shift(options)
	local first = self:at(1)
	self:remove(first,options)
	return first
end 

--添加到头
function M:unshift(model,options)
	option = option or {}
	option.at = 1
	return self:add(model,options)
end 

function M:sort(options)
	options = options or {}
	assert(self.comparator,"Cannot sort a set without a comparator")
	table.sort(self._models,function(a,b)
		return self.comparator(a.attributes,b.attributes)
	end)
	if not options.silent then
		self:dispatchEvent(Event(Event.SORT),self)
	end 
	return self
end 


function M:length()
	return self._length
end 


function M:where(attrs)
	local matcher = table.matcher(attrs)
	return self:filter(function(i,model)
			return matcher(model.attributes)
		end 
	)
end 


for i,method in ipairs(methods) do
	M[method] = function(self,...)
		return table[method](self._models,...)
	end
end 

return M
