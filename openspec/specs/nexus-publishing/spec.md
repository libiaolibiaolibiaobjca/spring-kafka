# nexus-publishing Specification

## Purpose
TBD - created by archiving change nes-fork-security-maintenance. Update Purpose after archive.
## Requirements
### Requirement: Nexus 私服仓库配置

系统 SHALL 在构建配置中声明 Nexus 私服作为依赖解析与制品发布仓库，隔离外网依赖。

#### Scenario: 依赖从私服解析

- **WHEN** 构建解析依赖
- **THEN** 仓库配置 SHALL 优先指向内网 Nexus 私服，而非公网 Maven Central

#### Scenario: 制品发布到私服

- **WHEN** 执行发布任务
- **THEN** 制品 SHALL 发布到 Nexus 私服对应的 snapshot/release 仓库

### Requirement: 发布凭证安全管理

系统 SHALL 从外部配置（如 `~/.m2/settings.xml` 或 Gradle 属性）读取私服凭证，MUST NOT 将明文凭证硬编码进受版本控制的构建脚本。

#### Scenario: 凭证不入库

- **WHEN** 检查提交到版本库的构建脚本
- **THEN** 其中 SHALL NOT 包含明文用户名/密码，凭证来自本地未入库配置

