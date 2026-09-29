# Go application template

Go 应用项目模板，包含可执行入口、内部包、单元测试、编辑器任务和 GitHub Actions。

## 创建项目

复制模板后，将 [go.mod](go.mod) 第一行的 `example.com/project-name` 改为实际 module path，例如 `github.com/your-account/my-service`。

## 常用命令

```bash
go test -race ./...
go vet ./...
go build ./cmd/app
go run ./cmd/app
```

`cmd/` 放可执行程序入口，`internal/` 放仅供当前 module 使用的实现。公开库 API 应放在单独 module，或仅在确有对外复用需求时加入 `pkg/`。
