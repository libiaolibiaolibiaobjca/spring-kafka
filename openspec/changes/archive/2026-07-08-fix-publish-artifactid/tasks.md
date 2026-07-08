## 1. 发布 artifactId 覆盖

- [x] 1.1 在 `publish-maven.gradle` 的 `mavenJava` 发布块显式设置 `artifactId`，按模块映射：`spring-kafka`→`bjca-footstone-bpring-kafka`、`spring-kafka-test`→`bjca-footstone-bpring-kafka-test`、`spring-kafka-docs`→`bjca-footstone-bpring-kafka-docs`（按 project.name 显式映射，映射表定义在 root `ext.bjcaArtifactIds`）
- [x] 1.2 在 `build.gradle` subprojects 配置中为每个模块设置 `base.archivesName`（jar 名）为对应的 `bjca-footstone-bpring-kafka*`

## 2. 模块间依赖坐标重写

- [x] 2.1 在 `build.gradle` 的 `pom.withXml` 块中新增逻辑：遍历生成 POM 的 dependencies，将 `artifactId` 命中 `ext.bjcaArtifactIds` 键（`spring-kafka` / `spring-kafka-test` / `spring-kafka-docs`）的节点改写为对应 `bjca-footstone-bpring-kafka*` 坐标。**说明**：经验证当前无任何模块间依赖进入发布 POM（唯一跨模块引用是 `spring-kafka` 对 `spring-kafka-test` 的 `testImplementation`，属 test 作用域不进 POM），此逻辑为防御性，保证将来若新增 compile/api 作用域的模块间依赖时坐标自动正确。

## 3. 文档修正

- [x] 3.1 在 `doc/GAV_MAPPING.md` 删除引用 `bjca-footstone-bpring-kafka-bom` 的 BOM 依赖示例段落

## 4. 验证

- [x] 4.1 执行 `./gradlew projects`，确认项目名仍为 `spring-kafka` / `spring-kafka-test` / `spring-kafka-docs`（project.name 未变）✅
- [x] 4.2 执行 `./gradlew generatePomFileForMavenJavaPublication`，三模块生成 POM 的 `artifactId` 均为 `bjca-footstone-bpring-kafka*` ✅
- [x] 4.3 检查三模块生成 POM：无 `spring-kafka*` 悬空坐标 ✅。（注：实际依赖方向为主模块 test 作用域引用 test 模块，不进 POM，故 POM 中本就无模块间 compile 依赖需重写）
- [x] 4.4 清空 `build/libs` 重建后，jar / javadoc / sources 三类 jar 名均为 `bjca-footstone-bpring-kafka*-<version>.jar` ✅
