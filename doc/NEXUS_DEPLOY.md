# Nexus 私服发布配置说明

## 概述

本项目基于 Spring Kafka 2.9.x 维护分支（`2.9.x-bjca-patch`），配置了 Nexus 私服作为依赖下载源和构建产物发布目标。所有子模块的依赖下载和 Maven 发布均通过 Nexus 私服完成，同时使用自定义 Group ID（`cn.bjca.footstone.bpring.kafka`）以区分官方发布。

当前编译依赖含 NES Spring Retry SNAPSHOT（`bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT`），并 import NES Data BOM SNAPSHOT（`bjca-footstone-bpring-data-bom:2021.2.18-nes.patch.2-SNAPSHOT`）。因此**依赖解析**必须能访问 Nexus snapshots，而不仅是发布时选择 snapshot/release。

## 修改文件清单

### 1. `gradle.properties`
- 添加 `projectGroup=cn.bjca.footstone.bpring.kafka`，定义全局 Group ID
- 版本为 `2.9.13-nes.patch.2-SNAPSHOT`（上一正式版 `2.9.13-nes.patch.1`；以仓库当前值为准）
- 添加 `springKafkaVersion=2.9.13`（运行时展示版本）

### 2. `settings.gradle`
- 在 `pluginManagement.repositories` 中添加 Nexus 私服仓库（公共仓库 + 快照仓库）和 Spring Milestone 仓库

### 3. `build.gradle`
- 设置 `group = projectGroup`（替换原硬编码的 `org.springframework.kafka`）
- `allprojects.repositories` 配置：
  - Maven Central / Spring 仓库
  - Nexus **public**（`nexusPublicUrl`）
  - Nexus **snapshots**（`nexusSnapshotUrl`）——用于解析 NES retry、NES Data BOM 等 SNAPSHOT
- `publishing.repositories` 按版本号是否含 `-SNAPSHOT` 自动选择 snapshot 或 release 仓库

## 使用方法

| 命令 | 用途 |
|---|---|
| `make clean` | 清理构建产物 |
| `make build-thin` | 快速构建（跳过测试、文档、代码检查），日常开发验证编译 |
| `make build` | 全量构建（含测试，耗时较长） |
| `make test` | 运行单元测试 |
| `make install` | 发布到本地 Maven 仓库（`~/.m2/repository`），跳过测试 |
| `make deploy` | 发布到 Nexus 私服，跳过测试 |
| `make stop` | 停止所有 Gradle Daemon 进程，释放内存和文件锁 |
| `make projects` | 查看所有子项目列表 |

## Nexus 属性配置要求

需要在 `~/.gradle/gradle.properties` 中配置以下属性：

```properties
# Nexus 私服地址
nexusPublicUrl=http://192.168.131.36:8088/repository/maven-public/
nexusReleaseUrl=http://192.168.131.36:8088/repository/releases/
nexusSnapshotUrl=http://192.168.131.36:8088/repository/snapshots/

# Nexus 认证凭证
nexusUsername=developer
nexusPassword=snapsh0ts@2021!
```

**注意事项：**
- 这些属性配置在用户级别的 `~/.gradle/gradle.properties` 中，不会提交到版本控制
- `nexusPublicUrl` 用于依赖下载（pluginManagement 和 allprojects 仓库）
- `nexusSnapshotUrl` 用于依赖解析 SNAPSHOT（如 NES spring-retry、NES Data BOM）以及 SNAPSHOT 制品发布
- `nexusReleaseUrl` 用于 RELEASE 制品发布；根据版本号是否包含 `-SNAPSHOT` 自动选择发布目标
- 在仍依赖内部 SNAPSHOT 的状态下，**不要**执行新的 component RELEASE 闭环（见 `openspec/specs/component-release` 与 change `adopt-spring-retry-nes-snapshot` / `adopt-nes-spring-data-commons`）
