# beego 源码剖析

## WebIM（在线聊天室）

1. 浏览器与服务器交互过程
    - 浏览器输入`http://127.0.0.1:8080`，服务器返回`welcome.html`
    - 浏览器在`welcome.html`页面输入Username、选择Technology、点击"Enter chat room"，这时会触发以POST方法访问`http://127.0.0.1:8080/join`。服务器检查输入参数后，重定向到`http://127.0.0.1:8080/ws?uname=xxx`，然后返回`websocket.html`
    - 浏览器加载完`websocket.html`，会触发ready事件，此时浏览器会向服务器请求建立websocket连接，对应的URL为`ws://127.0.0.1/ws/join?uname=xxx`。
    - 服务器回复建立websocket连接。

## http 

1. beego.Run --> serverhandler.ServeHTTP
```
beego.Run()
    BeeApp.Run()
        go BeeApp.Server.ListenAndServe()
        BeeApp.Server.Handler = BeeApp.Handlers
        BeeApp.Server.Serve(l net.Listener)
            for {
                rw, e := l.Accept()
                c := srv.newConn(rw)  // c.server = BeeApp.Server
                go c.serve(ctx)
                    c.server.ServeHTTP()
                        c.server.Handler.ServeHTTP()  // c.server.Handler = BeeApp.Server.Handler = BeeApp.Handler = ControllerRegister{}
                    w.finishRequest()
                        w.req.MultipartForm.RemoveAll()
                }
    ```

2. conn.server.ServeHTTP
```
conn.server.ServeHTTP()
	serverStaticRouter(context)
    execController.Init(context, runRouter.Name(), runMethod, execController)
    execController.Prepare()

    switch runMethod {
    case http.MethodGet:
        execController.Get()
    case http.MethodPost:
        execController.Post()
    ...
    }

    execController.Finish()
```

3. beego.Handler
```
Handler(rootpath string, h http.Handler, options ...interface{})
	BeeApp.Handlers.Handler(rootpath, h, options...)
        route.routerType = routerTypeHandler
		p.addToRouter(m, pattern, route)
```
