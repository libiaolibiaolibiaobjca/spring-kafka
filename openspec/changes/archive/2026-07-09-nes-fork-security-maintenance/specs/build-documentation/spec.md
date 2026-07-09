## ADDED Requirements

### Requirement: 用户文档交付

系统 SHALL 交付完整的用户文档，至少包括用户手册（USER_MANUAL）与快速入门（QUICK_START）。

#### Scenario: 用户手册与快速入门存在

- **WHEN** 检查 `doc/` 目录
- **THEN** SHALL 存在 `USER_MANUAL.md` 与 `QUICK_START.md`，说明如何构建、测试、安装与依赖本 fork 制品

### Requirement: 需求与依赖版本清单

系统 SHALL 交付 `doc/REQUIREMENTS.md`，记录基线版本、依赖版本清单与变更需求。

#### Scenario: 需求清单反映实际版本

- **WHEN** 打开 `doc/REQUIREMENTS.md`
- **THEN** SHALL 记录 spring-kafka 基线版本、kafka-clients 目标版本 3.9.2、Java 17、Gradle 8.14.5 等关键版本

### Requirement: GAV 映射文档

系统 SHALL 交付 `doc/GAV_MAPPING.md`，记录原始与新 GAV 的完整映射及下游依赖示例。

#### Scenario: GAV 映射表完整

- **WHEN** 打开 `doc/GAV_MAPPING.md`
- **THEN** SHALL 列出 GroupId/Version 全局规则、各模块 ArtifactId 映射（含 bom）与下游依赖 XML 示例

### Requirement: Nexus 部署文档

系统 SHALL 交付 `doc/NEXUS_DEPLOY.md`，说明私服配置与发布流程。

#### Scenario: Nexus 部署说明可操作

- **WHEN** 打开 `doc/NEXUS_DEPLOY.md`
- **THEN** SHALL 说明私服仓库配置、凭证来源与发布命令

### Requirement: Makefile 构建入口

系统 SHALL 提供 `Makefile`，封装 setup-gradle、build、test、install、deploy 等常用命令。

#### Scenario: Makefile 提供快捷命令

- **WHEN** 检查 `Makefile`
- **THEN** SHALL 包含 setup-gradle、build、test、install、deploy 等目标
