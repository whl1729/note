# JavaScript 使用笔记

## 疑问

1. `Number` 和 `number`的区别是什么？`String` 和 `string`的区别是什么？
```
typeof(1) // "number"
let a = new Number();
typeof(a) // "object"
```

2. 为什么不能用sleep的方式实现转一圈？（详见JavaScript MDN building-block event2的代码）

## 环境搭建

1. 安装 node 和 npm
```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

2. 配置 vim 中 JavaScript 文件的缩进：`autocmd FileType javascript setlocal shiftwidth=2 tabstop=2`

3. vim 支持 javascript 自动补全：
    - 安装`tern_for_vim`插件
    - 在项目根目录中新建一个配置文件`.tern-project`，并配置"libs"和"plugins"等参数。（详情参考tern_for_vim官方文档）
    - 编程时，按下`Ctrl-x Ctrl-o`即可进行补全。

4. 修改 npm 源
```
npm config set registry http://registry.npm.taobao.org/
```
