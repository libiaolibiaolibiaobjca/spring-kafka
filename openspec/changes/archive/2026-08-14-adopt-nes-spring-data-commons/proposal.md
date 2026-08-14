## Why

本仓 `spring-kafka` 的 optional `spring-data-commons` 仍走官方 `org.springframework.data:spring-data-bom:2021.2.17`。NES 已发布 `bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1`（含 CVE-2026-41711/41721 回移），并将 Data BOM 对齐到 `2021.2.18-nes.patch.2-SNAPSHOT`。独立消费本仓时仍会解析到官方 commons；现在把选定实现切到 NES，与 retry 采纳方式一致。本 change 按用户要求暂不走 component RELEASE。

## What Changes

- 将 `dependencyManagement` 的 Spring Data BOM 从官方 `org.springframework.data:spring-data-bom:2021.2.17` 换成 NES `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom:2021.2.18-nes.patch.2-SNAPSHOT`
- 将 `spring-kafka` 的 `optionalApi` 从官方 `org.springframework.data:spring-data-commons` 换成 `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons`（版本由 NES BOM 管理，为 `2.7.18-nes.patch.1`）
- 对 NES data-commons 排除 `cn.bjca.footstone.bpring` 与 `org.springframework`，编译继续用官方 Spring Framework
- 更新 GAV、需求、用户与 CVE 文档；CVE-2026-41711/41721 保持「免疫」（本仓仍不暴露 Sort / `@ProjectedPayload`），并记录选定实现已是 NES 含补丁坐标
- **不**新增 Elasticsearch、Parsson、Spring Security 依赖
- **不**修改 `spring-boot-2.7` 或其他兄弟仓
- **不**执行本仓 `2.9.13-nes.patch.2` RELEASE

## Capabilities

### New Capabilities

- `spring-data-commons-nes-dependency`: 规定本仓对 NES Spring Data BOM、NES data-commons 坐标、排除规则，以及 CVE-2026-41711/41721 文档状态的要求

### Modified Capabilities

- （无）现有 `spring-retry-nes-dependency` / `component-release` / `publish-artifactid` / `kafka-header-deserialization-security` 的需求语句不因本次 optional 依赖切换而改写；RELEASE 门禁按用户要求本 change 不触发

## Impact

- **构建**：根 `build.gradle` 的 BOM import 与 `spring-kafka` optional 依赖坐标
- **发布 POM**：`bjca-footstone-bpring-kafka` 将 optional 传递 NES data-commons（非 Elasticsearch）
- **Java API**：`org.springframework.data.*` / `ProjectingMessageConverter` import 不变
- **下游**：需能解析 Nexus 上的 NES Data BOM SNAPSHOT 与 data-commons RELEASE；Boot 侧 substitution 另议，本仓不改 Boot
- **发布**：保持 `2.9.13-nes.patch.2-SNAPSHOT`，本 change 不发 RELEASE
