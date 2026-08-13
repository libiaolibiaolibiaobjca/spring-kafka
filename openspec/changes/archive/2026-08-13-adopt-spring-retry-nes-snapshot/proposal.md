## Why

官方 `spring-retry:1.3.4` 受 CVE-2026-41710（有状态重试缓存耗尽）影响。NES `spring-retry-1.3` 已在 SNAPSHOT 中完成源码修复，但正式 RELEASE 暂不发布。本仓需要先切换到该 SNAPSHOT，使传递依赖内容含修复，并形成可审计的 OpenSpec/文档记录；同时补齐此前直接改 `build.gradle` 时遗漏的变更治理。

## What Changes

- 将本仓开发版本从已发布的 `2.9.13-nes.patch.1` 升为 `2.9.13-nes.patch.2-SNAPSHOT`
- 将 `spring-kafka` / `spring-kafka-test` 的直接依赖从 `org.springframework.retry:spring-retry:1.3.4` 切换为 `cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT`
- 在 `allprojects.repositories` 增加 Nexus public/snapshots，保证 SNAPSHOT 可解析
- 排除 NES retry 传递的 NES/官方 Spring Framework，避免与本仓编译用官方 `org.springframework:*` 双坐标
- 更新安全与 GAV 文档：`doc/CVE/CVE-2026-41710.md`、`doc/VULNERABILITY_REPORT.md`、`doc/GAV_MAPPING.md`
- 补齐用户/需求/Nexus 文档：`doc/REQUIREMENTS.md`、`doc/USER_MANUAL.md`、`doc/QUICK_START.md`、`doc/NEXUS_DEPLOY.md`
- CVE-2026-41710 主状态记为 **⚠️已缓解**（SNAPSHOT 不得记为已修复）；retry RELEASE 后再升为已修复
- **不**将已发布的 `2.9.13-nes.patch.1` 作为含 SNAPSHOT 依赖的再发布；本 change 将本仓开发版本升为 `2.9.13-nes.patch.2-SNAPSHOT`，待 retry 正式 RELEASE 后再发 `2.9.13-nes.patch.2`

## Capabilities

### New Capabilities

- `spring-retry-nes-dependency`: 规定本仓对 Spring Retry NES 坐标、版本阶段（SNAPSHOT）、排除规则、解析仓库与 CVE 文档状态的要求

### Modified Capabilities

- （无）现有 `component-release` / `publish-artifactid` / `kafka-header-deserialization-security` 的需求语句不因本次依赖切换而改写；RELEASE 门禁与 SNAPSHOT 依赖冲突通过本 change 的 design/tasks 与文档约束处理

## Impact

- **构建**：`build.gradle` 依赖坐标与 Nexus 解析仓库
- **下游**：消费本仓制品时会解析到 NES retry SNAPSHOT，需能访问 Nexus snapshots
- **Boot**：spring-boot-2.7 NES 宜另行做官方 retry → NES SNAPSHOT 的 BOM/substitution（本 change 不修改 Boot 仓）
- **Java API**：package/import 不变（仍为 `org.springframework.retry.*`）
- **发布**：在 retry NES RELEASE 之前，不得把「依赖 SNAPSHOT」的 POM 当作新的不可变 RELEASE 闭环证据
