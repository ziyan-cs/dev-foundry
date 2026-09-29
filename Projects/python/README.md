# project-name

使用 uv、Ruff、pytest 和 src layout 的 Python 项目模板。

## 创建项目

复制模板后，至少将 `pyproject.toml` 中的 `project-name` 改为 distribution 名称。若需要自定义 import 名称，再将 `project_name` 同步替换为目标 Python package 名称，并重命名 `src/project_name/`。

## 常用命令

```bash
uv sync --all-groups
uv run ruff format --check .
uv run ruff check .
uv run pytest
uv build
```

运行示例命令：

```bash
uv run project-name
```

依赖由 `pyproject.toml` 声明，`uv.lock` 锁定；两者都应提交到 Git。
