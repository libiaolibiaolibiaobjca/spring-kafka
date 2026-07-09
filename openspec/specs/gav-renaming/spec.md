# gav-renaming Specification

## Purpose
TBD - created by archiving change nes-fork-security-maintenance. Update Purpose after archive.
## Requirements
### Requirement: GroupId 与 Version 去特征化

系统 SHALL 将所有可发布模块的 GroupId 从 `org.springframework.kafka` 重命名为 `cn.bjca.footstone.bpring.kafka`，Version 从 `3.3.17-SNAPSHOT` 改为 `3.3.16-nes.patch.1-SNAPSHOT`。

#### Scenario: 发布制品使用新 GroupId

- **WHEN** 构建生成任一模块的 pom
- **THEN** 其 `<groupId>` SHALL 为 `cn.bjca.footstone.bpring.kafka`，`<version>` SHALL 为 `3.3.16-nes.patch.1-SNAPSHOT`

### Requirement: ArtifactId 前缀重命名

系统 SHALL 将各模块 ArtifactId 前缀 `spring-kafka` 重命名为 `bjca-footstone-bpring-kafka`，覆盖全部可发布模块，包括 3.3 新增的 `spring-kafka-bom`。

#### Scenario: 各模块 ArtifactId 映射正确

- **WHEN** 检查生成制品的 ArtifactId
- **THEN** 映射 SHALL 为：`spring-kafka`→`bjca-footstone-bpring-kafka`、`spring-kafka-test`→`bjca-footstone-bpring-kafka-test`、`spring-kafka-docs`→`bjca-footstone-bpring-kafka-docs`、`spring-kafka-bom`→`bjca-footstone-bpring-kafka-bom`

#### Scenario: Java 包名保持不变

- **WHEN** 下游代码 `import org.springframework.kafka.*`
- **THEN** 无需修改任何 import，包名 SHALL 保持 `org.springframework.kafka`

### Requirement: BOM 内部坐标同步改写

系统 SHALL 确保 `spring-kafka-bom` 内部对各模块的依赖声明使用重命名后的新 GAV。

#### Scenario: BOM 引用新坐标

- **WHEN** 下游导入 `bjca-footstone-bpring-kafka-bom`
- **THEN** BOM 中列出的模块坐标 SHALL 全部为 `cn.bjca.footstone.bpring.kafka:bjca-footstone-bpring-kafka-*`，可正确解析到 fork 制品

### Requirement: publishToMavenLocal 验证

系统 SHALL 支持通过 `publishToMavenLocal` 在本地验证重命名后的坐标与 BOM 引用正确性。

#### Scenario: 本地发布校验坐标

- **WHEN** 执行 `publishToMavenLocal`
- **THEN** 本地仓库 SHALL 出现 `cn/bjca/footstone/bpring/kafka/bjca-footstone-bpring-kafka-*` 路径下的制品与 pom

