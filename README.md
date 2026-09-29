# dev-foundry

新设备开发环境的 Windows bootstrap、编辑器基线与项目模板

`Setup/` 为脚本和清单，`Editor/` 为 VS Code 配置，`Templates/` 为 C++ / Go / Python 模板

## Windows

在仓库根目录依次执行。先用 `-WhatIf` 预览；路径按提示粘贴，不加引号

```powershell
.\Setup\scripts\windows\01-storage-layout.ps1
.\Setup\scripts\windows\02-add-path.ps1
.\Setup\scripts\windows\03-msys2-tools.ps1
.\Setup\scripts\windows\04-install-uv.ps1
.\Setup\scripts\windows\05-go-tools.ps1
.\Setup\scripts\windows\06-vscode-extensions.ps1
```

| Script | Input |
| --- | --- |
| `01` | workspace root，例如 `E:\` |
| `02` | workspace root；MySQL Shell `bin` 路径可跳过 |
| `03` | MSYS2 root |
| `04` | uv 安装目录，例如 `E:\Apps\Development\Tools\uv` |
| `05` | Go `bin`、GOPATH、GOCACHE |
| `06` | VS Code 安装根目录 |

目录树见 [storage layout](setup/init/storage-layout/README.md)；系统指南见 [setup](setup/README.md)

## License

[MIT](LICENSE)
