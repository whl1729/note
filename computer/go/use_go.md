# Go 使用笔记

## 环境配置

1. 设置`go install`的默认安装路径：[What does go install do?](https://stackoverflow.com/questions/24069664/what-does-go-install-do/54429573)

2. 安装vim go插件
    - 安装ubuntu版vscode，使用vscode打开一个go工程，里面会提示missing插件，根据提示安装相应插件，对安装失败的插件进行手动安装。
    - 安装vim-go: 在.vimrc中添加`Plugin 'fatih/vim-go'`,然后输入`:PluginInstall`
    - 在vim中执行`:GoInstallBinaries`
    - 下载golang/tools: `git clone https://github.com/golang/tools.git`
