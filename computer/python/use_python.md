## Python使用笔记

### 基础知识

1. Ellipsis(`...`): Using the Ellipsis literal as the body of a function does nothing. It's purely a matter of style if you use it instead of pass or some other statement.

### 环境配置

1. 修改默认python版本
```
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
// reconfig
sudo update-alternatives --config python3
```

2. 安装vim插件
```
Plugin 'davidhalter/jedi-vim'
```

### Python shell

1. Python shell清屏: `Ctrl-L`
