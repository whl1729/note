# Rust 使用笔记

## 安装Rust

1. 参考[Rust: Getting started](https://www.rust-lang.org/learn/get-started)

2. linux系统下的安装命令：`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

3. 安装[rust.vim插件](https://github.com/rust-lang/rust.vim)
    - Add Plug 'rust-lang/rust.vim' to ~/.vimrc
    - :PlugInstall or $ vim +PlugInstall +qall

4. 更换crates源
```
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index.git"
replace-with = "ustc"
# replace-with = "rustcc"

[source.rustcc]
registry = "https://code.aliyun.com/rustcc/crates.io-index.git"

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
```
