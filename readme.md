clover.lua
=========================
* 作者：andy.sun
* 制作日期：2016-03-19
* Email: sunjiangong@gmail.com

关于
------------------------
> 这些年我一直在研究软件架构方面的知识，究竟怎样才能创建一个架构良好，可扩展性好，可维护性的程序呢?
	
	
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

### 定义Application
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

### 定义Command
Command的执行又dispatcher派发
形如self.dispatcher:dispatchEvent(clover.Event(Consts.Command.START_UP))<br>
在Application里面<br>
self.command:add(Consts.Command.START_UP,StartUpCmd)<br>
Command里面定义execute方法
定义一个Command类
``` lua
local StartUpCmd = class()
function StartUpCmd:ctor() --构造函数
	--定义任意注入对象
end 
function StartUpCmd:execute(event)
	--do something
end 
return StartUpCmd
```
### 定义View
@viewClass 视图类<br> 
@node 显示对象节点，比如cocos2dx里面的cc.Node<br> 
@viewOption 视图相关参数<br> 
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
end 



function M:getAppView()
	return self.target
end 

return M
```
self.el为传入节点对象<br> 
self.viewOption为出入参数<br> 

### 依赖式注入

当我们需要一个对象的时候，不会去直接new一个对象，而是在注入器里面去
createInstance一个对象,注入器会采用属性注入的方式把之前我们mapClass,mapValue注入到系统的所有对象注入进新的对象实例
比如我们在前面<br>
self.injector:mapClass("userModel",UserModel,true)<br>
UserModel模型对象是一个单例<br>
如果我们需要创建的对象需要引用到它，只需要在构造函数里面定义一个userModel即可,eg:

``` lua
function M:ctor()
	self.userModel = {}
end 

function M:execute(event)
	print(self.userModel.uid)
	print(self.userModel.name)
end 

return M
```
这样能确保不会在对象里面去创建对象，对象和对象之间没有显示的耦合关系
注入器有如下方法
- mapClass map一个Class
- mapValue map一个对象
- getValue 通过key去获取一个对象
- createInstance 通过ClassName去创建一个对象实例
- getValueFromClass 通过key去拿Class的一个实例
- getInjectedValue 

单例可以这样实现 mapClass("userModel",UserModel,true)
我们还可以显示去注入一个对象
比如

``` lua
local systemServer = SystemServer()
self.injector:inject(systemServer)
```
systemServer便可以获取所有注入到的对象


happy coding!!





