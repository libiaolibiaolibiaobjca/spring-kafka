# publish-artifactid Specification

## Purpose
TBD - created by archiving change fix-publish-artifactid. Update Purpose after archive.
## Requirements
### Requirement: 发布 artifactId 去特征化

三个子模块发布到 Maven/Nexus 的 POM 中，`artifactId` MUST 使用 BJCA 重命名后的坐标，添加 `bjca-footstone-bpring-` 前缀。

#### Scenario: 主模块 artifactId
- **WHEN** 构建并发布 `spring-kafka` 模块
- **THEN** 生成 POM 的 `artifactId` 为 `bjca-footstone-bpring-kafka`
- **AND** `groupId` 为 `cn.bjca.footstone.bpring.kafka`

#### Scenario: 测试模块 artifactId
- **WHEN** 构建并发布 `spring-kafka-test` 模块
- **THEN** 生成 POM 的 `artifactId` 为 `bjca-footstone-bpring-kafka-test`

#### Scenario: 文档模块 artifactId
- **WHEN** 构建并发布 `spring-kafka-docs` 模块
- **THEN** 生成 POM 的 `artifactId` 为 `bjca-footstone-bpring-kafka-docs`

### Requirement: 模块间依赖坐标一致

生成 POM 中对本项目其他模块的依赖，其 `artifactId` MUST 指向重命名后的坐标，不得指向不存在的官方坐标。

#### Scenario: 测试模块依赖主模块
- **WHEN** 检查 `bjca-footstone-bpring-kafka-test` 发布的 POM 依赖列表
- **THEN** 对主模块的依赖 `artifactId` 为 `bjca-footstone-bpring-kafka`
- **AND** 不出现 `artifactId` 为 `spring-kafka` 的依赖

#### Scenario: 无悬空坐标
- **WHEN** 检查任一模块发布的 POM
- **THEN** 所有本项目模块间依赖坐标均可在 Nexus 上解析（无 `spring-kafka*` 悬空坐标）

### Requirement: jar 产物名与发布坐标一致

构建产出的 jar 文件名 MUST 使用 `bjca-footstone-bpring-kafka*` 命名。

#### Scenario: 主模块 jar 名
- **WHEN** 执行构建生成主模块 jar
- **THEN** `build/libs/` 中的 jar 名为 `bjca-footstone-bpring-kafka-<version>.jar`

#### Scenario: 测试模块 jar 名
- **WHEN** 执行构建生成测试模块 jar
- **THEN** jar 名为 `bjca-footstone-bpring-kafka-test-<version>.jar`

### Requirement: Gradle project.name 保持不变

artifactId 重命名 MUST 仅作用于 Maven 发布层，不改变 Gradle 的项目结构与项目名。

#### Scenario: 项目名不变
- **WHEN** 执行 `./gradlew projects`
- **THEN** 项目显示名称仍为原始名称 `spring-kafka` / `spring-kafka-test` / `spring-kafka-docs`
- **AND** `settings.gradle` 的 `include` 名称与目录结构未变更

### Requirement: 文档不承诺未构建的 BOM

`doc/GAV_MAPPING.md` MUST NOT 声明本项目提供 `bjca-footstone-bpring-kafka-bom`，因为本次不构建 BOM 模块。

#### Scenario: 移除 BOM 示例
- **WHEN** 阅读 `doc/GAV_MAPPING.md`
- **THEN** 不包含引用 `bjca-footstone-bpring-kafka-bom` 的依赖示例

