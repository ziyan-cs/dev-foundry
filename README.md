# dev-foundry

Personal development workstation foundation: Windows toolchains, Arch VMware bootstrap, Linux setup, editor settings, and C++ / Go / Python project templates.

## Structure

- `Setup/` — manual entry guides, interactive setup scripts, and tool manifests.
- `Editor/` — local and Remote SSH VS Code settings.
- `Projects/` — language-specific starter templates.

## Rebuild flow

1. Start with [Setup](Setup/README.md) and choose the target system.
2. Complete the documented manual prerequisites.
3. Run the next interactive script; type `yes` only after reviewing its plan.
4. Use `-WhatIf` with PowerShell scripts to preview writes.

Scripts never write Git identity, SSH keys, proxy settings, disk layout, network settings, or shell configuration.

## License

[MIT](LICENSE)
