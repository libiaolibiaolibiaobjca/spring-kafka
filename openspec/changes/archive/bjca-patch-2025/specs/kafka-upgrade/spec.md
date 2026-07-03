## ADDED Requirements

### Requirement: kafka-clients 版本升级

kafka-clients 必须从 3.2.3 升级到 3.9.2。

#### Scenario: 依赖版本更新
- **WHEN** 检查 `build.gradle` 中的 `kafkaVersion`
- **THEN** `kafkaVersion = '3.9.2'`

#### Scenario: 所有 kafka 模块同步
- **WHEN** 检查所有 kafka 相关依赖
- **THEN** `kafka-clients`, `kafka-streams`, `kafka-metadata`, `kafka-server-common`, `kafka_$scalaVersion` 等版本均为 3.9.2

### Requirement: Java 8 兼容性

kafka-clients 3.9.2 必须保持 Java 8 运行时兼容。

#### Scenario: 编译兼容性
- **WHEN** 使用 Java 8 编译项目
- **THEN** 所有模块编译成功（`./gradlew compileJava`）

#### Scenario: 测试兼容性
- **WHEN** 使用 Java 8 运行测试
- **THEN** 核心测试通过（`./gradlew test`）

### Requirement: Spring Framework 版本兼容性

Spring Framework 5.3.x 必须与 kafka-clients 3.9.2 兼容。

#### Scenario: 依赖解析
- **WHEN** 执行 `./gradlew dependencies`
- **THEN** 所有 kafka 依赖解析正确，无版本冲突

#### Scenario: spring-kafka 模块编译
- **WHEN** 执行 `./gradlew :spring-kafka:compileJava`
- **THEN** 编译成功，无类路径错误
