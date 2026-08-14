# 用户手册

## 1. 项目概述

本项目基于 Spring Kafka 2.9.13 维护分支，进行内部补丁维护，主要目标：

1. **Nexus 私服发布**：统一依赖下载与构件发布渠道
2. **GAV 去特征化**：重命名 Maven 坐标以规避 SCA 工具误报
3. **kafka-clients 升级**：升级到 3.9.2 获取最新功能与安全修复
4. **Spring Retry NES**：编译依赖切换为含 CVE-2026-41710 源码修复的 SNAPSHOT（正式 RELEASE 前记为已缓解）
5. **Spring Data Commons NES**：optional 投影依赖切换为 NES data-commons（CVE 主状态仍为免疫）

## 2. 版本与坐标

| 项 | 值 |
|---|---|
| 发布版本 | `2.9.13-nes.patch.2-SNAPSHOT`（上一正式版 `2.9.13-nes.patch.1`） |
| GroupId | `cn.bjca.footstone.bpring.kafka` |
| 运行时展示版本 | `2.9.13`（`gradle.properties` 的 `springKafkaVersion`） |
| kafka-clients | `3.9.2` |
| spring-retry（传递） | `cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT` |
| spring-data-commons（optional） | `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1` |

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
2. **无需修改** Java 源代码中的 `import` 语句（含 `org.springframework.kafka.*`、`org.springframework.retry.*` 与 `org.springframework.data.*`）
3. 确认能解析 Nexus **snapshots**（本制品传递 NES spring-retry SNAPSHOT，并 import NES Data BOM SNAPSHOT）
4. 若同时使用 spring-boot-2.7 NES，建议在 Boot 侧将官方 `spring-retry` 统一替换为同一 NES 坐标，避免双实现；optional `spring-data-commons` 同理避免官方/NES 双坐标

## 5. Kafka Header 反序列化安全配置

`2.9.13-nes.patch.1` 起已回移 CVE-2026-41731 修复（当前开发线 `2.9.13-nes.patch.2-SNAPSHOT` 继承）。`DefaultKafkaHeaderMapper` 的受信包配置现在采用**精确包名匹配**，父包不再自动信任子包。

例如，仅添加 `com.example`：

```java
DefaultKafkaHeaderMapper mapper = new DefaultKafkaHeaderMapper();
mapper.addTrustedPackages("com.example");
```

只会信任直接声明在 `com.example` 包中的类型，不会信任 `com.example.events.OrderEvent`。需要使用子包类型时应显式配置：

```java
mapper.addTrustedPackages(
		"com.example",
		"com.example.events",
		"com.example.shared");
```

注意事项：

1. 升级前检查所有 `addTrustedPackages` 调用和自定义 Header Mapper 配置。
2. 收到 `NonTrustedHeaderType` 时，确认类型所属的准确包名并按最小范围加入。
3. 避免配置 `addTrustedPackages("*")`；该配置会显式信任所有类型，只适用于 Producer 和 Topic 写入权限完全可信的环境。
4. 使用 Kafka ACL 限制能够向消费 Topic 写入消息的 Producer。

漏洞分析及验证方式参见 [CVE-2026-41731](CVE/CVE-2026-41731.md)。

## 6. Spring Retry 与 CVE-2026-41710

本仓直接依赖 NES SNAPSHOT（非官方 `1.3.4`）。漏洞总览主状态为 **⚠️已缓解**：SNAPSHOT 含源码修复，但 retry 正式 RELEASE 未发布前**不得**记为已修复。

使用建议：

1. 优先使用 Retry Topic / 容器 ErrorHandler；避免启用已弃用的 `setStatefulRetry(true)` + `RetryTemplate` 路径。
2. 解析依赖时配置 Nexus snapshots（见 `doc/NEXUS_DEPLOY.md`）。
3. 详情见 [CVE-2026-41710](CVE/CVE-2026-41710.md) 与 [漏洞总览](VULNERABILITY_REPORT.md)。

## 7. 相关文档

- [快速入门](QUICK_START.md)
- [Nexus 发布配置](NEXUS_DEPLOY.md)
- [GAV 映射表](GAV_MAPPING.md)
- [需求与版本清单](REQUIREMENTS.md)
- [漏洞状态总览](VULNERABILITY_REPORT.md)
