# 快速入门指南

## 环境要求

| 组件 | 版本 |
|------|------|
| JDK | 8+（推荐 `sdk use java 17.0.17-amzn`，Gradle 8.x 要求） |
| Gradle | 8.14.5（wrapper 已配置，通过 setup-gradle 预缓存） |
| Nexus 凭证 | 配置于 `~/.gradle/gradle.properties`（需能访问 **public** 与 **snapshots**） |

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
    <version>2.9.13-nes.patch.2-SNAPSHOT</version>
</dependency>
```

本制品会传递：

`cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT`

optional 投影路径还会解析：

`cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1`

（版本由 NES Data BOM `2021.2.18-nes.patch.2-SNAPSHOT` 管理。）

因此下游仓库必须能解析 Nexus snapshots（或已把相关 SNAPSHOT 安装到本地/`~/.m2`）。Java `import` 仍为 `org.springframework.retry.*` / `org.springframework.data.*`，无需改代码。

> 本项目**不**发布 `bjca-footstone-bpring-kafka-bom`。版本对齐请使用本坐标或 spring-boot-2.7 NES 的 dependency management。
> 本项目**不**传递 NES Elasticsearch / Parsson / Security。

## 常见问题

- **Gradle 下载慢**：执行 `make setup-gradle` 预缓存本地 zip
- **Nexus 认证失败**：检查 `~/.gradle/gradle.properties` 中的 `nexusUsername` / `nexusPassword`
- **找不到 bjca-footstone-bpring-retry SNAPSHOT**：确认已配置 `nexusSnapshotUrl` / `nexusPublicUrl`，且私服中存在对应 SNAPSHOT
- **找不到 bjca-footstone-bpring-data-bom SNAPSHOT**：同上；data-commons 本身为 `2.7.18-nes.patch.1` RELEASE
- **CVE-2026-41710 状态**：当前为已缓解（SNAPSHOT），不是已修复；见 `doc/CVE/CVE-2026-41710.md`
- **CVE-2026-41711 / 41721 状态**：当前为免疫，不是已修复；见对应 CVE 文档
