# vs code使用笔记

## 常见问题

1. 使用vs code remote-ssh 连接服务器时报ssh timeout，可以尝试关闭以下配置：
  - 参考[why ssh connection timed out in vscode?](https://stackoverflow.com/questions/59978826/why-ssh-connection-timed-out-in-vscode)
```
"remote.SSH.useLocalServer": false
```

2. [vscode配置浏览html文件快捷键][vscode_html]
  - Use `ctrl + shift + p` (or F1) to open the Command Palette.
  - Type in `Tasks: Configure Task`. Selecting it will open the tasks.json file. Delete the script displayed and replace it by the following:
```
{
    "version": "2.0.0",
    "command": "Chrome",
    "linux": {
        "command": "/usr/bin/google-chrome-stable"
    },
    "args": [
        "${file}"
    ]
}
```
  - Save the file.
  - Switch back to your html file, and press `ctrl + shift + b` to view your page in your Web Browser.

  [vscode_html]: https://stackoverflow.com/questions/30039512/how-to-view-an-html-file-in-the-browser-with-visual-studio-code

## 环境配置

1. IntelliSense configuration settings editor UI
    - You can get to the IntelliSense configuration settings editor UI through the command palette (Ctrl+Shift+P) and running the C/C++: Edit configurations (UI) command. The c_cpp_properties.json file can be opened by running the C/C++: Edit configurations (JSON) command. 
    - When configuring IntelliSense for the first time, VS Code will open the UI editor or JSON file based on your workbench.settings.editor setting. If workbench.settings.editor is set to “ui”, then the UI editor will open by default, and if it is set to “json”, then the JSON file will open by default. You can view that setting under VS Code preferences → settings → “Workbench Settings Editor”.

## 快捷键

1. Show all Commands: `Ctrl + Shift + P`

2. Go to file: `Ctrl + P`

3. Find in files: `Ctrl + Shift + F`

4. Start Debugging: `F5`

5. Toggle Terminal: `Ctrl + \``
