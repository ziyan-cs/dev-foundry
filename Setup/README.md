# Setup

文档决定步骤；脚本执行可重复部分。脚本只在输入完整 `yes` 后执行，PowerShell 脚本可加 `-WhatIf` 预览。

| Target | Entry |
| --- | --- |
| Windows local | [guides/windows.md](guides/windows.md) |
| Arch on VMware: ISO → dev / SSH | [guides/arch-vmware.md](guides/arch-vmware.md) |
| Arch development tools | [guides/arch.md](guides/arch.md) |
| Ubuntu / Debian development tools | [guides/ubuntu.md](guides/ubuntu.md) |
| Windows storage layout | [init/storage-layout/README.md](init/storage-layout/README.md) |

`manifests/` 是工具与扩展清单；`scripts/` 不写入 Git 身份、SSH 密钥、代理、磁盘、网络或 shell 配置。

Windows 的 `02-add-path.ps1` 同时维护 User PATH，并在 Node.js、`Toolchains/NodeGlobal` 与 `Cache/npm` 均存在时，将 npm global prefix 与 cache 分别配置到 `NodeGlobal`、`Cache/npm`。
