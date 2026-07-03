# Spring Kafka 2.9.13 维护分支需求文档

## 任务主题

Spring Kafka 2.9.13 维护分支——Nexus 私服发布配置、GAV 去特征化重命名、kafka-clients 升级

## 分支信息

| 属性 | 值 |
|------|------|
| **基础版本** | Spring Kafka 2.9.13（upstream 2.9.x） |
| **工作分支** | `2.9.x-bjca-patch` |
| **版本号** | `2.9.13-nes.patch.1-SNAPSHOT` |
| **Group** | `cn.bjca.footstone.bpring.kafka` |
| **kafka-clients** | `3.9.2`（原 3.2.3） |

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
| Version | `2.9.14-SNAPSHOT` | `2.9.13-nes.patch.1-SNAPSHOT` |

### 4. Nexus 私服配置

| 维度 | 配置 |
|------|------|
| 公共仓库 | `nexusPublicUrl` |
| 快照仓库 | `nexusSnapshotUrl` |
| Release 仓库 | `nexusReleaseUrl` |

## 文档清单

| 文件 | 说明 |
|------|------|
| `doc/REQUIREMENTS.md` | 本文档 |
| `doc/NEXUS_DEPLOY.md` | Nexus 私服配置 |
| `doc/GAV_MAPPING.md` | GAV 坐标映射表 |
| `doc/QUICK_START.md` | 快速入门 |
| `doc/USER_MANUAL.md` | 用户手册 |
