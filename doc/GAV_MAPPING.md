# GAV 映射表 (GAV Mapping)

## 全局变更规则

- **GroupId**: `org.springframework.kafka` → `cn.bjca.footstone.bpring.kafka`
- **ArtifactId**: `spring-kafka*` → `bjca-footstone-bpring-kafka*`
- **Version**: `3.3.17-SNAPSHOT` → `3.3.16-nes.patch.1`（基线 Spring for Apache Kafka 3.3.16）

## 模块映射

| 原始 ArtifactId | 新 ArtifactId |
| :--- | :--- |
| spring-kafka | bjca-footstone-bpring-kafka |
| spring-kafka-test | bjca-footstone-bpring-kafka-test |
| spring-kafka-bom | bjca-footstone-bpring-kafka-bom |
| spring-kafka-docs | bjca-footstone-bpring-kafka-docs（不发布，仅本地文档构建） |

> `spring-kafka-bom` 为 3.3 版本线新增的 BOM 模块（2.9 无），已纳入重命名。

## 实现方式

通过 `settings.gradle` 中修改各子模块的 `project.name`（前缀替换）实现，使发布坐标、
BOM 的 `constraints`、jar 名、pom 的 groupId/artifactId 全部自动跟随。因改 `project.name`
会同步改变 project path，`build.gradle` 与 `spring-kafka-docs/build.gradle` 中按 path 的
`project(':spring-kafka*')` 引用已同步更新。

## 下游依赖示例

### 直接依赖主模块

```xml
<dependency>
    <groupId>cn.bjca.footstone.bpring.kafka</groupId>
    <artifactId>bjca-footstone-bpring-kafka</artifactId>
    <version>3.3.16-nes.patch.1</version>
</dependency>
```

### 通过 BOM 管理版本

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>cn.bjca.footstone.bpring.kafka</groupId>
            <artifactId>bjca-footstone-bpring-kafka-bom</artifactId>
            <version>3.3.16-nes.patch.1</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

## 重要说明

- **Java 包名不变**：下游 Java/Kotlin 代码中的 `import org.springframework.kafka...` **无需修改**。本次变更仅涉及 Maven 坐标，不涉及包名。
- **依赖坐标保持原始上游**：本 fork 制品的 pom 中，对 `kafka-clients`（3.9.2）、`spring-retry`、`spring-context` 等第三方依赖的引用保持其原始官方坐标，仅本项目自身模块坐标去特征化。
