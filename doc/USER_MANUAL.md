# 用户手册

## 1. 项目概述

本项目基于 Spring Kafka 2.9.13 维护分支，进行内部补丁维护，主要目标：

1. **Nexus 私服发布**：统一依赖下载与构件发布渠道
2. **GAV 去特征化**：重命名 Maven 坐标以规避 SCA 工具误报
3. **kafka-clients 升级**：升级到 3.9.2 获取最新功能与安全修复

## 2. 版本与坐标

| 项 | 值 |
|---|---|
| 发布版本 | `2.9.13-nes.patch.1-SNAPSHOT` |
| GroupId | `cn.bjca.footstone.bpring.kafka` |
| 运行时展示版本 | `2.9.13`（`gradle.properties` 的 `springKafkaVersion`） |
| kafka-clients | `3.9.2` |

## 3. Makefile 命令参考

| 命令 | 说明 |
|------|------|
| `make help` | 显示帮助信息 |
| `make setup-gradle` | 安装本地 Gradle zip 到 wrapper 缓存 |
| `make clean` | 清理构建产物 |
| `make build-thin` | 快速构建，跳过测试和代码检查 |
| `make test` | 运行单元测试 |
| `make test-all` | 单元测试 + 集成测试 |
| `make build` | 全量构建 |
| `make install` | 发布到 `~/.m2/repository` |
| `make deploy` | 发布到 Nexus 私服 |
| `make stop` | 停止 Gradle Daemon |
| `make projects` | 查看所有子项目 |

## 4. 迁移指南

从官方 Spring Kafka 迁移到本内部版本：

1. 在 `pom.xml` / `build.gradle` 中替换 GAV 坐标（参见 `doc/GAV_MAPPING.md`）
2. **无需修改** Java 源代码中的 `import` 语句
3. 确认 `dependencyManagement` 中 BOM 版本一致

## 5. 相关文档

- [快速入门](QUICK_START.md)
- [Nexus 发布配置](NEXUS_DEPLOY.md)
- [GAV 映射表](GAV_MAPPING.md)
- [需求与版本清单](REQUIREMENTS.md)
