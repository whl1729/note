# npm 使用笔记

## 常见问题

1. npm设置socks5代理
  - 安装http-proxy-to-sock工具：`npm install http-proxy-to-socks -g`
  - 在后台运行hpts命令，将socks5数据转换为http：`hpts -s 127.0.0.1:1080 -p 8080 &`
  - 配置npm代理：`npm config set proxy http://127.0.0.1:8080`
