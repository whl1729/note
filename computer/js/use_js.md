# JavaScript 使用笔记

## 疑问

1. `Number` 和 `number`的区别是什么？`String` 和 `string`的区别是什么？
```
typeof(1) // "number"
let a = new Number();
typeof(a) // "object"
```

## 环境搭建

1. 安装 node 和 npm
```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

2. 配置 vim 中 JavaScript 文件的缩进：`autocmd FileType javascript setlocal shiftwidth=2 tabstop=2`
