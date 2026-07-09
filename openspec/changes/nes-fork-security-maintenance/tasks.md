## 0. 构建基线（阶段 0）

- [x] 0.1 确认 git 分支为 `3.3.x-bjca-patch`，工作区干净，提示用户已备份/确认分支状态
- [x] 0.2 编写 `scripts/setup-gradle-local.sh`：优先使用 `~/dev/gradle-8.14.5`，本地缺失时明确报错提示下载，禁用远程分发地址
- [x] 0.3 选定并激活 Java 17（sdkman，如 `17.0.15-amzn`），记录到 REQUIREMENTS
- [x] 0.4 使用本地 Gradle 8.14.5 离线跑通 `build`，确认无远程 Gradle 下载
- [x] 0.5 运行全量 `test` 建立**绿基线**（升级前基准），记录测试通过数
  - 基线（kafka-clients 3.8.1）：**998 用例，通过 991，跳过 7，失败 0，错误 0**；`BUILD SUCCESSFUL in 21m44s`；191 个测试报告文件

## 1. 安全调研（阶段 1）

- [x] 1.1 用联网权威源（Spring Security Advisories / Apache Kafka CVE List / NVD / GitHub Advisory）逐组件精准查询（主流程 WebSearch 可用；dependency-check + NVD 库已就绪作兜底）
- [x] 1.2 提取 3.3 实际依赖版本清单（Spring 6.2.19 / kafka 3.8.1 / Jackson 2.18.8 / Retry 2.0.13 / Data commons 3.4.13(bom 2024.1.13) / ZooKeeper 3.8.6 / Micrometer 1.14.14 / Reactor 2024.0.18）
  - 关键事实：spring-kafka 运行时**不依赖** spring-web/webmvc/webflux/security（仅 context/messaging/tx/aop/beans/core/expression/jcl）
- [x] 1.3 以 2.9 的 23 个 CVE 为交叉核对起点，逐条按 3.3 版本重新研判状态（写明版本比对依据）
- [x] 1.4 补充 3.3 特有的新 CVE（Spring Framework 6.2.x / Kafka 2026 / Spring Data / Micrometer 公告）
- [x] 1.5 为每个 CVE 生成 `doc/CVE/CVE-XXXX-XXXXX.md`（统一模板：基本信息/描述/受影响版本/修复版本/应对措施/参考链接）
  - 生成 27 个 CVE 独立文档，报告索引与文件完全一致、无悬空链接
- [x] 1.6 生成 `doc/VULNERABILITY_REPORT.md`（元信息/6态图标说明/依赖概览/分类表/统计/免疫机制/索引）
  - 27 条：✅已修复 16 / ⬜免疫 3 / ❌不适用 8 / 🔧⚠️⏸️ 0
- [ ] 1.7 向用户汇报调研结论与状态分布，确认后再进入升级阶段

## 2. 依赖安全升级（阶段 2，TDD）

- [x] 2.1 （测试先行）确认覆盖 kafka-clients 行为的现有测试，识别升级敏感用例（EmbeddedKafkaBroker、序列化、消费/生产）
  - 发现 KIP-1033 敏感点：RecoveringDeserializationExceptionHandlerTests
- [x] 2.2 修改 `build.gradle`：`kafkaVersion` 3.8.1 → 3.9.2
- [x] 2.3 确认 3.9.2 依赖从本地 `~/.m2` 私服解析成功（含 broker 端 kafka_2.13/kafka-server 等全部坐标）
- [x] 2.4 运行全量测试，与 0.5 基线对比，确保无回归；失败则定位兼容性问题
  - 已修复 KIP-1033 编译歧义（方案A：测试代码 7 处 `handle((ProcessorContext) null,...)` 显式转型 + 补 import，生产代码零改动）
  - **升级后回归：998 用例 / 991 通过 / 7 跳过 / 0 失败，与基线逐项一致，零回归**；`BUILD SUCCESSFUL in 16m49s`
- [ ] 2.5 更新 VULNERABILITY_REPORT 中因升级而转为「✅已修复」的 kafka CVE 状态

## 3. GAV 去特征化（阶段 3）

- [ ] 3.1 `gradle.properties`：新增 `projectGroup=cn.bjca.footstone.bpring.kafka`，`version` 改为 `3.3.16-nes.patch.1-SNAPSHOT`，记录基线 `springKafkaVersion=3.3.16`
- [ ] 3.2 `build.gradle`：定义 `bjcaArtifactIds` 映射（含 `spring-kafka-bom`→`bjca-footstone-bpring-kafka-bom`），`group = projectGroup`，`archivesName` 按映射改写
- [ ] 3.3 处理 `spring-kafka-bom/build.gradle`：BOM 坐标重命名 + 内部各模块 `<dependency>` 引用同步改为新 GAV
- [ ] 3.4 校验 pom 生成逻辑（manifest `Implementation-Vendor-Id`、pom-default.xml 的 groupId/artifactId）
- [ ] 3.5 执行 `publishToMavenLocal`，验证本地仓库出现 `cn/bjca/footstone/bpring/kafka/*` 制品与正确 BOM
- [ ] 3.6 确认 Java import 无需变更（抽查测试类）

## 4. Nexus 私服（阶段 4）

- [ ] 4.1 向用户获取 Nexus 私服地址与凭证来源（或确认 `~/.m2/settings.xml` 已含）
- [ ] 4.2 `settings.gradle` + `build.gradle` 配置私服仓库（依赖解析 + 发布 snapshot/release）
- [ ] 4.3 确认凭证从外部配置读取，脚本中无明文
- [ ] 4.4 执行发布任务验证制品成功推送到私服（用户确认后执行）

## 5. 文档与交付（阶段 5）

- [ ] 5.1 `doc/GAV_MAPPING.md`：GroupId/Version 规则 + 各模块 ArtifactId 映射（含 bom）+ 下游 XML 示例
- [ ] 5.2 `doc/NEXUS_DEPLOY.md`：私服配置、凭证来源、发布命令
- [ ] 5.3 `doc/REQUIREMENTS.md`：基线版本、依赖版本清单、环境需求（Java 17 / Gradle 8.14.5）
- [ ] 5.4 `doc/USER_MANUAL.md`：构建/测试/安装/依赖引用说明
- [ ] 5.5 `doc/QUICK_START.md`：最小上手步骤
- [ ] 5.6 `Makefile`：setup-gradle / build / test / install / deploy 目标
- [ ] 5.7 全部文档交叉校验版本号、GAV、CVE 索引链接一致性

## 6. 收尾验证

- [ ] 6.1 完整离线复现：clean → setup-gradle → build → test → publishToMavenLocal 全流程通过
- [ ] 6.2 向用户提交变更影响分析总结与最终状态，确认后归档 openspec change
