# Rust 使用笔记

## 安装Rust

1. 参考[Rust: Getting started](https://www.rust-lang.org/learn/get-started)

2. linux系统下的安装命令：`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

3. 安装[rust.vim插件](https://github.com/rust-lang/rust.vim)
    - Add Plugin 'rust-lang/rust.vim' to ~/.vimrc
    - :PluginInstall

4. 安装[racer-rust/vim-racer插件](https://github.com/racer-rust/vim-racer)：支持函数跳转等
    - Add Plugin 'racer-rust/vim-racer' to ~/.vimrc
    - :PluginInstall
    - rustup toolchain add nightly
    - cargo +nightly install racer
    - rustup component add rust-src

5. 更换crates源：在$HOME/.cargo/目录下新建config文件，并添加以下内容：
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

5. rustfmt on save: add this to your vim config:
```
let g:rustfmt_autosave = 1
```

## Questions

1. Question: why we need to start with "let" when we define a variable?
