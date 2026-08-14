# Spring Kafka GAV 映射表

## 全局变更规则

- **GroupId**: `org.springframework.kafka` → `cn.bjca.footstone.bpring.kafka`
- **ArtifactId**: `spring-kafka` → `bjca-footstone-bpring-kafka`
- **Version**: `2.9.14-SNAPSHOT` → `2.9.13-nes.patch.1`（已 RELEASE）→ 当前开发 `2.9.13-nes.patch.2-SNAPSHOT`

## 模块映射

| 原始 ArtifactId | 新 ArtifactId |
| :--- | :--- |
| spring-kafka | bjca-footstone-bpring-kafka |
| spring-kafka-test | bjca-footstone-bpring-kafka-test |
| spring-kafka-docs | bjca-footstone-bpring-kafka-docs |

## 直接依赖：Spring Retry NES

| 用途 | 原始 GAV | 当前 NES GAV |
| :--- | :--- | :--- |
| compile/api | `org.springframework.retry:spring-retry:1.3.4` | `cn.bjca.footstone.bpring.retry:bjca-footstone-bpring-retry:1.3.4-nes.patch.1-SNAPSHOT` |

> Java import 仍为 `org.springframework.retry.*` / `org.springframework.classify.*`，无需改代码。  
> SNAPSHOT 含 CVE-2026-41710 源码修复；retry 正式 RELEASE 发布后应切换到非 SNAPSHOT 坐标。  
> 传递的 NES Spring Framework 在本仓 `build.gradle` 中已 exclude，编译仍使用官方 `org.springframework:*`。

## 直接依赖：Spring Data Commons NES

| 用途 | 原始 GAV | 当前 NES GAV |
| :--- | :--- | :--- |
| BOM import | `org.springframework.data:spring-data-bom:2021.2.17` | `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-bom:2021.2.18-nes.patch.2-SNAPSHOT` |
| optionalApi | `org.springframework.data:spring-data-commons`（由官方 BOM 管理） | `cn.bjca.footstone.bpring.data:bjca-footstone-bpring-data-commons:2.7.18-nes.patch.1` |

> Java import 仍为 `org.springframework.data.*`，`ProjectingMessageConverter` 无需改代码。  
> data-commons 本身为 NES RELEASE；BOM 为 patch.2 SNAPSHOT（其中 Elasticsearch 条目本仓不引用）。  
> 传递的 NES Spring Framework 在本仓 `build.gradle` 中已 exclude。本仓**不**引入 NES Elasticsearch / Parsson / Security。

## 下游依赖示例

```xml
<dependency>
    <groupId>cn.bjca.footstone.bpring.kafka</groupId>
    <artifactId>bjca-footstone-bpring-kafka</artifactId>
    <version>2.9.13-nes.patch.2-SNAPSHOT</version>
</dependency>
```

> 下游 Java 代码中的 `import org.springframework.kafka...` 无需修改。
