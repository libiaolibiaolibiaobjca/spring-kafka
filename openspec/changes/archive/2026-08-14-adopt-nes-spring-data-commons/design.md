## Context

`spring-kafka` 通过 `ProjectingMessageConverter` optional 依赖 `spring-data-commons`。当前版本由官方 `org.springframework.data:spring-data-bom:2021.2.17` 管理，坐标仍是 `org.springframework.data:spring-data-commons`。

NES `spring-data-commons-2.7` 已发布 `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1`（Java package 仍为 `org.springframework.data.*`，含 CVE-2026-41711/41721 回移）。NES `spring-data-bom-2.7` 开发线为 `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom:2021.2.18-nes.patch.2-SNAPSHOT`，其中 commons 指向上述 RELEASE，elasticsearch 指向 `4.4.18-nes.patch.2-SNAPSHOT`。

约束：

- 本仓编译仍使用官方 Spring Framework `5.3.29`；运行时由 Boot NES 覆盖
- NES data-commons POM 默认传递 NES Framework，必须 exclude
- 本仓不使用 Elasticsearch / Security / Parsson；导入 NES BOM 只做版本管理，不得因此把 SDE 加进 compile/runtime
- 用户要求暂不走 component RELEASE；保持 `2.9.13-nes.patch.2-SNAPSHOT`

## Goals / Non-Goals

**Goals:**

- optional `spring-data-commons` 的选定实现为 NES RELEASE 坐标
- Spring Data BOM import 使用 NES Data BOM，使 commons 版本由 BOM 管理
- 排除 NES/官方 Framework 传递，避免双坐标
- CVE-2026-41711/41721 文档记录坐标切换，主状态仍为免疫（本仓不暴露攻击面）
- `ProjectingMessageConverter` 测试继续通过，Java import 不变

**Non-Goals:**

- 不引入 NES Elasticsearch、elasticsearch-java、Parsson/Barsson、Spring Security
- 不修改 `spring-boot-2.7`、`spring-data-bom-2.7`、`spring-data-commons-2.7` 或其他兄弟仓
- 不把 CVE-2026-41711/41721 标为已修复（本仓攻击面仍不存在；坐标对齐不等于新攻击面修复叙事）
- 不新增 CVE-2026-41716 台账（本仓原先未跟踪，且不使用相关 Web 绑定）
- 不执行本仓 RELEASE，不把 Data BOM SNAPSHOT 当作发版门禁解除
- 不改 `spring-kafka-docs` 使用的官方 `spring-boot-starter:2.7.16`

## Decisions

### 1. 同时切换 NES BOM import 与 NES commons GAV

官方 Data BOM 的 management key 是 `org.springframework.data:*`，管不到 NES commons GAV。只改依赖坐标而不改 BOM，会失去 BOM 版本对齐；只改 BOM 而不改依赖 GAV，官方 commons 仍无版本来源。

因此：

- `mavenBom "cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom:$springDataVersion"`
- `springDataVersion = '2021.2.18-nes.patch.2-SNAPSHOT'`
- `optionalApi` 使用 NES group/artifact，版本交给 BOM（`2.7.18-nes.patch.1`）

**备选：** 像 retry 一样硬编码 commons 版本、去掉 BOM import。否决原因：用户列出的变更包含 Data BOM 本身，且 commons 已有对应 BOM 条目。

### 2. 不把 Elasticsearch 变成本仓依赖

NES BOM 的 dependencyManagement 含 SDE SNAPSHOT。BOM import 只提供版本，不会把未声明模块拉进 classpath。本仓 MUST NOT 新增 `bjca-footstone-bpring-data-elasticsearch` 或任何 `org.elasticsearch` / `blasticsearch` 依赖。

### 3. exclude NES/官方 Spring Framework

与 retry 相同：

```
exclude group: 'cn.bjca.footstone.bpring'
exclude group: 'org.springframework'
```

**理由：** NES commons 传递 NES Framework；本仓编译策略仍是官方 `org.springframework:*`。

### 4. CVE 主状态保持免疫

NES commons 本体已修复 CVE-2026-41711/41721，但本仓仍只用 `ProjectingMessageConverter`，不暴露 Sort 端点与 `@ProjectedPayload` Web 绑定。文档改为「选定实现已是 NES 含补丁坐标」，主状态仍为免疫，避免把坐标对齐写成 kafka 攻击面修复。

### 5. 仅改 `spring-kafka` optionalApi，不改 `spring-kafka-test`

`spring-kafka-test` 当前无 data-commons 直接依赖；投影测试在 `spring-kafka` 模块。

## Risks / Trade-offs

- [Data BOM 为 SNAPSHOT] → 解析依赖 Nexus snapshots（已有）；用户要求忽略 RELEASE，本仓继续 SNAPSHOT
- [BOM 管理 SDE SNAPSHOT 造成误解] → 文档与 spec 写明不引入 ES 依赖；用 dependencyInsight 确认 runtime 无 elasticsearch
- [下游无 Nexus] → USER_MANUAL / QUICK_START 说明除 retry SNAPSHOT 外还需 NES Data BOM SNAPSHOT（commons 本身为 RELEASE）
- [Boot 仍可能 substitution 官方 data-commons] → 与 retry 相同，Boot 另议；本仓发布 POM 已是 NES 坐标
- [docs 模块仍用官方 Boot 2.7.16] → 有意隔离，避免 docs 编译被 Boot 的 ES/Security SNAPSHOT 图拖入

## Migration Plan

1. 改 `build.gradle` BOM 与 optional 坐标并加 exclude
2. `dependencyInsight` 确认 NES commons；确认无官方 data-commons、无 elasticsearch 选定实现
3. 跑 `ProjectingMessageConverterTests`（及现有 `make test` 若时间允许）
4. 同步 GAV / CVE / REQUIREMENTS / USER_MANUAL / QUICK_START
5. rollback：BOM 改回官方 `2021.2.17`，optionalApi 改回 `org.springframework.data:spring-data-commons`

## Open Questions

- （无）Boot 是否 substitution 官方 data-commons 不在本 change 范围
