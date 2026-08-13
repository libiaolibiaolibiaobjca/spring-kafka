# kafka-header-deserialization-security Specification

## Purpose

定义 Kafka JSON 类型 Header 的受信包边界、兼容行为、回归验证和安全文档要求，防止不可信 Producer 利用类型 Header 触发任意 JDK 类型反序列化。

## Requirements

### Requirement: Kafka Header 类型必须按精确包名信任
`DefaultKafkaHeaderMapper` MUST 仅信任声明包与受信包列表项完全相等的类型，且 MUST NOT 因父包受信而自动信任其子包。

#### Scenario: 默认 JDK 包中的类型保持可信
- **WHEN** Header 类型属于默认受信包 `java.lang`、`java.net` 或 `java.util`
- **THEN** Mapper 将该类型判定为可信并按现有规则反序列化

#### Scenario: 默认 JDK 包的子包不被传递信任
- **WHEN** Header 类型属于 `java.lang.reflect`、`java.util.concurrent` 或 `java.util.logging`
- **THEN** Mapper 将该类型判定为不可信
- **AND** Header 值以 `NonTrustedHeaderType` 形式交给应用

#### Scenario: 业务子包必须显式加入
- **WHEN** 调用方只将 `com.example` 加入受信包且 Header 类型属于 `com.example.events`
- **THEN** Mapper 将该类型判定为不可信
- **WHEN** 调用方再显式加入 `com.example.events`
- **THEN** Mapper 将该类型判定为可信

### Requirement: 显式全信任配置保持兼容
`DefaultKafkaHeaderMapper` MUST 保留 `addTrustedPackages("*")` 的既有行为，使主动选择该配置的调用方能够信任所有包。

#### Scenario: 通配符信任全部包
- **WHEN** 调用方显式调用 `addTrustedPackages("*")`
- **THEN** Mapper 将任意合法类名的包判定为可信

### Requirement: 安全修复必须具备回归验证
项目 MUST 提供自动化测试，覆盖精确包匹配、子包拒绝、显式子包加入和通配符兼容行为。

#### Scenario: 执行 Header Mapper 测试
- **WHEN** 执行 `DefaultKafkaHeaderMapperTests`
- **THEN** 所有包信任边界测试通过
- **AND** 现有 Header 映射行为测试不发生回归

### Requirement: CVE 修复状态必须可审计
项目 MUST 维护 CVE-2026-41731 独立文档、漏洞总览和用户迁移说明，并 MUST 确保首次 RELEASE 的内部补丁制品包含该修复。

#### Scenario: 查看漏洞文档
- **WHEN** 维护人员查阅 `doc/CVE/CVE-2026-41731.md` 和 `doc/VULNERABILITY_REPORT.md`
- **THEN** 文档说明受影响范围、触发条件、内部修复方式、验证方法和参考链接

#### Scenario: 查看调用方迁移说明
- **WHEN** 调用方查阅用户文档中的 Kafka Header 安全配置章节
- **THEN** 文档明确父包不再传递信任子包
- **AND** 给出显式添加业务子包的配置示例

#### Scenario: 构建安全修复制品
- **WHEN** 构建 `2.9.13-nes.patch.1` 及之后的开发线（含当前 `2.9.13-nes.patch.2-SNAPSHOT`）
- **THEN** 产物包含 CVE-2026-41731 修复
