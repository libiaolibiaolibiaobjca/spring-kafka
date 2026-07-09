# Nexus 私服发布配置说明

## 概述

本项目基于 Spring for Apache Kafka 3.3.x 维护分支（`3.3.x-bjca-patch`），配置了 Nexus 私服作为依赖下载源和构建产物发布目标。所有子模块的依赖下载和 Maven 发布均通过内网 Nexus 私服完成，同时使用自定义 GroupId（`cn.bjca.footstone.bpring.kafka`）以区分官方发布、规避 SCA 误报。

## 修改文件清单

### 1. `gradle.properties`
- 添加 `projectGroup=cn.bjca.footstone.bpring.kafka`，定义全局 GroupId
- 修改 `version=3.3.16-nes.patch.1-SNAPSHOT`
- 添加 `springKafkaVersion=3.3.16`（原始基线版本，用于追溯）

### 2. `settings.gradle`
- 在 `pluginManagement.repositories` 中添加内网 Nexus 私服仓库（插件下载源）
- 实现 GAV 重命名逻辑（修改各子模块 `project.name`，对齐 spring-security-5.8 范式）

### 3. `build.gradle`
- 设置 `group = projectGroup`（替换原硬编码的 `org.springframework.kafka`）
- 在 `buildscript.repositories` 与 `allprojects.repositories` 添加内网 Nexus 私服作为依赖下载源
- 同步更新按 path 的 `project(':spring-kafka*')` 引用为新模块名

### 4. `gradle/publish-maven.gradle`
- 在 `publishing` 块添加 `repositories`，配置 Nexus 私服作为发布目标
- 根据版本号自动选择目标仓库：`-SNAPSHOT` → 快照仓库，Release → 正式仓库

## Nexus 属性配置要求

需要在 `~/.gradle/gradle.properties`（用户级，不入库）中配置以下属性：

```properties
# Nexus 私服地址
nexusPublicUrl=http://192.168.131.36:8088/repository/maven-public/
nexusReleaseUrl=http://192.168.131.36:8088/repository/releases/
nexusSnapshotUrl=http://192.168.131.36:8088/repository/snapshots/

# Nexus 认证凭证
nexusUsername=developer
nexusPassword=********

# 内网 HTTP 允许（非 HTTPS）
systemProp.http.allowInsecureProtocol=true
```

**注意事项：**
- 这些属性配置在用户级别的 `~/.gradle/gradle.properties` 中，**不会提交到版本控制**，凭证不入库。
- `nexusPublicUrl` 用于依赖下载（pluginManagement 与 allprojects 仓库）
- `nexusReleaseUrl` 和 `nexusSnapshotUrl` 用于 Maven 发布，根据版本号是否含 `-SNAPSHOT` 自动选择

## 发布流程

### 本地验证发布（推荐先行）

```bash
make install    # 发布到本地 ~/.m2/repository，验证坐标正确
```

验证本地仓库出现 `~/.m2/repository/cn/bjca/footstone/bpring/kafka/*` 制品，
并检查 BOM 的 `pom` 内部 constraints 坐标是否正确。

### 发布到 Nexus 私服

```bash
make deploy     # 发布到 Nexus 私服（跳过测试，docs 模块不发布）
```

对应 Gradle 命令：`./gradlew clean publishAllPublicationsToNexusRepository -x test`

## 发布产物清单

| 模块 | 产物 |
| :--- | :--- |
| bjca-footstone-bpring-kafka | jar + pom + sources + javadoc |
| bjca-footstone-bpring-kafka-test | jar + pom + sources + javadoc |
| bjca-footstone-bpring-kafka-bom | pom（java-platform，无 jar） |
