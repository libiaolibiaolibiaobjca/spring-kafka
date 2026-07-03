## ADDED Requirements

### Requirement: Nexus 私服依赖下载配置

所有子项目的依赖下载必须通过 Nexus 私服完成。

#### Scenario: SNAPSHOT 版本依赖解析
- **WHEN** 构建版本为 `*-SNAPSHOT`
- **THEN** `settings.gradle` 的 `pluginManagement.repositories` 包含 Nexus 快照仓库
- **AND** `build.gradle` 的 `allprojects.repositories` 包含 Nexus 公共仓库和快照仓库

#### Scenario: Release 版本依赖解析
- **WHEN** 构建版本为非 SNAPSHOT
- **THEN** `settings.gradle` 的 `pluginManagement.repositories` 仅包含 Nexus Release 仓库
- **AND** `build.gradle` 的 `allprojects.repositories` 包含 Nexus Release 仓库

### Requirement: Nexus 构件发布配置

所有 Maven 发布任务必须发布到 Nexus 私服。

#### Scenario: SNAPSHOT 版本发布
- **WHEN** 执行 `make deploy` 且版本以 `-SNAPSHOT` 结尾
- **THEN** 构件发布到 `nexusSnapshotUrl` (http://192.168.131.36:8088/repository/snapshots/)

#### Scenario: Release 版本发布
- **WHEN** 执行 `make deploy` 且版本不以 `-SNAPSHOT` 结尾
- **THEN** 构件发布到 `nexusReleaseUrl` (http://192.168.131.36:8088/repository/releases/)

### Requirement: Nexus 凭证管理

Nexus 认证凭证必须存储在用户级别 `~/.gradle/gradle.properties`，不提交到版本控制。

#### Scenario: 凭证缺失
- **WHEN** `~/.gradle/gradle.properties` 中缺少 `nexusUsername` 或 `nexusPassword`
- **THEN** 构建失败并提示配置 Nexus 凭证

#### Scenario: 凭证配置完整
- **WHEN** `~/.gradle/gradle.properties` 中配置了 `nexusUsername` 和 `nexusPassword`
- **THEN** Gradle 使用凭证访问 Nexus 仓库
