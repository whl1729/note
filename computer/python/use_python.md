## Python使用笔记

### Question

- [ ] Q: 什么时候使用 classmethod？什么时候不该使用 classmethod？
- [ ] Q: 定义 class 时，是否需要在最外层声明数据成员？
- [ ] Q: 定义 class 时，在最外层初始化数据成员是否合适？
- [ ] Q: Python 如何实现单例模式？
- [ ] Q: 某个功能通过类和函数均能实现，前者是否比后者开销大？每个类实体都需要复制一份成员函数？此时是不是应该使用静态函数？以minieye_ft/JsonManager为例进行分析。
- [ ] Q: classmethod不能访问`__init__`里面的属性，是因为`__init__`仅当创建instance时才会被调用吗？
- [ ] Q: Python 的 import 顺序是怎样的？考虑 multi_factory_tool 应该如何 import utils？ import 模块的规范是怎样的？

### 基础知识

1. Ellipsis(`...`): Using the Ellipsis literal as the body of a function does nothing. It's purely a matter of style if you use it instead of pass or some other statement.

### Python shell

1. Python shell清屏: `Ctrl-L`

### 环境配置

1. 安装vim插件
```
Plugin 'davidhalter/jedi-vim'
```

### 使用 pyenv 来管理 python 版本

1. 安装 Python 基本依赖
```
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
source ~/.bashrc
pyenv install 3.8.3
pyenv global 3.8.3
pip install ipython
```
