# kafka-clients-upgrade Specification

## Purpose
TBD - created by archiving change nes-fork-security-maintenance. Update Purpose after archive.
## Requirements
### Requirement: kafka-clients 升级至 3.9.2

系统 SHALL 将 `kafkaVersion` 从 3.8.1 升级到 3.9.2，并同步应用于所有 kafka 相关坐标（`kafka-clients`、`kafka-streams`、`kafka-server`、`kafka-metadata`、`kafka-server-common`、`kafka-streams-test-utils`、`kafka_2.13`）。

#### Scenario: 版本属性统一升级

- **WHEN** 检查 `build.gradle` 中的 `kafkaVersion` 属性
- **THEN** 其值 SHALL 为 3.9.2，且所有引用 `$kafkaVersion` 的坐标随之升级

#### Scenario: 升级后测试全绿

- **WHEN** 升级 kafka-clients 至 3.9.2 后运行全量测试
- **THEN** 所有既有测试 SHALL 通过，`EmbeddedKafkaBroker` 相关测试无回归

#### Scenario: 依赖从本地私服解析

- **WHEN** 解析 kafka-clients 3.9.2 依赖
- **THEN** 依赖 SHALL 从本地 `~/.m2` 私服缓存解析，不依赖公网 Maven Central

### Requirement: 升级兼容性回归验证

系统 SHALL 在升级前建立测试绿基准，升级后执行全量回归以证明无破坏性变更。

#### Scenario: 升级前建立基线

- **WHEN** 升级动作执行前
- **THEN** SHALL 先在 3.8.1 版本运行全量测试并记录通过结果作为基线

