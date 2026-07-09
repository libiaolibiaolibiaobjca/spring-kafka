## Context

本项目是 Spring for Apache Kafka 3.3 的 BJCA 内部安全维护 fork，当前位于分支 `3.3.x-bjca-patch`，基线版本 `3.3.17-SNAPSHOT`（最近已发布稳定版 `3.3.16`）。目标是复刻已完成的 `spring-kafka-2.9` NES fork 模式，但需适配 3.3 全新技术栈。

**当前状态（已核实）：**

| 维度 | 3.3 现状 | 2.9 对照 |
|---|---|---|
| Spring Framework | 6.2.19 | 5.3.x（运行时 NES 覆盖） |
| Java 基线 | 17 | 8 |
| kafka-clients | 3.8.1 | 3.9.2 |
| Spring Retry | 2.0.13（OSS 已修复） | 1.3.4（EOL） |
| Spring Data | 2024.1.13 | 2.7.x |
| ZooKeeper | 3.8.6 | 3.6.3 |
| 子模块 | 含 `spring-kafka-bom` | **无 bom 模块** |

**约束：**
- Gradle wrapper 精确需求 8.14.5，本地 `~/dev/gradle-8.14.5` 已解压，`~/dev/gradle-8.14.5-bin.zip` 也在。
- Java 17 由 sdkman 提供（`17.0.12-oracle` / `17.0.15-amzn` / `17.0.17-amzn`）。
- kafka-clients 3.9.2 已在本地 `~/.m2` 私服缓存；网络慢但内网私服快，**禁止使用远程分发地址**。
- 安全扫描工具 `~/dev/dependency-check12.1.3`（Core 12.1.3）可用。

## Goals / Non-Goals

**Goals:**
- 建立离线可复现的 Gradle 8.14.5 构建（无外网依赖）。
- 完成 kafka-clients 3.8.1 → 3.9.2 安全升级，测试全绿。
- 完成 GAV 去特征化（含新增 `spring-kafka-bom` 模块）。
- 配置 Nexus 私服发布通道。
- 产出基于 3.3 真实依赖树的漏洞报告体系（6 态归一化 + 每 CVE 独立文档）。
- 交付完整用户文档（手册、快速入门、需求清单、GAV 映射、Nexus 部署）。

**Non-Goals:**
- 不修改 Java 包名（`org.springframework.kafka.*` 保持不变）。
- 不改动 spring-kafka 业务逻辑与公共 API（仅坐标与依赖版本层面）。
- 不升级 Spring Framework / Jackson / Spring Data 等其它依赖（仅 kafka-clients）——除非调研发现必须。
- 不照搬 2.9 的 CVE 清单结论（状态须逐条基于 3.3 版本重新研判）。

## Decisions

### 决策 1：Gradle 本地化采用「预置 GRADLE_USER_HOME + 脚本软链」而非改 distributionUrl 指向 file://

- **选择**：新增 `scripts/setup-gradle-local.sh`，将 `~/dev/gradle-8.14.5` 注册为 wrapper 可识别的本地分发，或直接用本地 `gradle` 可执行文件构建，保留 `gradle-wrapper.properties` 原样（services.gradle.org URL 作为 fallback 但离线不触发）。
- **理由**：与 2.9 一致的做法，降低团队认知成本；wrapper 文件改 `file://` 路径会因机器绝对路径不同而不可移植。
- **备选**：改 `distributionUrl=file:///Users/anan/dev/...`（放弃——绑定个人绝对路径，不可提交共享）。

### 决策 2：kafka-clients 仅升 patch/minor 到 3.9.2，不跨大版本到 4.x

- **选择**：`kafkaVersion = '3.8.1'` → `'3.9.2'`。本地私服另有 4.1.2 / 4.2.1，但**不采用**。
- **理由**：3.9.x 与 3.8.x 同属 3.x 线，API 兼容风险最低；4.x 移除了 ZooKeeper 模式等，破坏性大。与 2.9 最终落点（3.9.2）一致，便于跨版本线协同。
- **备选**：升 4.x（放弃——破坏性变更多，超出安全维护范围）。

### 决策 3：`spring-kafka-bom` 模块的 GAV 重命名单独设计

- **选择**：将 bom 加入 `bjcaArtifactIds` 映射 → `bjca-footstone-bpring-kafka-bom`；BOM 内部对各模块的 `<dependency>` 坐标须同步改写为新 GAV。
- **理由**：3.3 独有此 `java-platform` 模块，2.9 无现成模板。BOM 若仍引用旧坐标，下游导入会拉不到 fork 制品。
- **备选**：不发布 bom（放弃——BOM 是 3.3 官方交付的一部分，缺失会降低可用性）。

### 决策 4：漏洞调研以「官方公告联网精准查询」为主，工具扫描作可选交叉核对，状态 6 态归一化

- **选择**：鉴于 3.3 依赖版本清单已完全明确（build.gradle `ext` 中硬编码），调研核心是「每个版本对应哪些 CVE + 在本库是否可利用」，而非「发现依赖」。因此以**联网查询权威源**（Spring Security Advisories、Apache Kafka CVE List、NVD、GitHub Advisory）逐组件精准研判为主路径，归入 6 态之一（✅已修复 / ⬜免疫 / ❌不适用 / 🔧修复中 / ⚠️已缓解 / ⏸️暂缓）。以 2.9 的 23 个 CVE 为交叉核对起点，`dependency-check` 12.1.3（本地 NVD 库已就绪）作为**可选兜底**，用于核对是否遗漏传递依赖 CVE。**结论一律以 3.3 实际版本为准**。
- **理由**：依赖清单已知使「扫描发现」步骤冗余；官方公告能直接读到攻击条件原文，便于准确判定「免疫/攻击面不存在」，比滤 dependency-check 误报更快更准；满足「全新独立调研」「避免知识幻觉」要求。
- **备选**：dependency-check 扫描为主（放弃——误报多、CPE 对 fork GAV 匹配不准、无法判定免疫，且发现步骤对已知清单冗余）；纯人工凭记忆（放弃——违反避免知识幻觉原则）。

### 决策 5：文档结构对齐 2.9，CVE 单文档采用固定模板

- **选择**：`doc/VULNERABILITY_REPORT.md`（总览+统计+免疫机制说明+索引）+ `doc/CVE/CVE-*.md`（基本信息表 / 漏洞描述 / 受影响版本 / 修复版本 / 本项目应对措施 / 参考链接）。
- **理由**：与 2.9、spring-boot-2.7 一致，便于安全团队跨项目核对。

## Risks / Trade-offs

- **kafka-clients 3.8→3.9 兼容性风险** → 缓解：严格 TDD，升级前先跑基线测试建立绿基准，升级后全量回归，重点验证 `spring-kafka-test` 的 `EmbeddedKafkaBroker`。
- **`spring-kafka-bom` 发布逻辑无模板** → 缓解：单列任务，先在本地 `publishToMavenLocal` 验证 bom 坐标与内部引用正确后再配私服。
- **GAV 重命名遗漏引用点**（manifest、pom 生成、archivesName、bom 内部依赖） → 缓解：以 2.9 `build.gradle` 的改造点清单为 checklist 逐项比对，构建后校验生成的 `pom-default.xml`。
- **dependency-check 首次运行需更新 NVD 库慢** → 缓解：内网私服可加速；若 NVD 拉取受阻，改用离线数据或以 2.9 清单 + 手工核对兜底，并在报告中标注调研方法。
- **CVE 状态误判**（3.3 与 2.9 版本不同易套错结论） → 缓解：每条 CVE 文档必须写明「受影响版本 vs 3.3 实际版本」的比对依据，不接受「参考 2.9」式结论。

## Migration Plan

分阶段推进，每阶段可独立验证、可回滚（git）：

1. **阶段 0 — 构建基线**：setup-gradle 脚本 + 离线跑通 `build`/`test`，建立绿基准。
2. **阶段 1 — 安全调研**：dependency-check 扫描 → 逐 CVE 研判 → 产出 VULNERABILITY_REPORT + CVE 文档。
3. **阶段 2 — 依赖升级**：kafka-clients 3.8.1→3.9.2 + TDD 回归。
4. **阶段 3 — GAV 去特征化**：改 group/version/artifactId + bom 处理 + `publishToMavenLocal` 验证。
5. **阶段 4 — Nexus 私服**：配置仓库与凭证 + 发布验证。
6. **阶段 5 — 文档交付**：USER_MANUAL / QUICK_START / REQUIREMENTS / GAV_MAPPING / NEXUS_DEPLOY / Makefile。

**回滚策略**：每阶段独立提交；GAV 与依赖升级为高风险阶段，失败则 `git revert` 对应提交，不影响已完成的文档阶段。

## Open Questions

- dependency-check 首次扫描能否在当前网络下更新 NVD 库？若不能，调研以何种离线数据兜底（待阶段 1 实测确认）。
- Nexus 私服的具体仓库地址与发布凭证由用户在阶段 4 提供（`~/.m2/settings.xml` 可能已含）。
- 是否需要发布 release（去 SNAPSHOT）版本，还是仅 SNAPSHOT——默认先 SNAPSHOT，release 时机由用户决定。
