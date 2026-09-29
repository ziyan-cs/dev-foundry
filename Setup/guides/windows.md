# Windows

手动安装到自选 `$SDK_PATH`：VS Code、Git、CMake、Python、Go、Node.js、MSYS2。完成每段前置后执行下一段。

```powershell
.\Setup\scripts\windows\10-add-path.ps1
```

粘贴 SDK 根目录路径即可；不加引号。
脚本只写 User PATH，SDK 工具会排在其他用户工具之前；存在时 `%APPDATA%\npm` 会紧跟 Node 全局目录；System PATH 不会修改。

在 MSYS2 UCRT64 手动完成 `pacman -Syu` 后：

```powershell
.\Setup\scripts\windows\20-msys2-tools.ps1
```

Python、Go 已可运行后：

```powershell
.\Setup\scripts\windows\30-install-uv.ps1
.\Setup\scripts\windows\40-go-tools.ps1
```

VS Code 的 `code` CLI 可用后：

```powershell
.\Setup\scripts\windows\50-vscode-extensions.ps1
```

编辑器配置、Git 身份和 SSH Key 手工配置。
