# Arch development tools

Stage 1 见 [arch-vmware.md](arch-vmware.md)。手工完成系统更新、包安装、Vim 配置与 Go 安装后：

```bash
bash Setup/scripts/linux/30-install-uv.sh
bash Setup/scripts/linux/40-go-tools.sh
```

Shell 配置继续手工编辑 `.profile`、`.bashrc`、`.zprofile`、`.zshrc`；脚本不写入它们。
