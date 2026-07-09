.PHONY: setup-gradle clean build build-thin test install deploy stop projects help

# =============================================================================
# Spring for Apache Kafka 3.3.x BJCA 维护分支 — 构建快捷命令
# =============================================================================
# 初始化 sdkman 并切换到 Java 17（spring-kafka 3.3 基线要求 JDK 17，Gradle 8.14.5）
SHELL := /bin/bash
JAVA_INIT := source "$(HOME)/.sdkman/bin/sdkman-init.sh" && sdk use java 17.0.15-amzn > /dev/null &&

# Gradle 本地分发包查找目录（默认 ~/dev，供 setup-gradle 预缓存）
LOCAL_GRADLE_DIR ?= $(HOME)/dev

help:
	@echo ""
	@echo "可用命令:"
	@echo "  make setup-gradle - 安装本地 Gradle zip 到 wrapper 缓存（默认 ~/dev，离线构建）"
	@echo "  make clean        - 清理构建产物"
	@echo "  make test         - 运行测试（./gradlew test）"
	@echo "  make build-thin   - 快速构建（跳过测试、文档、代码检查）"
	@echo "  make build        - 全量构建（含测试与 checkstyle 等检查）"
	@echo "  make install      - 发布到本地 Maven 仓库（~/.m2），跳过测试"
	@echo "  make deploy       - 发布到 Nexus 私服，跳过测试"
	@echo "  make stop         - 停止所有 Gradle Daemon，释放内存与文件锁"
	@echo "  make projects     - 查看所有子项目（含 GAV 重命名后的 project.name）"
	@echo ""

# 安装并解压 LOCAL_GRADLE_DIR 下全部 Gradle zip（默认 ~/dev）
# 预缓存后 ./gradlew 自动使用本地分发包，跳过网络下载
setup-gradle:
	LOCAL_GRADLE_DIR="$(LOCAL_GRADLE_DIR)" UNPACK=1 ./scripts/setup-gradle-local.sh

# 清理所有子模块的 build 目录
clean: setup-gradle
	$(JAVA_INIT) ./gradlew clean

# 运行测试
test: setup-gradle
	$(JAVA_INIT) ./gradlew test

# 快速构建：跳过测试、代码格式检查及文档模块，用于日常编译验证
build-thin: clean
	$(JAVA_INIT) ./gradlew build -x test -x checkstyleMain -x checkstyleTest -x javadoc -x checkstyleNohttp

# 全量构建：含测试、checkstyle 等全部验证任务
build: clean setup-gradle
	$(JAVA_INIT) ./gradlew build

# 发布到本地 Maven 仓库，供同机其他项目依赖调试（跳过测试以加快速度）
install: setup-gradle
	$(JAVA_INIT) ./gradlew clean publishToMavenLocal -x test

# 发布到 Nexus 私服（跳过测试；docs 模块本身不发布，无需排除）
deploy: setup-gradle
	$(JAVA_INIT) ./gradlew clean publishAllPublicationsToNexusRepository -x test

stop:
	$(JAVA_INIT) ./gradlew --stop

projects: setup-gradle
	$(JAVA_INIT) ./gradlew projects
