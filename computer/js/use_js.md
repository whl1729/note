# JavaScript 使用笔记

## 库

### chai

- Chai: JavaScript Assertion Library

- should不支持对null或undefined变量执行断言，此时改用expect更合适

### axios

如果请求参数中含有数组，axios最终构造出来的url会带有`[]`，可能会导致请求失败。
这时，可以参考[这个ISSUE][1]的做法：

```javascript
var qs = require('qs');

axios.get('api/', {
    'params': {'country': ['PL', 'RU']}
    'paramsSerializer': function(params) {
       return qs.stringify(params, {arrayFormat: 'repeat'})
    },
})
```

## 疑问

- `Number` 和 `number`的区别是什么？`String` 和 `string`的区别是什么？
```
typeof(1) // "number"
let a = new Number();
typeof(a) // "object"
```

- 为什么不能用sleep的方式实现转一圈？（详见JavaScript MDN building-block event2的代码）

## 环境搭建

### eslint

- eslint 配置文件
  - 使用eslint时需要提供一个配置文件，可以通过`eslint --init`来生成。

### vim 插件

- 配置 vim 中 JavaScript 文件的缩进：`autocmd FileType javascript setlocal shiftwidth=2 tabstop=2`

- vim 支持 javascript 自动补全：
  - 安装`tern_for_vim`插件
  - 在项目根目录中新建一个配置文件`.tern-project`，并配置"libs"和"plugins"等参数。（详情参考tern_for_vim官方文档）
  - 编程时，按下`Ctrl-x Ctrl-o`即可进行补全。

### node & npm

- [设置 npm 默认安装目录][2]

- 安装 node 和 npm
```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

- 修改 npm 源
```
npm config set registry http://registry.npm.taobao.org/
```

- 解决`npm install -g` 权限问题：参考[npm install -g less does not work: EACCES: permission denied][3]
  - `mkdir ~/.npm-global`
  - `npm config set prefix '~/.npm-global'`
  - Open or create a ~/.profile file and add this line: `export PATH=~/.npm-global/bin:$PATH`
  - Back on the command line, update your system variables: `source ~/.profile`

### electron

- Question: 学习electron-quick-start例子时，运行`electron .`，会有以下报错，暂未找到解决方案。
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

- 解决electron下载慢的问题（方法1）
  - 设置 npm 源为 `npm config set registry https://registry.npm.taobao.org/`
  - 使用浏览器，前往 https://npm.taobao.org/mirrors/electron/ 下载你所需要的版本
  - 将下载的文件拷贝到以下路径：
    - Windows: `C:\Users\<user>\AppData\Local\electron\Cache`
    - Linux: `~/.cache/electron/`

- 解决electron下载慢的问题（方法2）
```
ELECTRON_MIRROR="https://npm.taobao.org/mirrors/electron/" npm install
```

- 如果electron版本较新，而你使用的js库不支持electron的这个新版本，会导致编译失败。需要重新编译js库，这时需要确保已经安装`windows-build-tool`工具。
```
npm install --global windows-build-tools
```

  [1]: https://github.com/axios/axios/issues/604
  [2]: https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally#manually-change-npms-default-directory
  [3]: https://stackoverflow.com/questions/33725639/npm-install-g-less-does-not-work-eacces-permission-denied
