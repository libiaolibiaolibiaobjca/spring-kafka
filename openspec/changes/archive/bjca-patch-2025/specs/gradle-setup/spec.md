## ADDED Requirements

### Requirement: Gradle Wrapper 版本升级

Gradle Wrapper 必须从 7.3.1 升级到 8.14.5。

#### Scenario: Wrapper 配置更新
- **WHEN** 检查 `gradle/wrapper/gradle-wrapper.properties`
- **THEN** `distributionUrl` 为 `https://services.gradle.org/distributions/gradle-8.14.5-bin.zip`
- **AND** 包含正确的 `distributionSha256Sum`

### Requirement: setup-gradle-local.sh 脚本

必须提供 `scripts/setup-gradle-local.sh` 脚本用于预缓存本地 Gradle 分发包。

#### Scenario: 脚本位置
- **WHEN** 检查项目根目录
- **THEN** 存在 `scripts/setup-gradle-local.sh` 文件
- **AND** 文件具有可执行权限

#### Scenario: 默认扫描目录
- **WHEN** 执行 `make setup-gradle`
- **THEN** 脚本扫描 `~/dev/` 目录下的 `gradle-*-bin.zip` 和 `gradle-*-all.zip`

#### Scenario: 缓存目录计算
- **WHEN** 脚本处理 `gradle-8.14.5-bin.zip`
- **THEN** 使用 MD5(https://services.gradle.org/distributions/gradle-8.14.5-bin.zip) 计算 hash
- **AND** 将文件复制到 `~/.gradle/wrapper/dists/gradle-8.14.5-bin/{hash}/`

#### Scenario: 已就绪跳过
- **WHEN** 缓存目录已存在 `.zip.ok` 标记
- **THEN** 脚本跳过该分发包并输出 "已就绪"

### Requirement: Makefile 集成

Makefile 必须集成 setup-gradle 作为所有构建命令的前置依赖。

#### Scenario: 构建命令依赖
- **WHEN** 执行 `make clean`, `make build`, `make test` 等命令
- **THEN** 首先执行 `setup-gradle` 目标

#### Scenario: 帮助信息
- **WHEN** 执行 `make help`
- **THEN** 显示所有可用命令及其说明
