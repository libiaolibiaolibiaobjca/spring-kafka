## 1. 环境准备

- [x] 1.1 确认 `~/dev/gradle-7.3.1-bin.zip` 存在
- [x] 1.2 确认 `~/.gradle/gradle.properties` 中 Nexus 凭证已配置
- [x] 1.3 备份当前配置（git commit 当前状态）

## 2. Gradle Wrapper 配置

- [x] 2.1 保持 Gradle 7.3.1（与上游 2.9.x 一致）
- [x] 2.2 创建 `scripts/setup-gradle-local.sh`（本地发行包缓存）
- [x] 2.3 验证 `./gradlew --version` 正常工作

## 3. Gradle 配置变更

- [x] 3.1 修改 `gradle.properties`：
  - 添加 `projectGroup=cn.bjca.footstone.bpring.kafka`
  - 修改 `version=2.9.13-nes.patch.1-SNAPSHOT`
  - 添加 `springKafkaVersion=2.9.13`
- [x] 3.2 修改 `settings.gradle`：
  - `pluginManagement.repositories` 添加 Nexus 私服仓库
- [x] 3.3 修改 `build.gradle`：
  - `allprojects { group = projectGroup }` GAV 重命名
  - `publishing.repositories` 配置 Nexus 发布目标（含 SNAPSHOT/release 自动选择）
  - 禁用不兼容插件（grgit, artifactory, asciidoctor）
  - JaCoCo 0.8.6 → 0.8.11（支持 JDK 17）

## 4. kafka-clients 升级（3.2.3 → 3.9.2）

- [x] 4.1 修改 `build.gradle` 中的 `kafkaVersion = '3.9.2'`
- [x] 4.2 添加 kafka-server、kafka-server-common 依赖
- [x] 4.3 修复 `DefaultKafkaProducerFactory.clientInstanceId()`（返回 `org.apache.kafka.common.Uuid`）
- [x] 4.4 修复 `EmbeddedKafkaBroker`：KafkaConfig 静态方法 → 字符串字面量
- [x] 4.5 修复 `KafkaTestUtils.getPropertyValue()`：捕获 `NotReadablePropertyException` 兼容 Kafka 3.x
- [x] 4.6 修复测试代码中反射访问 KafkaConsumer 属性的断言（条件判断 null）
- [x] 4.7 修复 `ToStringSerializationTests`：deserialize 方法歧义（显式类型转换）
- [x] 4.8 修复 `StringOrBytesSerializerTests`：UTF-8 字符串比较（`.toString()`）
- [x] 4.9 修复 `RecoveringDeserializationExceptionHandlerTests`：handle 方法歧义（显式 ProcessorContext 转换）
- [x] 4.10 执行 `make test` 验证全部测试通过（725 tests, 0 failed）
- [x] 4.11 执行 `make build` 验证 checkstyle 通过

## 5. Makefile 创建

- [x] 5.1 创建 `Makefile`（setup-gradle / clean / test / build / build-thin / install / deploy / stop / projects）

## 6. 文档创建

- [x] 6.1 创建 `doc/GAV_MAPPING.md`
- [x] 6.2 创建 `doc/NEXUS_DEPLOY.md`
- [x] 6.3 创建 `doc/USER_MANUAL.md`
- [x] 6.4 创建 `doc/QUICK_START.md`
- [x] 6.5 创建 `doc/REQUIREMENTS.md`

## 7. 验证与发布

- [x] 7.1 `make setup-gradle` 验证脚本
- [x] 7.2 `make build` 全量构建通过
- [x] 7.3 `make test` 测试通过
- [x] 7.4 `make deploy` 发布到 Nexus 私服成功
