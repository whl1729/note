## Python使用笔记

### 基础知识

1. Ellipsis(`...`): Using the Ellipsis literal as the body of a function does nothing. It's purely a matter of style if you use it instead of pass or some other statement.

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
```

### Python shell

1. Python shell清屏: `Ctrl-L`
