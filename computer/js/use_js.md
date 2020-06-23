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

### vim 插件

1. 配置 vim 中 JavaScript 文件的缩进：`autocmd FileType javascript setlocal shiftwidth=2 tabstop=2`

2. vim 支持 javascript 自动补全：
    - 安装`tern_for_vim`插件
    - 在项目根目录中新建一个配置文件`.tern-project`，并配置"libs"和"plugins"等参数。（详情参考tern_for_vim官方文档）
    - 编程时，按下`Ctrl-x Ctrl-o`即可进行补全。

### node & npm

1. 安装 node 和 npm
```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

2. 修改 npm 源
```
npm config set registry http://registry.npm.taobao.org/
```

3. 解决`npm install -g` 权限问题：参考[npm install -g less does not work: EACCES: permission denied](https://stackoverflow.com/questions/33725639/npm-install-g-less-does-not-work-eacces-permission-denied)
    - `mkdir ~/.npm-global`
    - `npm config set prefix '~/.npm-global'`
    - Open or create a ~/.profile file and add this line: `export PATH=~/.npm-global/bin:$PATH`
    - Back on the command line, update your system variables: `source ~/.profile`

### electron

1. Question: 学习electron-quick-start例子时，运行`electron .`，会有以下报错，暂未找到解决方案。
```

along:~/src/learn-js/electron-quick-start$ npm start

> electron-quick-start@1.0.0 start /home/along/src/learn-js/electron-quick-start
> electron .

MESA-LOADER: failed to retrieve device information
gbm: failed to open any driver (search paths /usr/lib/x86_64-linux-gnu/dri:${ORIGIN}/dri:/usr/lib/dri)
gbm: Last dlopen error: /usr/lib/dri/i915_dri.so: cannot open shared object file: Operation not permitted
failed to load driver: i915
gbm: failed to open any driver (search paths /usr/lib/x86_64-linux-gnu/dri:${ORIGIN}/dri:/usr/lib/dri)
gbm: Last dlopen error: /usr/lib/dri/kms_swrast_dri.so: cannot open shared object file: Operation not permitted
failed to load driver: kms_swrast
gbm: failed to open any driver (search paths /usr/lib/x86_64-linux-gnu/dri:${ORIGIN}/dri:/usr/lib/dri)
gbm: Last dlopen error: /usr/lib/dri/swrast_dri.so: cannot open shared object file: Operation not permitted
failed to load swrast driver
```

2. 解决electron下载慢的问题
    - 设置 npm 源为 `npm config set registry https://registry.npm.taobao.org/`
    - 使用用浏览器，前往 https://npm.taobao.org/mirrors/electron/ 下载你所需要的版本
    - 将下载的文件拷贝到`~/.cache/electron/`
