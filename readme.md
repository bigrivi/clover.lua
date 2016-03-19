# clover.lua
========
## 特点

clover.lua 是一个轻量级的Lua MVC框架，致力于创建松耦合，可扩展性的应用程序，
系统利用了一些列设计模式来解决模块的耦合问题.

- 观察者模式 Event,EventDispatcher
- 命令模式 Command
- 依赖式注入 Infuse.Injector
- MVC模式 Model,Collection,View
- Facade模式 Application

令你开发起来能行云流水，一发而不可收拾

##最佳实践

- 定义Application
``` lua
function clover.Application:start()
	--server
	self.injector:mapClass("netServer",NetServer,true)
	self.injector:mapClass("apiService",ApiService,true)
	--config
	self.injector:mapValue("config",Config)
	--utils
	self.injector:mapClass("utils",Utils,true)
	--model
	self.injector:mapClass("userModel",UserModel,true)
	self.injector:mapClass("userPlayerList",PlayerList,true)
	self.injector:mapClass("itemModel",ItemModel,true)
	self.injector:mapClass("itemList",ItemList,true)

	--commands
	self.command:add(Consts.Command.START_UP,StartUpCmd)
	self.command:add(Consts.Command.ASYNC,AsyncCmd)
	self.command:add(Consts.Command.LOGIN,UserLoginCmd)
	self.command:add(Consts.Command.REG,UserRegCmd)
	self.command:add(Consts.Command.CREATE_PLAYER,CreatePlayerCmd)
	self.command:add(Consts.Command.ENTER_GAME,GameEnterCmd)
	self.command:add(Consts.Command.TEST_MESSAGE,TestMessageCmd)
	self.dispatcher:dispatchEvent(clover.Event(Consts.Command.START_UP))
end 
clover.Application()
```
在Application的start方法里面做一系列事情，比如注入系统对象，定义一些Command等

- 定义Command
Command的执行又dispatcher派发
形如self.dispatcher:dispatchEvent(clover.Event(Consts.Command.START_UP))
Command里面定义execute方法
``` lua
function M:execute(event)
	--do something
end 
```
- 定义View
@viewClass 视图类
@node 显示对象节点，比如cocos2dx里面的cc.Node
@viewOption 视图相关参数
Application:createView(viewClass,node,viewOption)
范例
``` lua
self.facade:createView(AppView,scene,{a=1,b=2})
```
创建了一个AppView的视图对象

``` lua
local class = clover.class
local View = clover.View

local SceneView = import ".SceneView"
local PopUpView = import ".PopUpView"
local Consts = import "..constants.Consts"

local M = class(View)

function M:ctor()
	self.__super.ctor(self)
end 


function M:render()
	self.sceneLayer = display.newLayer():addTo(self.el)
	self.uiLayer = display.newLayer():addTo(self.el)
	self.popUpLayer = display.newLayer():addTo(self.el)
	self.effectLayer = display.newLayer():addTo(self.el)
	return self
end 

function M:init()
	self:render()
	self.facade:createView(SceneView,self.sceneLayer)
	self.facade:createView(PopUpView,self.popUpLayer)
	self.dispatcher:addEventListener(Consts.LOCK_SCREEN,handler(self,self.onScreenLock))
	self.dispatcher:addEventListener(Consts.UN_LOCK_SCREEN,handler(self,self.onScreenUnLock))
end 

--
--场景锁屏
--

function M:onScreenLock(event)
	if self.lockMask then
		return
	end 
	local size = display.size
	local color = cc.c4b(20,20,20,0)
	local layer = cc.LayerColor:create(color,size.width,size.height)
   
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	local function onTouchBegan(touch, event)
		return layer:isVisible()
	end
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
	local eventDispatcher = self.el:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener,layer)
	self.lockMask = layer
	self.el:addChild(layer)
end 

--
--场景锁屏解锁
--
function M:onScreenUnLock(event)
	if self.lockMask then
		self.el:removeChild(self.lockMask)
		self.lockMask = nil
	end 
end 



function M:getAppView()
	return self.target
end 

return M
```

