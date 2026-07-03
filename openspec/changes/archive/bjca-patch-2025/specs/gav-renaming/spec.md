## ADDED Requirements

### Requirement: GroupId 去特征化

所有子模块的 GroupId 必须从 `org.springframework.kafka` 重命名为 `cn.bjca.footstone.bpring.kafka`。

#### Scenario: GroupId 重命名
- **WHEN** 构建任何子模块
- **THEN** Maven/Gradle 发布的 POM 中 `groupId` 为 `cn.bjca.footstone.bpring.kafka`

#### Scenario: 下游依赖引用
- **WHEN** 下游项目依赖本项目
- **THEN** 使用新的 GroupId `cn.bjca.footstone.bpring.kafka`
- **AND** 无需修改 Java 源代码中的 `import` 语句

### Requirement: ArtifactId 去特征化

所有子模块的 ArtifactId 必须添加 `bjca-footstone-bpring-` 前缀。

#### Scenario: 主模块重命名
- **WHEN** 构建 `spring-kafka` 模块
- **THEN** 发布的 ArtifactId 为 `bjca-footstone-bpring-kafka`

#### Scenario: 测试模块重命名
- **WHEN** 构建 `spring-kafka-test` 模块
- **THEN** 发布的 ArtifactId 为 `bjca-footstone-bpring-kafka-test`

#### Scenario: 文档模块重命名
- **WHEN** 构建 `spring-kafka-docs` 模块
- **THEN** 发布的 ArtifactId 为 `bjca-footstone-bpring-kafka-docs`

### Requirement: 版本号规范化

版本号必须遵循 `X.Y.Z-nes.patch.N-SNAPSHOT` 格式。

#### Scenario: 版本格式
- **WHEN** 检查 `gradle.properties` 中的 `version`
- **THEN** 版本号为 `2.9.13-nes.patch.1-SNAPSHOT`

#### Scenario: Gradle project.name 不变
- **WHEN** 执行 `./gradlew projects`
- **THEN** 项目显示名称仍为原始名称（如 `spring-kafka`）
- **AND** 仅 Maven POM 中的 artifactId 被重命名
