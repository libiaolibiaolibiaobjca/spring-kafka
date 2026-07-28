# 用户手册 (User Manual)

## 一、项目简介

本项目是 Spring for Apache Kafka **3.3.16** 的 BJCA 内部安全维护 fork，位于分支
`3.3.x-bjca-patch`，制品坐标 `cn.bjca.footstone.bpring.kafka:bjca-footstone-bpring-kafka:3.3.16-nes.patch.1`。

与官方版本的差异：
- **安全升级**：kafka-clients 由 3.8.1 升级到 3.9.2（修复 5 个 CVE）
- **GAV 去特征化**：坐标改为内部私有域名，规避 SCA 误报
- **内网构建**：依赖下载与发布走内网 Nexus 私服
- **Java 包名不变**：`org.springframework.kafka` 保持不变，下游无感

## 二、环境准备

### 2.1 JDK 17

使用 sdkman 安装并激活：

```bash
sdk install java 17.0.15-amzn
sdk use java 17.0.15-amzn
```

### 2.2 Gradle 8.14.5（本地离线）

将 `gradle-8.14.5-bin.zip` 放到 `~/dev/`，然后：

```bash
make setup-gradle
```

该命令调用 `scripts/setup-gradle-local.sh`，按 Gradle Wrapper 的 MD5-base36 规则
将本地 zip 预置到 `~/.gradle/wrapper/dists/`，之后 `./gradlew` 自动使用本地分发包，
无需联网下载。

> 若 `~/dev` 下无 8.14.5，脚本会明确报错提示下载，不会回退到远程地址。

### 2.3 Nexus 私服属性

在 `~/.gradle/gradle.properties` 配置 Nexus 地址与凭证（详见 [NEXUS_DEPLOY.md](NEXUS_DEPLOY.md)）。

## 三、构建与测试

| 命令 | 说明 | 耗时 |
| :--- | :--- | :--- |
| `make build-thin` | 快速构建（跳过测试/文档/检查） | 短 |
| `make build` | 全量构建（含测试与 checkstyle 等） | 长（约 20 分钟） |
| `make test` | 仅运行测试 | 约 17-22 分钟 |
| `make clean` | 清理构建产物 | 短 |

> 测试涉及 `EmbeddedKafkaBroker`，耗时较长。当前基线全量测试：998 用例 / 991 通过 / 7 跳过 / 0 失败。

## 四、发布

### 4.1 本地仓库（调试用）

```bash
make install
```

制品发布到 `~/.m2/repository/cn/bjca/footstone/bpring/kafka/`。

### 4.2 Nexus 私服

```bash
make deploy
```

按版本号自动选择快照/正式仓库（`-SNAPSHOT` → 快照仓库）。

## 五、依赖本 fork

### Gradle

```groovy
implementation 'cn.bjca.footstone.bpring.kafka:bjca-footstone-bpring-kafka:3.3.16-nes.patch.1'
```

### Maven

```xml
<dependency>
    <groupId>cn.bjca.footstone.bpring.kafka</groupId>
    <artifactId>bjca-footstone-bpring-kafka</artifactId>
    <version>3.3.16-nes.patch.1</version>
</dependency>
```

### 通过 BOM 统一管理版本

见 [GAV_MAPPING.md](GAV_MAPPING.md) 的 BOM 使用示例。

## 六、安全漏洞状态

本 fork 维护完整的漏洞状态报告：
- 总览：[VULNERABILITY_REPORT.md](VULNERABILITY_REPORT.md)（27 条 CVE，6 态归一化）
- 每 CVE 独立文档：`CVE/` 目录

状态定义：✅已修复 / ⬜免疫 / ❌不适用 / 🔧修复中 / ⚠️已缓解 / ⏸️暂缓。

## 七、故障排查

| 现象 | 排查 |
| :--- | :--- |
| Gradle 尝试联网下载分发包 | 执行 `make setup-gradle`；确认 `~/dev/gradle-8.14.5-bin.zip` 存在 |
| 依赖解析失败/极慢 | 确认 `~/.gradle/gradle.properties` 中 `nexusPublicUrl` 等属性正确 |
| 发布 401/403 | 确认 `nexusUsername`/`nexusPassword` 正确且有对应仓库权限 |
| 构建内存溢出 | 调整 `~/.gradle/gradle.properties` 的 `org.gradle.jvmargs` |
| Gradle Daemon 占用/锁 | `make stop` |
