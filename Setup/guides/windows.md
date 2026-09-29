# Windows

手动安装到 workspace root 下的 `Apps\Development\Toolchains`：VS Code、Git、CMake、Python、Go、Node.js、MSYS2。完成每段前置后执行下一段。

```powershell
.\setup\scripts\windows\01-storage-layout.ps1
.\setup\scripts\windows\02-add-path.ps1
```

粘贴 workspace root（如 `E:\`）即可；不加引号。
脚本只写 User PATH，开发工具会排在其他用户工具之前；它将 npm global prefix 配置为 `Apps\Development\Toolchains\NodeGlobal`，并移除旧的 `%APPDATA%\npm` 与 `Node.js\node_global` PATH 项。System PATH 不会修改。

在 MSYS2 UCRT64 手动完成 `pacman -Syu` 后：

```powershell
.\setup\scripts\windows\03-msys2-tools.ps1
```

Python 已可运行后：

```powershell
.\setup\scripts\windows\04-install-uv.ps1
```

Go 已可运行后：

```powershell
.\setup\scripts\windows\05-go-tools.ps1
```

`04` 粘贴 uv 安装目录（如 `E:\Apps\Development\Tools\uv`）；其 PATH 由 `02` 统一管理。

VS Code 安装完成后，粘贴其安装根目录：

```powershell
.\setup\scripts\windows\06-vscode-extensions.ps1
```

编辑器配置、Git 身份和 SSH Key 手工配置。
