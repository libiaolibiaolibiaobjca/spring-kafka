# 快速入门 (Quick Start)

## 前置条件

- **JDK 17**（sdkman 管理，如 `sdk install java 17.0.15-amzn`）
- **Gradle 8.14.5** 分发包放在 `~/dev/`（`gradle-8.14.5-bin.zip`）
- 已配置内网 Nexus 属性到 `~/.gradle/gradle.properties`（见 [NEXUS_DEPLOY.md](NEXUS_DEPLOY.md)）

## 三步上手

```bash
# 1. 预置本地 Gradle 到 wrapper 缓存（离线构建，避免联网下载 Gradle）
make setup-gradle

# 2. 快速构建（跳过测试/文档/检查，验证编译）
make build-thin

# 3. 发布到本地 Maven 仓库，供同机其他项目依赖
make install
```

## 依赖本 fork 制品

`build.gradle` 或 `pom.xml` 中使用去特征化后的坐标：

```xml
<dependency>
    <groupId>cn.bjca.footstone.bpring.kafka</groupId>
    <artifactId>bjca-footstone-bpring-kafka</artifactId>
    <version>3.3.16-nes.patch.1-SNAPSHOT</version>
</dependency>
```

> Java 代码 `import org.springframework.kafka...` 无需改动。

## 常用命令速查

| 命令 | 用途 |
| :--- | :--- |
| `make help` | 查看全部命令 |
| `make test` | 运行全量测试 |
| `make build` | 全量构建（含测试与检查） |
| `make deploy` | 发布到 Nexus 私服 |
| `make stop` | 停止 Gradle Daemon |

## 遇到问题？

- Gradle 联网下载：确认已执行 `make setup-gradle`，且 `~/dev/gradle-8.14.5-bin.zip` 存在
- 依赖拉取慢/失败：确认 `~/.gradle/gradle.properties` 中 Nexus 属性正确
- 更多细节见 [USER_MANUAL.md](USER_MANUAL.md)
