local class = require "class"
local MappingVo = require "MappingVo"
local infuse = {}
infuse.InjectorError = {
	MAPPING_BAD_PROP = '[Error infuse.Injector.mapClass/mapValue] the first parameter is invalid, a string is expected',
	MAPPING_BAD_VALUE = '[Error infuse.Injector.mapClass/mapValue] the second parameter is invalid, it can\'t null or undefined, with property: %s',
	MAPPING_BAD_CLASS = '[Error infuse.Injector.mapClass/mapValue] the second parameter is invalid, a function is expected, with property: ',
	MAPPING_BAD_SINGLETON = '[Error infuse.Injector.mapClass] the third parameter is invalid, a boolean is expected, with property: %s',
	MAPPING_ALREADY_EXISTS = '[Error infuse.Injector.mapClass/mapValue] this mapping already exists, with property: %s',
	CREATE_INSTANCE_INVALID_PARAM = '[Error infuse.Injector.createInstance] invalid parameter, a function is expected',
	NO_MAPPING_FOUND = '[Error infuse.Injector.getInstance] no mapping found',
	INJECT_INSTANCE_IN_ITSELF_PROPERTY =  '[Error infuse.Injector.getInjectedValue] A matching property has been found in the target, you can\'t inject an instance in itself',
	INJECT_INSTANCE_IN_ITSELF_CONSTRUCTOR =  '[Error infuse.Injector.getInjectedValue] A matching constructor parameter has been found in the target, you can\'t inject an instance in itself'
};

infuse.getConstructorParams = function(cl)
	return {}
end

local function validateProp(prop)
	if type(prop)~="string" then
		error(infuse.InjectorError.MAPPING_BAD_PROP)
	end 
end

local function validateValue(prop,value)
	if value==nil then
		error(string.format(infuse.InjectorError.MAPPING_BAD_VALUE,prop))
	end 
end

local function validateClass(prop,value)
	if value==nil then
		error(string.format(infuse.InjectorError.MAPPING_BAD_CLASS,prop))
	end 
end

local function validataBooleanSingleton(prop,singleton)
	if type(singleton)~='boolean' then
		error(string.format(infuse.InjectorError.MAPPING_BAD_SINGLETON,prop))
	end
end
	
local Injector = class()

function Injector:init()
	self.mappings = {}
end
function Injector:getMappingVo(prop)
	if self.mappings == nil then
		return nil
	end 
	if self.mappings[prop] then
		return self.mappings[prop]
	end 
	return nil
end

function Injector:getMapping(value)
	for prop,vo in pairs(self.mappings) do
		if vo.value == value or vo.cl == value then
			return prop
		end 
	end
	return nil
end

function Injector:getValue(prop)
	local vo = self.mappings[prop]
	if vo == nil then
		error(string.format(infuse.InjectorError.NO_MAPPING_FOUND,prop))
	end
	if vo.cl then
		if vo.singleton then
			if vo.value== nil then
				vo.value = self:createInstance(vo.cl)
			end
			return vo.value
		else
			return self:createInstance(vo.cl)
		end
	end
	return vo.value
end

function Injector:mapValue(prop,value)
	if self.mappings[prop] then
		error(string.format(infuse.InjectorError.MAPPING_ALREADY_EXISTS,prop))
	end 
	validateProp(prop)
	validateValue(prop,value)
	self.mappings[prop] = MappingVo(prop,value,nil,false)
end


function Injector:mapClass(prop,cl,singleton)
	singleton = singleton or false
	validateProp(prop)
	validateClass(prop,cl)
	validataBooleanSingleton(prop,singleton)
	self.mappings[prop] = MappingVo(prop,nil,cl,singleton)
end

function Injector:createInstance(targetClass,...)
	local instance = self:instantiate(targetClass,...)
	self:inject(instance)
	return instance
end

function Injector:removeMapping(prop)
	self.mappings[prop] = nil
end

function Injector:hasMapping(prop)
	return self.mappings[prop]~=nil
end

function Injector:getClass(prop)
	local vo = self:getMappingVo(prop)
	return vo.cl
end

function Injector:instantiate(targetClass,...)
	return targetClass(...)
end

function Injector:inject(target)
	for prop,vo in pairs(self.mappings) do
		if target[prop] then
			target[prop] = self:getInjectedValue(vo,prop)
		end 
	end
end

function Injector:getInjectedValue(vo,name)
	local value = vo.value
	local injectee
	if vo.cl then
		if vo.singleton then
			if vo.value== nil then
				vo.value = self:instantiate(vo.cl)
				injectee = vo.value
			end
			value = vo.value
		else
			value = self:instantiate(vo.cl)
			injectee = value
		end
	end
	if injectee then
		self:inject(injectee)
	end 
	return value
end

function Injector:getValueFromClass(cl)
	 for name,vo in pairs(self.mappings) do
		if vo.cl == cl then
			if vo.singleton then
				if vo.value== nil then
					vo.value = self:instantiate(vo.cl)
					return vo.value
				end
			else
				return self:instantiate(vo.cl)
			end
		end
	 end
	 error(string.format(infuse.InjectorError.NO_MAPPING_FOUND,''))
	 return nil
end

function Injector:dispose()
	self.mappings = nil
end

infuse.injector = Injector()
return infuse




