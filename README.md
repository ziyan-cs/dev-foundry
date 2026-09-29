# dev-foundry

个人开发工作站的 **bootstrap blueprint**：统一新机目录布局、开发工具链、虚拟机基础环境、编辑器配置与 C++ / Go / Python 项目模板。目标是让设备重建具备可读、可审计、可重复执行（**reproducible**）的基线。

## 仓库结构

- `Setup/`：运行手册（guides）、交互式脚本（scripts）、初始化任务（init）与版本化清单（manifests）。
- `Editor/`：本机与 Remote SSH 的 VS Code 配置基线。
- `Projects/`：语言级 starter templates；用于派生新项目，而非存放实际业务代码。

## 目录初始化范围

当前目录初始化（storage layout）面向 Windows 新机：

- 用户粘贴已存在的 storage root，例如 `E:\`；脚本计算 **desired state** 与实际目录的差集。
- 执行前输出完整 change plan；只有输入完整 `yes` 才创建缺失目录。
- 目录蓝图覆盖开发与日常软件的明确安装位置，以及 Assets、Cache、Configs、Projects、Servers、Studio 与 Vault 的基础结构；具体业务项目、课程作业和个人 Vault 内容仍按需创建。Windows 已知文件夹不在初始化范围内。
- 脚本严格限定为目录 provisioning：不安装应用、不迁移数据、不处理 `.lnk`、不重定向 Known Folders、不修改 Git 状态。

## 快速开始

以下命令均在 repository root 执行。

先预览 Windows storage layout（dry run）：

```powershell
.\Setup\init\storage-layout\windows.ps1 -WhatIf
```

确认目录计划后执行初始化：

```powershell
.\Setup\init\storage-layout\windows.ps1
```

开发工具阶段（按文档完成手工 prerequisite 后逐段执行）：

```powershell
.\Setup\scripts\windows\10-add-path.ps1
.\Setup\scripts\windows\20-msys2-tools.ps1
.\Setup\scripts\windows\30-install-uv.ps1
.\Setup\scripts\windows\40-go-tools.ps1
.\Setup\scripts\windows\50-vscode-extensions.ps1
```

每个脚本先展示 change plan；确认无误后输入 `yes`。目录初始化与开发工具的 prerequisite / verification 见 [Setup](Setup/README.md)。

## 使用流程

1. 从 [Setup](Setup/README.md) 选择目标系统或 initialization task。
2. 完成 guide 中保留给人工判断的 prerequisite。
3. 先以 `-WhatIf` 预览 PowerShell 脚本，再确认执行。
4. 将 manifest 作为工具与扩展的 single source of truth；脚本只读取清单并实施变更。

脚本不会写入 Git identity、SSH private key、proxy、disk layout、network configuration 或 shell configuration。

## License

[MIT](LICENSE)
