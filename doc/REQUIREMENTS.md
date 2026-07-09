# 需求与版本清单 (Requirements)

## 项目定位

本项目是 Spring for Apache Kafka 3.3 的 BJCA（北京数字认证）内部安全维护 fork，目标：
1. 建立可审计的安全漏洞状态报告体系（6 态归一化 + 每 CVE 独立文档）
2. GAV 去特征化，规避 SCA 工具误报
3. 依赖安全升级（kafka-clients 3.8.1 → 3.9.2）
4. 建立内网 Nexus 私服离线构建与发布通道
5. 交付完整用户文档

## 基线信息

| 项目 | 值 |
| :--- | :--- |
| 上游基线 | Spring for Apache Kafka **3.3.16** |
| 项目分支 | `3.3.x-bjca-patch` |
| 制品 GroupId | `cn.bjca.footstone.bpring.kafka` |
| 制品版本 | `3.3.16-nes.patch.1-SNAPSHOT` |

## 环境需求

| 组件 | 版本 | 说明 |
| :--- | :--- | :--- |
| JDK | **17**（Corretto 17.0.15 已验证） | spring-kafka 3.3 基线要求，sdkman 管理 |
| Gradle | **8.14.5** | wrapper 精确需求，本地 `~/dev/gradle-8.14.5` 预置到 wrapper 缓存 |
| Maven 私服 | 内网 Nexus `192.168.131.36:8088` | 依赖下载 + 制品发布 |

## 关键依赖版本清单

| 组件 | 版本 | 依赖类型 | 备注 |
| :--- | :--- | :--- | :--- |
| kafka-clients / kafka-streams | **3.9.2** | api / optionalApi | 由 3.8.1 升级（安全修复） |
| Spring Framework | 6.2.19 | api（context/messaging/tx） | 安全修复基线 |
| Jackson | 2.18.8 | optionalApi | jackson-bom |
| Spring Retry | 2.0.13 | api | CVE-2026-41710 修复版 |
| Spring Data Commons | 3.4.13（bom 2024.1.13） | optionalApi | |
| ZooKeeper | 3.8.6 | test（仅 spring-kafka-test） | EmbeddedKafkaBroker 用 |
| Micrometer | 1.14.14 | optionalApi | micrometer-bom |
| Micrometer Tracing | 1.4.13 | optionalApi | |
| Reactor | 2024.0.18（bom） | optionalApi | |
| Kotlin | 1.9.25 | | |
| Log4j2 | 2.24.3 | test/runtime | |

## 安全需求

- 每个 CVE 状态归一化为 6 态之一：✅已修复 / ⬜免疫 / ❌不适用 / 🔧修复中 / ⚠️已缓解 / ⏸️暂缓
- 漏洞总览见 [`VULNERABILITY_REPORT.md`](VULNERABILITY_REPORT.md)，每 CVE 独立文档见 `CVE/` 目录
- 依赖解析与制品发布全程走内网私服，隔离外网

## 交付物清单

| 文档 | 说明 |
| :--- | :--- |
| `VULNERABILITY_REPORT.md` | 漏洞状态总览（27 条 CVE） |
| `CVE/CVE-*.md` | 每 CVE 独立文档 |
| `GAV_MAPPING.md` | GAV 映射表 |
| `NEXUS_DEPLOY.md` | Nexus 私服发布说明 |
| `USER_MANUAL.md` | 用户手册 |
| `QUICK_START.md` | 快速入门 |
| `../Makefile` | 构建快捷命令 |
| `../scripts/setup-gradle-local.sh` | Gradle 本地分发预缓存脚本 |
