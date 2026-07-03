## Why

BJCA 维护分支需要建立标准的构建与发布流程：
1. **Nexus 私服**：统一依赖下载与构件发布渠道，隔离外网依赖
2. **GAV 去特征化**：重命名 Maven 坐标规避 SCA 工具按 GAV 特征误报 CVE
3. **kafka-clients 升级**：升级到 3.9.2 获取最新功能与安全修复
4. **文档化**：建立完整的用户文档与运维指南

## What Changes

- **Gradle 升级**：7.3.1 → 8.14.5 + setup-gradle 本地缓存脚本
- **kafka-clients 升级**：3.2.3 → 3.9.2
- **GAV 重命名**：
  - GroupId: `org.springframework.kafka` → `cn.bjca.footstone.bpring.kafka`
  - ArtifactId: `spring-kafka-*` → `bjca-footstone-bpring-kafka-*`
  - Version: `2.9.14-SNAPSHOT` → `2.9.13-nes.patch.1-SNAPSHOT`
- **Nexus 私服配置**：settings.gradle + build.gradle 配置私服仓库
- **文档创建**：
  - `doc/GAV_MAPPING.md` - GAV 映射表
  - `doc/NEXUS_DEPLOY.md` - Nexus 私服配置说明
  - `doc/USER_MANUAL.md` - 用户手册
  - `doc/QUICK_START.md` - 快速入门
  - `doc/REQUIREMENTS.md` - 需求与版本清单
- **Makefile**：构建快捷命令（setup-gradle, build, test, install, deploy 等）

## Capabilities

### New Capabilities

- `nexus-config`: Nexus 私服配置与凭证管理
- `gav-renaming`: GAV 去特征化重命名逻辑
- `kafka-upgrade`: kafka-clients 3.9.2 升级与兼容性验证
- `gradle-setup`: Gradle 8.14.5 本地分发包预安装机制
- `build-documentation`: 构建与发布相关文档

### Modified Capabilities

- （无）

## Impact

- **所有子模块**：`spring-kafka`, `spring-kafka-test`, `spring-kafka-docs`
- **配置文件**：`gradle.properties`, `settings.gradle`, `build.gradle`
- **Gradle Wrapper**：`gradle/wrapper/gradle-wrapper.properties`
- **新增文件**：`Makefile`, `scripts/setup-gradle-local.sh`, `doc/*.md`
- **下游影响**：依赖方需更新 GAV 坐标（文档已说明无需修改 import）
