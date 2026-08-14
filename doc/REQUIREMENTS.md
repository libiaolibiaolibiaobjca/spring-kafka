# Spring Kafka 2.9.13 维护分支需求文档

## 任务主题

Spring Kafka 2.9.13 维护分支——Nexus 私服发布配置、GAV 去特征化重命名、kafka-clients 升级、Spring Retry NES SNAPSHOT 采纳、Spring Data Commons NES 采纳

## 分支信息

| 属性 | 值 |
|------|------|
| **基础版本** | Spring Kafka 2.9.13（upstream 2.9.x） |
| **工作分支** | `2.9.x-bjca-patch` |
| **版本号** | `2.9.13-nes.patch.2-SNAPSHOT`（上一正式版 `2.9.13-nes.patch.1`） |
| **Group** | `cn.bjca.footstone.bpring.kafka` |
| **kafka-clients** | `3.9.2`（原 3.2.3） |
| **spring-retry** | `cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT` |
| **spring-data-bom** | `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom:2021.2.18-nes.patch.2-SNAPSHOT` |
| **spring-data-commons** | `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1` |

## 变更概述

### 1. Gradle 升级

| 项目 | 变更前 | 变更后 |
|------|--------|--------|
| Gradle Wrapper | 7.3.1 | 8.14.5 |
| Gradle 本地缓存 | 无 | setup-gradle-local.sh 脚本 |

### 2. kafka-clients 升级

| 项目 | 变更前 | 变更后 |
|------|--------|--------|
| kafka-clients | 3.2.3 | 3.9.2 |
| kafka-streams | 3.2.3 | 3.9.2 |
| kafka-metadata | 3.2.3 | 3.9.2 |
| kafka-server-common | 3.2.3 | 3.9.2 |

### 3. GAV 重构

| 维度 | 变更前 | 变更后 |
|------|--------|--------|
| GroupId | `org.springframework.kafka` | `cn.bjca.footstone.bpring.kafka` |
| ArtifactId | `spring-kafka-*` | `bjca-footstone-bpring-kafka-*` |
| Version | `2.9.14-SNAPSHOT` | `2.9.13-nes.patch.1`（已 RELEASE）→ 当前 `2.9.13-nes.patch.2-SNAPSHOT` |

### 4. Nexus 私服配置

| 维度 | 配置 |
|------|------|
| 公共仓库 | `nexusPublicUrl` |
| 快照仓库 | `nexusSnapshotUrl` |
| Release 仓库 | `nexusReleaseUrl` |

### 5. 本仓升为 patch.2 开发 SNAPSHOT

| 项目 | 变更前 | 变更后 |
|------|--------|--------|
| 本仓版本 | `2.9.13-nes.patch.1`（已 RELEASE） | `2.9.13-nes.patch.2-SNAPSHOT` |

下一正式版目标为 `2.9.13-nes.patch.2`（须在 retry NES 非 SNAPSHOT 就绪后按 component-release 执行）。

### 6. Spring Retry NES SNAPSHOT（CVE-2026-41710）

| 项目 | 变更前 | 变更后 |
|------|--------|--------|
| 坐标 | `org.springframework.retry:spring-retry:1.3.4` | `cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT` |
| CVE-2026-41710 | ⬜免疫（默认无状态路径） | ⚠️已缓解（NES SNAPSHOT 含源码修复；正式 RELEASE 未发布） |

约束：

- Java import 不变（`org.springframework.retry.*`）
- 传递的 NES/官方 Spring Framework 在本仓依赖声明中排除
- **不得**在仍依赖该 SNAPSHOT 的状态下执行新的 component RELEASE 闭环；retry NES 发布 `1.3.4-nes.patch.1` 后再升 CVE 为已修复并发版
- OpenSpec change：`adopt-spring-retry-nes-snapshot`

### 7. Spring Data Commons NES（CVE-2026-41711 / CVE-2026-41721）

| 项目 | 变更前 | 变更后 |
|------|--------|--------|
| Data BOM | `org.springframework.data:spring-data-bom:2021.2.17` | `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom:2021.2.18-nes.patch.2-SNAPSHOT` |
| optionalApi | `org.springframework.data:spring-data-commons` | `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1` |
| CVE-2026-41711 / 41721 | ⬜免疫（官方 BOM，攻击面不存在） | ⬜免疫（NES 含补丁坐标；本仓仍不暴露 Sort / `@ProjectedPayload`） |

约束：

- Java import 不变（`org.springframework.data.*`）
- 传递的 NES/官方 Spring Framework 在本仓依赖声明中排除
- **不**引入 NES Elasticsearch / Parsson / Security
- 主状态保持免疫，不得因坐标切换记为已修复
- OpenSpec change：`adopt-nes-spring-data-commons`

## 文档清单

| 文件 | 说明 |
|------|------|
| `doc/REQUIREMENTS.md` | 本文档 |
| `doc/NEXUS_DEPLOY.md` | Nexus 私服配置 |
| `doc/GAV_MAPPING.md` | GAV 坐标映射表 |
| `doc/QUICK_START.md` | 快速入门 |
| `doc/USER_MANUAL.md` | 用户手册 |
| `doc/VULNERABILITY_REPORT.md` | 漏洞状态总览 |
| `doc/CVE/CVE-2026-41710.md` | Spring Retry 缓存耗尽 CVE |
| `doc/CVE/CVE-2026-41711.md` | Spring Data Commons Sort 路径解析 CVE |
| `doc/CVE/CVE-2026-41721.md` | Spring Data Commons MapDataBinder CVE |
