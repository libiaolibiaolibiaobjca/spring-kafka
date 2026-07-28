# Spring Kafka GAV 映射表

## 全局变更规则

- **GroupId**: `org.springframework.kafka` → `cn.bjca.footstone.bpring.kafka`
- **ArtifactId**: `spring-kafka` → `bjca-footstone-bpring-kafka`
- **Version**: `2.9.14-SNAPSHOT` → `2.9.13-nes.patch.1`

## 模块映射

| 原始 ArtifactId | 新 ArtifactId |
| :--- | :--- |
| spring-kafka | bjca-footstone-bpring-kafka |
| spring-kafka-test | bjca-footstone-bpring-kafka-test |
| spring-kafka-docs | bjca-footstone-bpring-kafka-docs |

## 下游依赖示例

```xml
<dependency>
    <groupId>cn.bjca.footstone.bpring.kafka</groupId>
    <artifactId>bjca-footstone-bpring-kafka</artifactId>
    <version>2.9.13-nes.patch.1</version>
</dependency>
```

> 下游 Java 代码中的 `import org.springframework.kafka...` 无需修改。
