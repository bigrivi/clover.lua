# clover.lua
## 特点

clover.lua 是一个轻量级的Lua MVC框架，致力于创建松耦合，可扩展性的应用程序，
系统利用了以下设计模式来解决耦合问题.
- 观察者模式
- 命令模式
- 依赖式注入
- MVC模式

##最佳实践

- 定义一个Application
``` lua
local app = clover.Application()
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
```

