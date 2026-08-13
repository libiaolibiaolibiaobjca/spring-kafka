## 1. 依赖切换（构建）

- [x] 1.1 将 `springRetryVersion` / 坐标改为 NES `bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT`
- [x] 1.2 更新 `spring-kafka` 与 `spring-kafka-test` 的 `api` 依赖，并 exclude `cn.bjca.footstone.bpring` 与 `org.springframework`
- [x] 1.3 在 `allprojects.repositories` 增加 Nexus public 与 snapshots
- [x] 1.4 用 `dependencyInsight` 验证 runtimeClasspath 解析到 NES SNAPSHOT

## 2. 安全与 GAV 文档

- [x] 2.1 更新 `doc/CVE/CVE-2026-41710.md`（已缓解、NES SNAPSHOT、后续升已修复条件）
- [x] 2.2 更新 `doc/VULNERABILITY_REPORT.md`（概览表、已缓解章节、统计、索引）
- [x] 2.3 更新 `doc/GAV_MAPPING.md` 增加 spring-retry → NES retry 映射

## 3. 需求与用户文档收口

- [x] 3.1 更新 `doc/REQUIREMENTS.md`：记录 NES retry SNAPSHOT 依赖与 CVE-2026-41710 已缓解
- [x] 3.2 更新 `doc/USER_MANUAL.md`：说明传递 NES retry SNAPSHOT、Nexus snapshots、勿误标已修复
- [x] 3.3 更新 `doc/QUICK_START.md`：下游仓库与 SNAPSHOT 传递依赖提示（修正或标注 BOM 示例若仍不适用）
- [x] 3.4 更新 `doc/NEXUS_DEPLOY.md`：与当前 `allprojects` Nexus public/snapshots 配置一致

## 4. 一致性核对

- [x] 4.1 确认 OpenSpec proposal/design/specs/tasks 与工作区 diff 一致
- [x] 4.2 确认未把 CVE-2026-41710 标为已修复；确认文档写明勿对含该 SNAPSHOT 依赖的状态做新 RELEASE 闭环
- [x] 4.3 `openspec status` 显示 apply-ready；剩余仅文档任务已完成后可将本 change 视为实现完成（归档另议）

## 5. 版本线升级

- [x] 5.1 将 `gradle.properties` 的 `version` 升为 `2.9.13-nes.patch.2-SNAPSHOT`
- [x] 5.2 同步当前文档与 active OpenSpec change 中的本仓版本引用（不改 archive 历史）
- [x] 5.3 用 Gradle 确认项目 version 为 `2.9.13-nes.patch.2-SNAPSHOT`
