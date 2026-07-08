## Context

BJCA fork 通过 `bjca-patch-2025` 对 Spring Kafka 做了 GAV 去特征化，但只落实了 GroupId（`build.gradle:84` `group = projectGroup`）和 Version（`gradle.properties` `version`）。artifactId 依赖 Gradle `maven-publish` 的默认行为——取子项目名，即 `settings.gradle` 中 `include` 的 `spring-kafka` / `spring-kafka-test` / `spring-kafka-docs`——因而从未被重命名。

现有构建已在 `build.gradle` 的 `pom.withXml` 块中手工改写 POM（处理 providedImplementation 依赖），说明本项目已有直接操作 POM 的先例。模块间的唯一跨模块引用是 `spring-kafka` 对 `spring-kafka-test` 的 `testImplementation`（`build.gradle:366`）——test 作用域**不进发布 POM**；`spring-kafka-test` 本身不依赖主模块。因此实测下发布 POM 中并无 compile/api 作用域的模块间依赖。

约束来自已归档 spec `gav-renaming`：project.name 必须保持不变，只改 Maven POM 坐标。

## Goals / Non-Goals

**Goals:**
- 三模块发布 artifactId 变为 `bjca-footstone-bpring-kafka*`。
- 生成 POM 中模块间依赖坐标同步为新 artifactId，无悬空坐标。
- jar 产物名与新坐标一致。
- 文档与实现对齐（移除 BOM 示例）。

**Non-Goals:**
- 不新建 BOM 模块。
- 不改 GroupId / Version（已完成）。
- 不改 Gradle project.name / include 名 / 目录结构。
- 不改 Java 源码或 import。

## Decisions

### 决策 1：artifactId 与 archivesName 都显式设置
Gradle `maven-publish` 的发布 artifactId 默认等于 `project.name`，而 `archivesName`（jar 名）是独立属性，二者互不影响。因此在 subprojects 配置中为每个模块显式设置 `base.archivesName`（jar 名），并在 `mavenJava` 发布块显式设置 `artifactId`。

用统一映射：`bjca-footstone-bpring-` + `project.name`（因 `project.name` 已是 `kafka` 的变体 `spring-kafka*`，实际取 `project.name.replace('spring-', 'bjca-footstone-bpring-')`，或直接按模块显式赋值以避免歧义）。**倾向按模块显式赋值**——三个模块，显式更可读、更不易错。

*备选*：改 `settings.gradle` 的 include 名 → 被 spec 硬约束否决（会改 project.name、目录引用）。

### 决策 2：模块间依赖坐标用 pom.withXml 重写（防御性）
不依赖 Gradle 对 `project()` 依赖的坐标自动映射（其行为随版本/发布配置而变，且本项目 artifactId 是发布层覆盖而非 project.name，自动映射不会跟随）。沿用已有的 `pom.withXml` 模式，遍历 POM dependencies，将 `artifactId` 命中 `ext.bjcaArtifactIds` 键的节点改写为对应 `bjca-...` 坐标。

**实测发现**：当前发布 POM 中并无模块间 compile/api 依赖（唯一跨模块引用为 test 作用域，不进 POM），故此逻辑当前不命中任何节点，属防御性——保证将来若新增 api 作用域的模块间依赖时坐标自动正确、不产生悬空坐标。因实现成本极低且与现有 withXml 模式一致，保留而非删除。

### 决策 3：文档修正随构建一起改
`doc/GAV_MAPPING.md` 删除 BOM 示例段落，保持「文档=实现契约」。

## Risks / Trade-offs

- [pom.withXml 重写匹配不全，漏改某个依赖节点] → 用 spec 场景「无悬空坐标」验证：发布后 grep 生成的 POM 确认无 `spring-kafka` artifactId 依赖。
- [archivesName 设了但 artifactId 忘了设（或反之）] → design 决策 1 明确两者都设；tasks 拆成独立可勾选项，验证口径同时检查 jar 名与 POM 坐标。
- [下游已按当前（错误的）`spring-kafka` + 新 groupId 坐标临时依赖] → 属修正而非破坏：文档从未承诺 `spring-kafka` 坐标；变更后与文档一致。发布 SNAPSHOT，影响可控。
- [`project.name` 变体推导写错导致 docs 模块坐标错] → 按模块显式赋值，不用字符串推导。
