## ADDED Requirements

### Requirement: Spring Retry 使用 NES SNAPSHOT 坐标

`spring-kafka` 与 `spring-kafka-test` 的 compile/api 依赖 MUST 使用 `cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT`，MUST NOT 在上述配置中继续以官方 `org.springframework.retry:spring-retry:1.3.4` 作为选定实现。Java package MUST 保持 `org.springframework.retry.*` / `org.springframework.classify.*`。

#### Scenario: 运行时类路径解析到 NES retry

- **WHEN** 执行 `./gradlew :spring-kafka:dependencyInsight --dependency bjca-footstone-bpring-retry --configuration runtimeClasspath`
- **THEN** 选定坐标为 `cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT`（允许带唯一时间戳后缀）

#### Scenario: 官方 spring-retry 不再作为本模块选定实现

- **WHEN** 检查 `spring-kafka` 与 `spring-kafka-test` 的 `runtimeClasspath`
- **THEN** 不存在作为选定实现的 `org.springframework.retry:spring-retry`

### Requirement: 排除 retry 传递的 Spring Framework 双坐标

对 NES retry 依赖的声明 MUST 排除 `cn.bjca.footstone.bpring` 与 `org.springframework` 组，使本仓编译继续使用既有官方 Spring Framework 坐标策略。

#### Scenario: 排除生效

- **WHEN** 查看 `build.gradle` 中 NES retry 依赖闭包
- **THEN** 同时包含对 `cn.bjca.footstone.bpring` 与 `org.springframework` 的 `exclude`

### Requirement: Nexus 可解析 SNAPSHOT 依赖

项目依赖解析仓库 MUST 包含 Nexus 公共仓库与 snapshots 仓库（凭证来自用户级 Gradle 属性），以便解析 NES SNAPSHOT。

#### Scenario: allprojects 含 Nexus snapshots

- **WHEN** 检查根 `build.gradle` 的 `allprojects.repositories`
- **THEN** 存在指向 `nexusPublicUrl` 与 `nexusSnapshotUrl` 的 Maven 仓库配置

### Requirement: CVE-2026-41710 状态可审计且不得误标已修复

项目 MUST 维护 `doc/CVE/CVE-2026-41710.md` 与 `doc/VULNERABILITY_REPORT.md`，将本 CVE 主状态记为「已缓解」，说明 NES SNAPSHOT 含源码修复、正式 RELEASE 未发布；在 retry NES RELEASE 并完成本仓依赖切换前，MUST NOT 将该 CVE 主状态记为「已修复」。

#### Scenario: 总览与单篇一致

- **WHEN** 查阅漏洞总览与 CVE-2026-41710 独立文档
- **THEN** 两者均显示已缓解，并写明当前 NES SNAPSHOT 坐标与后续升为已修复的条件

### Requirement: 需求与用户文档记录 NES retry 依赖

`doc/REQUIREMENTS.md`、`doc/GAV_MAPPING.md`、`doc/USER_MANUAL.md`、`doc/QUICK_START.md` 与 `doc/NEXUS_DEPLOY.md` MUST 反映 NES retry SNAPSHOT 依赖、Nexus snapshots 解析要求，以及「当前不得以含该 SNAPSHOT 依赖的状态执行新的 component RELEASE 闭环」的约束说明。

#### Scenario: GAV 映射含 retry

- **WHEN** 阅读 `doc/GAV_MAPPING.md`
- **THEN** 可见官方 spring-retry 到 NES retry SNAPSHOT 的映射表

#### Scenario: 用户文档提示下游仓库

- **WHEN** 下游按快速入门或用户手册消费本制品
- **THEN** 文档说明需配置可访问的 Nexus snapshots（或等价私服），以解析传递的 NES retry SNAPSHOT

### Requirement: 本仓开发版本为 patch.2 SNAPSHOT

在已发布 `2.9.13-nes.patch.1` 之后，采纳 NES retry SNAPSHOT 期间本仓 `version` MUST 为 `2.9.13-nes.patch.2-SNAPSHOT`，MUST NOT 复用或覆盖已发布的 `2.9.13-nes.patch.1` 坐标。

#### Scenario: gradle.properties 版本

- **WHEN** 读取根 `gradle.properties` 的 `version`
- **THEN** 值为 `2.9.13-nes.patch.2-SNAPSHOT`
