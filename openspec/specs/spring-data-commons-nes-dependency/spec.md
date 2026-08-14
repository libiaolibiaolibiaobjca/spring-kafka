# spring-data-commons-nes-dependency Specification

## Purpose

规定本仓对 NES Spring Data BOM、NES data-commons 坐标、排除规则、不引入 Elasticsearch 闭包，以及 CVE-2026-41711/41721 文档状态的要求。

## Requirements

### Requirement: Spring Data BOM 使用 NES 坐标

根项目 `dependencyManagement` MUST import `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom:2021.2.18-nes.patch.2-SNAPSHOT`，MUST NOT 继续 import 官方 `org.springframework.data:spring-data-bom:2021.2.17` 作为选定 BOM。

#### Scenario: BOM import 指向 NES

- **WHEN** 检查根 `build.gradle` 的 `dependencyManagement.imports`
- **THEN** 存在 `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom` 且版本为 `2021.2.18-nes.patch.2-SNAPSHOT`
- **AND** 不存在作为选定 import 的 `org.springframework.data:spring-data-bom`

### Requirement: optional spring-data-commons 使用 NES 坐标

`spring-kafka` 的 `optionalApi` 依赖 MUST 使用 `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons`，版本 MUST 解析为 NES BOM 管理的 `2.7.18-nes.patch.1`。MUST NOT 以官方 `org.springframework.data:spring-data-commons` 作为选定实现。Java package MUST 保持 `org.springframework.data.*`。

#### Scenario: 运行时类路径解析到 NES data-commons

- **WHEN** 执行 `./gradlew :spring-kafka:dependencyInsight --dependency bjca-footstone-bpring-data-commons --configuration runtimeClasspath`
- **THEN** 选定坐标为 `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1`

#### Scenario: 官方 spring-data-commons 不再作为本模块选定实现

- **WHEN** 检查 `spring-kafka` 的 `runtimeClasspath`
- **THEN** 不存在作为选定实现的 `org.springframework.data:spring-data-commons`

### Requirement: 排除 data-commons 传递的 Spring Framework 双坐标

对 NES data-commons 依赖的声明 MUST 排除 `cn.bjca.footstone.bpring` 与 `org.springframework` 组，使本仓编译继续使用既有官方 Spring Framework 坐标策略。

#### Scenario: 排除生效

- **WHEN** 查看 `build.gradle` 中 NES data-commons 依赖闭包
- **THEN** 同时包含对 `cn.bjca.footstone.bpring` 与 `org.springframework` 的 `exclude`

### Requirement: 不引入 Elasticsearch 客户端闭包

本仓 MUST NOT 将 NES Spring Data Elasticsearch、NES Elasticsearch 客户端、NES Parsson/Barsson 或 Spring Security 新增为 `spring-kafka` / `spring-kafka-test` 的 compile/api/optional 依赖。导入 NES Data BOM MUST NOT 把这些模块变成选定实现。

#### Scenario: runtime 无 Elasticsearch 选定实现

- **WHEN** 检查 `spring-kafka` 的 `runtimeClasspath`
- **THEN** 不存在 `bjca-footstone-bpring-data-elasticsearch`、`bjca-footstone-blasticsearch`、`org.elasticsearch` 组或 `org.eclipse.parsson` 作为选定实现

### Requirement: CVE-2026-41711 与 CVE-2026-41721 保持免疫并记录 NES 坐标

项目 MUST 维护 `doc/CVE/CVE-2026-41711.md`、`doc/CVE/CVE-2026-41721.md` 与 `doc/VULNERABILITY_REPORT.md`：主状态 MUST 仍为「免疫」（本仓不暴露 Sort 端点与 `@ProjectedPayload` Web 绑定）；文档 MUST 写明选定实现为 NES `bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1`。MUST NOT 仅因坐标切换把这两条 CVE 主状态改为「已修复」。

#### Scenario: 总览与单篇一致

- **WHEN** 查阅漏洞总览与 CVE-2026-41711、CVE-2026-41721 独立文档
- **THEN** 三者均显示免疫，并写明当前 NES data-commons 坐标

### Requirement: 需求与 GAV 文档记录 NES data-commons 依赖

`doc/REQUIREMENTS.md`、`doc/GAV_MAPPING.md`、`doc/USER_MANUAL.md` 与 `doc/QUICK_START.md` MUST 反映 NES Data BOM 与 NES data-commons 坐标，并说明 Java import 不变。

#### Scenario: GAV 映射含 data-commons

- **WHEN** 阅读 `doc/GAV_MAPPING.md`
- **THEN** 可见官方 spring-data-commons / spring-data-bom 到 NES 坐标的映射表
