## Context

本仓 `spring-kafka` / `spring-kafka-test` 原先直接依赖官方 `org.springframework.retry:spring-retry:1.3.4`。CVE-2026-41710 影响该版本的有状态重试缓存；NES `spring-retry-1.3` 已在 SNAPSHOT 中回移修复，但正式 RELEASE 暂不发布。

本仓默认路径（Retry Topic backoff、无状态 `RetryTemplate`、`RetryingDeserializer`）不走 `MapRetryContextCache`；弃用的 `setStatefulRetry(true)` 仍可触及有状态路径。切换到 NES SNAPSHOT 可在依赖内容层缓解漏洞，并为 Boot 侧统一替换提供上游对齐。

约束：

- 本仓编译仍使用官方 Spring Framework `5.3.29`；运行时由 Boot NES 覆盖
- NES retry POM 默认传递 NES Framework，必须 exclude
- `component-release` 禁止 RELEASE 制品依赖内部 SNAPSHOT；已发布 `2.9.13-nes.patch.1`，本 change 将开发版本升为 `2.9.13-nes.patch.2-SNAPSHOT`

部分实现（`build.gradle`、CVE/GAV/总览）已先行落地；本 design 覆盖完整决策与剩余文档收口。

## Goals / Non-Goals

**Goals:**

- 直接依赖锁定为 NES retry SNAPSHOT，且可从 Nexus 解析
- CVE-2026-41710 以「已缓解」可审计记录，明确 SNAPSHOT ≠ 已修复
- 需求/用户/Nexus 文档与实现一致
- 形成完整 OpenSpec change，便于后续 retry RELEASE 后再升级状态

**Non-Goals:**

- 不发布 spring-retry NES RELEASE
- 不修改 spring-boot-2.7 仓（Boot 替换另做）
- 不升级 spring-retry 2.x
- 不为本依赖切换单独再发一个 kafka RELEASE（避免 SNAPSHOT 污染不可变发布）
- 不改 Java 业务/API 行为

## Decisions

### 1. 直接声明 NES GAV，而非仅靠 Boot substitution

在本仓 `api` 依赖中显式使用：

`cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT`

**理由：** 本仓是库，发布 POM 会把 retry 传给下游；显式 NES 坐标与 kafka 自身 GAV 去特征化一致，且不依赖消费者是否已做 substitution。  
**备选：** 保留官方坐标、仅靠 Boot 覆盖 → 独立消费本仓时仍拉到易受影响的 1.3.4。

### 2. exclude NES/官方 Spring Framework 传递依赖

```
exclude group: 'cn.bjca.footstone.bpring'
exclude group: 'org.springframework'
```

**理由：** 避免编译 classpath 混入 NES Framework；与历史对官方 retry 排除 `org.springframework` 的惯例一致。

### 3. allprojects 增加 Nexus public + snapshots

**理由：** pluginManagement  alone 不足以解析项目依赖 SNAPSHOT。  
**备选：** 仅 mavenLocal → 不可复现。

### 4. CVE 主状态 = 已缓解，不是已修复 / 不是免疫

**理由：** SNAPSHOT 已含修复内容，但不能按 NES 规范记「已修复」；同时不再仅靠「默认无状态」宣称免疫，因依赖内容已切换。

### 5. 文档补齐清单

必须同步：`REQUIREMENTS`、`USER_MANUAL`、`QUICK_START`、`NEXUS_DEPLOY`，以及已改的 `GAV_MAPPING` / CVE / `VULNERABILITY_REPORT`。

## Risks / Trade-offs

- [RELEASE 版本依赖 SNAPSHOT] → 文档与 tasks 明确禁止以此状态做新的 RELEASE 闭环；retry RELEASE 或本仓改回 SNAPSHOT 后再发版
- [SNAPSHOT 漂移] → 记录已验证时间戳候选（如 `20260810.073226-2`）；发版前再做一次 insight
- [下游无 Nexus snapshots] → USER_MANUAL / QUICK_START 写明仓库要求
- [Boot 仍管官方 1.3.4] → 可能与本仓 POM 坐标并存；Boot 侧需后续 substitution/BOM 对齐（本 change 外）
- [弃用 stateful 路径] → SNAPSHOT 修复覆盖该路径；文档仍提示勿启用已弃用 stateful RetryTemplate

## Migration Plan

1. 合并本 change 的构建与文档（含已落地的依赖切换）
2. 验证 `dependencyInsight` 解析到 NES SNAPSHOT
3. 下游/Boot：配置 Nexus snapshots；Boot 另开 change 做官方→NES 替换
4. rollback：将 `api` 依赖改回 `org.springframework.retry:spring-retry:1.3.4` 并恢复文档状态为免疫（不推荐，仅应急）
5. 后续：retry `1.3.4-nes.patch.1` RELEASE 后，本仓去掉 `-SNAPSHOT`，CVE 升为已修复，再按 component-release 发下一 patch

## Open Questions

- Boot 采纳 NES retry SNAPSHOT 的优先级与负责人（本仓仅提供提示词/对齐说明）
