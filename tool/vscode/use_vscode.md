# vscode 使用笔记

## 提高开发效率的技巧

### 快捷键

- Show all Commands: `Ctrl + Shift + P`
- Go to file: `Ctrl + P`
- Find in files: `Ctrl + Shift + F`
- Start Debugging: `F5`
- Toggle Terminal: `Ctrl + \``
- Go to next search result: `F4`
- Go to previous search result: `Shift + F4`

### 创建代码模板

- [Snippets in Visual Studio Code][snippets]
  - `File > Preferences > User Snippets`

  [snippets]: https://code.visualstudio.com/docs/editor/userdefinedsnippets

## 常见问题

- windows vscode 配置使用 git bash
  - `File > Preferences > Settings`
  - Search for `Integrated > Shell: Windows`
  - Edit "terminal.integrated.shell.windows" to your git bash path

- 使用vs code remote-ssh 连接服务器时报ssh timeout，可以尝试关闭以下配置：
  - 参考[why ssh connection timed out in vscode?](https://stackoverflow.com/questions/59978826/why-ssh-connection-timed-out-in-vscode)
  ```
  "remote.SSH.useLocalServer": false
  ```

- [vscode配置浏览html文件快捷键][html_preview]
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

  [html_preview]: https://stackoverflow.com/questions/30039512/how-to-view-an-html-file-in-the-browser-with-visual-studio-code

- [vscode修改html缩进配置][html_indent]
  - Open the Command Palette `Ctrl+Shift+P`
  - `Preferences: Configure language specific settings...`
  - Select programming language (for example html)
  - Add this code:
  ```
  "[html]": {
      "editor.tabSize": 2
  }
  ```

  [html_indent]: https://stackoverflow.com/questions/34174207/how-to-change-indentation-in-visual-studio-code

- IntelliSense configuration settings editor UI
    - You can get to the IntelliSense configuration settings editor UI through the command palette (Ctrl+Shift+P) and running the C/C++: Edit configurations (UI) command. The c_cpp_properties.json file can be opened by running the C/C++: Edit configurations (JSON) command.
    - When configuring IntelliSense for the first time, VS Code will open the UI editor or JSON file based on your workbench.settings.editor setting. If workbench.settings.editor is set to “ui”, then the UI editor will open by default, and if it is set to “json”, then the JSON file will open by default. You can view that setting under VS Code preferences → settings → “Workbench Settings Editor”.

