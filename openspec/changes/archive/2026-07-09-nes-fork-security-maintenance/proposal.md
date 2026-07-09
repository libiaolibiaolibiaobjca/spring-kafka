## Why

BJCA（北京数字认证）内部维护分支需要将 Spring for Apache Kafka 3.3 建立为一条可持续维护的 **NES 安全分支**，对齐已完成的 `spring-kafka-2.9`、`spring-boot-2.7`、`spring-data-keyvalue-2.7`、`spring-framework-5.3` 同源 fork 模式。核心动因有四：

1. **安全合规**：需要一份可审计的漏洞状态总览（VULNERABILITY_REPORT）+ 每 CVE 独立留档，覆盖 6 态归一化，供 SCA 工具与安全团队核对。
2. **GAV 去特征化**：重命名 Maven 坐标，规避 SCA 工具按原始 GAV 特征对 fork 制品的误报。
3. **依赖安全升级**：将 `kafka-clients` 从 3.8.1 升级到 3.9.2，获取上游安全修复（本地私服已缓存，无需外网）。
4. **交付物完整性**：建立私服（Nexus）发布通道、构建快捷入口（Makefile）与完整用户文档，隔离外网依赖。

> ⚠️ **与 2.9 的关键差异**：3.3 技术栈已整体跃迁（Spring Framework 6.2.19、Java 17 基线、Spring Retry 2.0.13、Spring Data 2024.1.13），**CVE 清单不能照搬 2.9**，必须基于 3.3 实际依赖树做一次全新独立调研（dependency-check 12.1.3 扫描 + 逐依赖人工研判）。

## What Changes

- **Gradle 本地化**：新增 `setup-gradle` 脚本，指向 `~/dev/gradle-8.14.5` 本地分发包（wrapper 精确需求 8.14.5），全程离线构建。
- **kafka-clients 升级**：`3.8.1` → `3.9.2`（`kafkaVersion` 属性），含 `kafka-streams`、`kafka-server` 等同步升级，需 TDD 回归验证兼容性。
- **GAV 去特征化**（**BREAKING** —— 下游需更新 Maven 坐标）：
  - GroupId: `org.springframework.kafka` → `cn.bjca.footstone.bpring.kafka`
  - ArtifactId: `spring-kafka-*` → `bjca-footstone-bpring-kafka-*`（含 3.3 新增的 `spring-kafka-bom` 模块）
  - Version: `3.3.17-SNAPSHOT` → `3.3.16-nes.patch.1-SNAPSHOT`
- **Nexus 私服配置**：`settings.gradle` + `build.gradle` 配置私服仓库与发布凭证。
- **安全漏洞报告体系**：
  - `doc/VULNERABILITY_REPORT.md` —— 漏洞状态总览（6 态归一化）
  - `doc/CVE/CVE-XXXX-XXXXX.md` —— 每 CVE 一份独立文档
- **文档交付**：
  - `doc/GAV_MAPPING.md` —— GAV 映射表
  - `doc/NEXUS_DEPLOY.md` —— Nexus 私服配置说明
  - `doc/USER_MANUAL.md` —— 用户手册
  - `doc/QUICK_START.md` —— 快速入门
  - `doc/REQUIREMENTS.md` —— 需求与依赖版本清单
- **Makefile**：构建快捷命令（setup-gradle / build / test / install / deploy 等）。

## Capabilities

### New Capabilities

- `gradle-setup`: Gradle 8.14.5 本地分发包预安装与离线构建机制。
- `kafka-clients-upgrade`: kafka-clients 3.8.1 → 3.9.2 升级与兼容性回归验证。
- `gav-renaming`: GAV 去特征化重命名逻辑（含 `spring-kafka-bom` 模块的 java-platform 坐标处理）。
- `nexus-publishing`: Nexus 私服仓库配置与制品发布通道。
- `vulnerability-management`: 漏洞状态调研、6 态归一化与 CVE 文档体系。
- `build-documentation`: 构建、发布与使用相关的用户文档交付。

### Modified Capabilities

- （无 —— 当前 `openspec/specs/` 为空，本次全部为新增能力）

## Impact

- **所有子模块**：`spring-kafka`、`spring-kafka-test`、`spring-kafka-docs`、`spring-kafka-bom`（3.3 新增）。
- **构建配置**：`gradle.properties`（新增 `projectGroup`、改 `version`、升 `kafkaVersion`）、`settings.gradle`、`build.gradle`、`spring-kafka-bom/build.gradle`。
- **Gradle Wrapper**：`gradle/wrapper/gradle-wrapper.properties`（本地分发指向）。
- **新增文件**：`Makefile`、`scripts/setup-gradle-local.sh`、`doc/*.md`、`doc/CVE/*.md`。
- **依赖变更**：`kafka-clients` / `kafka-streams` / `kafka-server*` 3.8.1 → 3.9.2。
- **下游影响**：依赖方需更新 GAV 坐标；Java 代码 `import org.springframework.kafka...` 无需修改。
- **潜在风险点**：
  - kafka-clients 3.8→3.9 的 API/行为兼容性（测试须全绿）。
  - `spring-kafka-bom` 模块在 2.9 不存在，其 java-platform 发布逻辑无现成模板，需单独设计。
  - GAV 重命名后 BOM 内部对各模块的坐标引用需同步改写。
