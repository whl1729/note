# Beego Samples 源码剖析

## WebIM（在线聊天室）

1. 浏览器与服务器交互过程
    - 浏览器输入`http://127.0.0.1:8080`，服务器返回`welcome.html`
    - 浏览器在`welcome.html`页面输入Username、选择Technology、点击"Enter chat room"，这时会触发以POST方法访问`http://127.0.0.1:8080/join`。服务器检查输入参数后，重定向到`http://127.0.0.1:8080/ws?uname=xxx`，然后返回`websocket.html`
    - 浏览器加载完`websocket.html`，会触发ready事件，此时浏览器会向服务器请求建立websocket连接，对应的URL为`ws://127.0.0.1/ws/join?uname=xxx`。
    - 服务器回复建立websocket连接。
