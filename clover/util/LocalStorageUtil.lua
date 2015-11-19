local StorageType = require "clover.util.StorageType" 

----
---- 对cc.UserDefault 的封装
---- 

local localStorageUtil = {}


----
---- set Storage Item Value
---- @param key
---- @param value
---- @param type enum for StorageType
---- 

function localStorageUtil.setItem(key,value,type)
	if type == StorageType.TYPE_INTEGER then
		cc.UserDefault:getInstance():setIntegerForKey(key,value)
	elseif type == StorageType.TYPE_FLOAT then
		cc.UserDefault:getInstance():setFloatForKey(key,value)
	elseif type == StorageType.TYPE_BOOL then
		cc.UserDefault:getInstance():setBoolForKey(key,value)
	elseif type == StorageType.TYPE_DOUBLE then
		cc.UserDefault:getInstance():setDoubleForKey(key,value)
	elseif type == StorageType.TYPE_STRING then
		cc.UserDefault:getInstance():setStringForKey(key,value)
	end 
	cc.UserDefault:getInstance():flush()
end 

----
---- get Storage Item Value
---- @param key
---- @param type enum for StorageType
---- @return value

function localStorageUtil.getItem(key,type)
	if type == StorageType.TYPE_INTEGER then
		return cc.UserDefault:getInstance():getIntegerForKey(key)
	elseif type == StorageType.TYPE_FLOAT then
		return cc.UserDefault:getInstance():getFloatForKey(key)
	elseif type == StorageType.TYPE_BOOL then
		return cc.UserDefault:getInstance():getBoolForKey(key)
	elseif type == StorageType.TYPE_DOUBLE then
		return cc.UserDefault:getInstance():getDoubleForKey(key)
	elseif type == StorageType.TYPE_STRING then
		return cc.UserDefault:getInstance():getStringForKey(key)
	end 
	return nil
end 


return localStorageUtil