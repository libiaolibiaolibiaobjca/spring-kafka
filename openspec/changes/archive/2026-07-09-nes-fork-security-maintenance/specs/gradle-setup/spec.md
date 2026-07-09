## ADDED Requirements

### Requirement: Gradle 本地分发离线构建

系统 SHALL 使用本地 Gradle 8.14.5 分发包完成全部构建，MUST NOT 依赖 `services.gradle.org` 等远程分发地址下载 Gradle 本体。

#### Scenario: 使用本地 Gradle 分发构建成功

- **WHEN** 执行构建前运行 `scripts/setup-gradle-local.sh`，且本地 `~/dev/gradle-8.14.5` 存在
- **THEN** 构建使用本地 Gradle 8.14.5，不触发任何 Gradle 分发包的远程下载

#### Scenario: 本地 Gradle 版本与 wrapper 需求一致

- **WHEN** 校验 `gradle/wrapper/gradle-wrapper.properties` 声明的版本
- **THEN** 其版本 SHALL 为 8.14.5，与 `~/dev/gradle-8.14.5` 精确匹配

#### Scenario: 本地缺少所需 Gradle 版本时明确提示

- **WHEN** `~/dev` 下不存在 8.14.5 分发包
- **THEN** setup 脚本 SHALL 输出清晰错误，提示用户下载对应版本放入 `~/dev`，而非回退到远程地址
