# Python使用笔记

## Question

- [ ] Q: 什么时候使用 classmethod？什么时候不该使用 classmethod？
- [ ] Q: 定义 class 时，是否需要在最外层声明数据成员？
- [ ] Q: 定义 class 时，在最外层初始化数据成员是否合适？
- [ ] Q: Python 如何实现单例模式？
- [ ] Q: 某个功能通过类和函数均能实现，前者是否比后者开销大？每个类实体都需要复制一份成员函数？此时是不是应该使用静态函数？以minieye_ft/JsonManager为例进行分析。
- [ ] Q: classmethod不能访问`__init__`里面的属性，是因为`__init__`仅当创建instance时才会被调用吗？
- [ ] Q: Python 的 import 顺序是怎样的？考虑 multi_factory_tool 应该如何 import utils？ import 模块的规范是怎样的？

## 编程实践

- 为了避免各种奇奇怪怪的import问题，我总结了以下方案（不成熟，待完善）：
    - python 入口脚本永远放在项目根目录下
    - import 同一项目的其他package或module时，均使用绝对路径的方式。

- `mypy` python 静态检查工具。

## 基础知识

- Ellipsis(`...`): Using the Ellipsis literal as the body of a function does nothing. It's purely a matter of style if you use it instead of pass or some other statement.

- [How does Python's super() work with multiple inheritance?][super]:
    - `super(MyClass, self).__init__()` provides the next `__init__` method according to the used Method Resolution Ordering (MRO) algorithm in the context of the complete inheritance hierarchy.

- [Ellipsis in numpy.array][array_ellipsis]
```
In [223]: cube
Out[223]:
array([[[1, 2],
        [3, 4]],

       [[5, 6],
        [7, 8]]])

In [224]: cube[..., ::-1]
Out[224]:
array([[[2, 1],
        [4, 3]],

       [[6, 5],
        [8, 7]]])
```

  [super]: https://stackoverflow.com/questions/3277367/how-does-pythons-super-work-with-multiple-inheritance
  [array_ellipsis]: https://stackoverflow.com/questions/772124/what-does-the-ellipsis-object-do

## Python shell

- Python shell清屏: `Ctrl-L`

## 环境配置

- 安装vim插件
```
Plugin 'davidhalter/jedi-vim'
```

## 使用 pyenv 来管理 python 版本

- 安装 Python 基本依赖
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

- 解决pyenv install速度慢的问题
  - 到淘宝镜像网站上下载对应的安装包，放在`~/.pyenv/cache`目录下，再执行pyenv install即可。
```
export v=2.7.6; wget https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz -P ~/.pyenv/cache/; pyenv install $v
```

## 使用 pyinstaller 打包 python 程序

- 使用 pyinstaller 打包 multi_factory_tools 时报错：
```
OSError: Python library not found: libpython3.8.so.1.0, libpython3.8m.so.1.0, libpython3.8m.so, libpython3.8mu.so.1.0
    This would mean your Python installation doesn't come with proper library files.
    This usually happens by missing development package, or unsuitable build parameters of Python installation.

    * On Debian/Ubuntu, you would need to install Python development packages
      * apt-get install python3-dev
      * apt-get install python-dev
    * If you're building Python by yourself, please rebuild your Python with `--enable-shared` (or, `--enable-framework` on Darwin)
```
    卸载python，重装时增加"--enable-shared"选项后该问题得到解决：
```
pyenv uninstall 3.8.2
env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.8.2
```

- 如果待打包的程序需要动态加载 package 或 module，需要在 pyinstaller 命令后面加上"--hidden-import"参数。
