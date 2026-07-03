# 快速入门指南

## 环境要求

| 组件 | 版本 |
|------|------|
| JDK | 8+（推荐 `sdk use java 17.0.17-amzn`，Gradle 8.x 要求） |
| Gradle | 8.14.5（wrapper 已配置，通过 setup-gradle 预缓存） |
| Nexus 凭证 | 配置于 `~/.gradle/gradle.properties` |

## 构建命令

```bash
# 查看可用命令
make help

# 预缓存本地 Gradle（如果 ~/dev/ 下有 gradle-8.14.5-bin.zip）
make setup-gradle

# 快速编译（跳过测试）
make build-thin

# 运行单元测试
make test

# 发布到本地 ~/.m2
make install

# 发布到 Nexus 私服
make deploy
```

## 下游依赖示例

```xml
<dependency>
    <groupId>cn.bjca.footstone.bpring.kafka</groupId>
    <artifactId>bjca-footstone-bpring-kafka</artifactId>
    <version>2.9.13-nes.patch.1-SNAPSHOT</version>
</dependency>
```

在 `dependencyManagement` 中引入 BOM：

```xml
<dependency>
    <groupId>cn.bjca.footstone.bpring.kafka</groupId>
    <artifactId>bjca-footstone-bpring-kafka-bom</artifactId>
    <version>2.9.13-nes.patch.1-SNAPSHOT</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

## 常见问题

- **Gradle 下载慢**：执行 `make setup-gradle` 预缓存本地 zip
- **Nexus 认证失败**：检查 `~/.gradle/gradle.properties` 中的 `nexusUsername` / `nexusPassword`
