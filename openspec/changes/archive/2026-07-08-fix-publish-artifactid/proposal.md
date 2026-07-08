## Why

BJCA fork 的 `bjca-patch-2025` 只完成了 GAV 中 GroupId 和 Version 的重命名，artifactId 被遗漏：当前发布到 Nexus 的坐标仍是官方的 `spring-kafka` / `spring-kafka-test` / `spring-kafka-docs`。这与 `doc/GAV_MAPPING.md` 和已归档 spec `gav-renaming` 承诺的 `bjca-footstone-bpring-kafka*` 不一致，导致下游按文档声明的坐标依赖时无法解析，也削弱了「去 GAV 特征化以规避 SCA 误报」的初衷（SCA 仍能按 artifactId=spring-kafka 命中特征）。

## What Changes

- 在 Maven 发布层为三个模块显式设置 artifactId：
  - `spring-kafka` → `bjca-footstone-bpring-kafka`
  - `spring-kafka-test` → `bjca-footstone-bpring-kafka-test`
  - `spring-kafka-docs` → `bjca-footstone-bpring-kafka-docs`
- 用 `pom.withXml` 同步重写生成 POM 中的模块间依赖坐标，避免 `bjca-...-test` 的 POM 指向不存在的 `spring-kafka` 坐标。
- 设置 `archivesName`，使 jar 产物名也变为 `bjca-footstone-bpring-kafka*`。注意 `archivesName` 与发布 artifactId 相互独立，两者都需显式设置。
- 修正 `doc/GAV_MAPPING.md`：删除承诺 `bjca-footstone-bpring-kafka-bom` 的 BOM 示例（本次不新建 BOM 模块）。
- **硬约束**：不改 `settings.gradle` 的 include 名、目录结构、Gradle project.name（`./gradlew projects` 仍显示 `spring-kafka`），仅在 Maven 发布层重命名。

## Capabilities

### New Capabilities
- `publish-artifactid`: 定义 Maven 发布产物的 artifactId、jar 产物名、以及模块间依赖坐标必须使用 BJCA 重命名后的坐标，同时保持 Gradle project.name 不变。

### Modified Capabilities
<!-- 无 active spec；gav-renaming 已归档，本次以新 capability 承载 artifactId 契约 -->

## Impact

- `publish-maven.gradle` — mavenJava 发布块，新增 artifactId 覆盖。
- `build.gradle` — 第 225-243 行 `mavenJava` / `pom.withXml` 块，新增模块间依赖坐标重写；subprojects 配置新增 `archivesName`。
- `doc/GAV_MAPPING.md` — 删除 BOM 示例。
- 下游消费者：需按新 artifactId `bjca-footstone-bpring-kafka*` 声明依赖（此前文档已如此声明，实为使实现与文档对齐）。
- 无 Java 源码 / import 变更；无版本号变更。
