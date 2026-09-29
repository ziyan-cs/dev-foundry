# Contributing

提交前请在 Debug preset 下构建并运行测试：

```bash
cmake --preset debug
cmake --build --preset debug
ctest --preset debug
```

请用项目根目录的 `.clang-format` 格式化 C++ 文件，并用 `.clang-tidy` 检查改动。
新增功能应同时增加至少一个 CTest 测试。
