# Windows storage layout

新机开发布局。只创建 `layout.txt` 内的高频开发与日常软件目录；不会移动文件、安装软件、创建个人项目与数据目录、配置用户目录重定向或执行 Git 操作。

```powershell
.\setup\scripts\windows\01-storage-layout.ps1
```

直接粘贴根目录路径，例如 `E:\`，不加引号。脚本会循环校验路径、显示将创建的目录；输入完整 `yes` 后才开始创建。预览：

```powershell
.\setup\scripts\windows\01-storage-layout.ps1 -WhatIf
```

## 目标目录树

以下为脚本最终保证存在的目录树；仅列目录，不创建具体文件。

```text
<ROOT>/
├── Apps/
│   ├── AI/chatbox/
│   ├── Communication/{QQ, Weixin}/
│   ├── Development/
│   │   ├── Toolchains/{CMake, Git, Go, Node.js, NodeGlobal, Python, msys2}/
│   │   ├── Editors/{Neovim, VS_Code}/
│   │   ├── IDEs/CLion/
│   │   └── Tools/{Apifox, CC_Switch, GitHub_Copilot, PipPal, uv}/
│   ├── Diagnostics/{CPU-Z, CrystalDiskInfo, GPU-Z, HWiNFO64}/
│   ├── Files/{7-Zip, Everything}/
│   ├── Gaming/Steam/
│   ├── Media/VLC/
│   ├── Networking/{Clash_Verge, Xftp}/
│   ├── Notes/Obsidian/
│   ├── Security/{HuoRong, Proton_Authenticator, VeraCrypt}/
│   └── System/{Geek, Lenovo}/
├── Assets/
│   ├── Fonts/{JetBrainsMono-2.304, JetBrainsMonoNerd}/
│   ├── Records/{QQ, Weixin}/
│   └── Databases/
├── Cache/
│   ├── go/{build, gopath/{bin, pkg}}/
│   ├── npm/
│   ├── pip/
│   └── tmp/
├── Configs/
│   ├── dev_foundry/
│   │   ├── setup/{guides, manifests, scripts/{linux, windows}}/
│   │   ├── editor/
│   │   └── templates/{cpp, go, python}/
│   ├── git/
│   ├── scripts/
│   ├── cc_switch/
│   ├── cline/{Hooks, Rules, Workflows}/
│   ├── rdp/
│   └── visual_studio/{Code Snippets, Templates}/
├── Projects/
│   ├── freelance/
│   ├── open_source/
│   └── personal/
├── Servers/
│   ├── vms/vm_arch/
│   └── {vmware, docker, mysql, nginx, redis, wsls}/
├── Studio/
│   ├── coursework/
│   ├── poc/
│   └── sandbox/
└── Vault/
    ├── homework/
    └── notes/
```
