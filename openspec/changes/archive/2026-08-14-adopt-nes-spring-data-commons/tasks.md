## 1. 依赖切换（构建）

- [x] 1.1 将 `springDataVersion` 改为 `2021.2.18-nes.patch.2-SNAPSHOT`，BOM import 改为 NES `bjca-footstone-bpring-data-bom`
- [x] 1.2 将 `spring-kafka` 的 `optionalApi` 改为 NES `bjca-footstone-bpring-data-commons`，并 exclude `cn.bjca.footstone.bpring` 与 `org.springframework`
- [x] 1.3 用 `dependencyInsight` 验证 runtimeClasspath 解析到 NES data-commons `2.7.18-nes.patch.1`，且无官方 `spring-data-commons`
- [x] 1.4 确认 `spring-kafka` runtimeClasspath 无 Elasticsearch / Parsson 选定实现

## 2. 安全与 GAV 文档

- [x] 2.1 更新 `doc/CVE/CVE-2026-41711.md`：保持免疫，记录 NES data-commons 坐标
- [x] 2.2 更新 `doc/CVE/CVE-2026-41721.md`：保持免疫，记录 NES data-commons 坐标
- [x] 2.3 更新 `doc/VULNERABILITY_REPORT.md` 概览表与 Spring Data Commons 章节
- [x] 2.4 更新 `doc/GAV_MAPPING.md` 增加 data-bom / data-commons → NES 映射

## 3. 需求与用户文档收口

- [x] 3.1 更新 `doc/REQUIREMENTS.md`：记录 NES Data BOM 与 NES data-commons
- [x] 3.2 更新 `doc/USER_MANUAL.md`：说明 optional NES data-commons 与 import 不变
- [x] 3.3 更新 `doc/QUICK_START.md`：下游解析 NES Data BOM SNAPSHOT 的提示
- [x] 3.4 更新 `doc/NEXUS_DEPLOY.md`：SNAPSHOT 解析范围含 NES Data BOM

## 4. 测试与一致性

- [x] 4.1 运行 `ProjectingMessageConverterTests`
- [x] 4.2 确认未把 CVE-2026-41711/41721 标为已修复
- [x] 4.3 确认未新增 Elasticsearch / Security 依赖，未修改兄弟仓
