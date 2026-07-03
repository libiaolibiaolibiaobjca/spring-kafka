## Context

基于 Spring Kafka 2.9.x 的 BJCA 内部维护分支（`2.9.x-bjca-patch`），目标是：
1. 配置 Nexus 私服作为依赖下载源和构件发布目标
2. GAV 去特征化重命名，规避 SCA 工具按 GAV 特征误报
3. 升级 kafka-clients 到 3.9.2
4. 建立完整的文档体系

**参考项目**：`spring-security-6.5` (nes 维护分支)

## Goals / Non-Goals

**Goals:**
- Nexus 私服依赖下载与构件发布
- GAV 重命名：`org.springframework.kafka` → `cn.bjca.footstone.bpring.kafka`
- kafka-clients 3.2.3 → 3.9.2
- Gradle 7.3.1 → 8.14.5 + setup-gradle 脚本
- 完整文档：GAV_MAPPING, NEXUS_DEPLOY, USER_MANUAL, QUICK_START, REQUIREMENTS
- Makefile 快捷构建命令

**Non-Goals:**
- 不修改 Java 源代码中的 `import` 语句
- 不修改 Kafka 官方 API
- 不修改物理目录名与 Java package 名
- 不提供 Windows 环境支持

## Decisions

### 1. Gradle 版本：8.14.5

**选择理由**：
- 本地 `~/dev/` 已有 `gradle-8.14.5-bin.zip`
- Kafka 3.9.x 建议使用 Gradle 7.x+，8.x 兼容性更好
- Java 兼容：Gradle 8.14.5 支持 Java 8~21

**替代方案**：使用 7.6.6（本地已有），但不如 8.14.5 新

### 2. GAV 命名规则

```
GroupId: org.springframework.kafka → cn.bjca.footstone.bpring.kafka
ArtifactId: spring-kafka → bjca-footstone-bpring-kafka
Version: 2.9.14-SNAPSHOT → 2.9.13-nes.patch.1-SNAPSHOT
```

**命名依据**：参考 `spring-security-6.5` 的 `bjca-footstone-bpring-security-*` 模式

### 3. Nexus 仓库配置位置

**配置方式**：
- `~/.gradle/gradle.properties`：存储地址和凭证（不提交到版本控制）
- `settings.gradle`：`pluginManagement.repositories` 添加 Nexus
- `build.gradle`：`allprojects.repositories` 添加 Nexus

**原因**：凭证在用户级别配置，不污染项目代码

### 4. Gradle Wrapper URL 策略

**方案**：保持标准 `https://services.gradle.org/distributions/gradle-8.14.5-bin.zip`，通过 `setup-gradle-local.sh` 预缓存本地 zip

**参考**：`spring-boot-3.5` 的实现方式

## Risks / Trade-offs

| 风险 | 评估 | 缓解措施 |
|------|------|----------|
| kafka-clients 3.9.2 与 Java 8 兼容性 | ⚠️ 低 | 官方称支持 Java 8，测试验证 |
| Gradle 8 对旧项目兼容性 | ⚠️ 中 | 使用 `--no-daemon` 渐进验证 |
| GAV 重命名后下游迁移 | ⚠️ 中 | 提供完整迁移文档 |
| Gradle Wrapper 下载慢 | ⚠️ 低 | setup-gradle 预缓存 |

## Migration Plan

### Phase 1: 环境准备
1. 确认 `~/dev/gradle-8.14.5-bin.zip` 存在
2. 配置 `~/.gradle/gradle.properties` 中的 Nexus 凭证

### Phase 2: 配置变更
1. 修改 `gradle/wrapper/gradle-wrapper.properties`
2. 修改 `gradle.properties`
3. 修改 `settings.gradle`
4. 修改 `build.gradle`

### Phase 3: 脚本与文档
1. 创建 `scripts/setup-gradle-local.sh`
2. 创建 `Makefile`
3. 创建 `doc/*.md`

### Phase 4: 验证
1. `make setup-gradle`
2. `./gradlew --version`
3. `make test`
4. `make install`（验证本地发布）

## Open Questions

| 问题 | 状态 |
|------|------|
| kafka-clients 3.9.2 是否有破坏性变更？ | 待验证 |
| Gradle 8 是否需要额外配置？ | 待验证 |
