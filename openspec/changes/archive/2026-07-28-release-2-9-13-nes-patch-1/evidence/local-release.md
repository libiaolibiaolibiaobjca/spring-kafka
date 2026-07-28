# Local RELEASE verification evidence

Recorded at: `2026-07-28T03:58:36Z`

## Ownership and repository baseline

- Component: `spring-kafka-2.9`
- Change: `release-2-9-13-nes-patch-1`
- Coordinator lease: `coordinator-wave7-kafka-29`
- Branch: `2.9.x-bjca-patch`
- Baseline HEAD before release commit: `c119b8f62`
- Toolchain: Amazon Corretto / Temurin 11–17 compatible; build used Temurin `11.0.30-tem`

Credentials remain exclusively in user-level Gradle/Maven configuration and were neither read nor recorded.

## Upstream dependencies

No catalog-declared internal NES upstreams. Generated POM depends on official Spring Framework `5.3.29` and Kafka clients (not internal SNAPSHOT).

## Serialized local publication

```bash
JAVA_HOME=/Users/anan/.sdkman/candidates/java/11.0.30-tem \
./gradlew publishToMavenLocal -x test
```

- Exit status: success (`0`)
- Gradle: `BUILD SUCCESSFUL in 36s`
- Mode: no `clean`
- Log: `/tmp/nes-kafka29-install.log`

## Confirmed publication set

- `cn.bjca.footstone.bpring.kafka:bjca-footstone-bpring-kafka:2.9.13-nes.patch.1` (pom/jar/sources/javadoc)
- `cn.bjca.footstone.bpring.kafka:bjca-footstone-bpring-kafka-test:2.9.13-nes.patch.1`

Representative GAV remains the main kafka module.

## Generated POM scan

- `filesScanned`: `2`
- `clean`: `true`
- `findings`: `0`

## Offline local consumer

Consumer: `/tmp/nes-kafka29-local-consumer/pom.xml`

- Exit status: success (`0`)
- Resolved kafka `2.9.13-nes.patch.1`
- Internal SNAPSHOT dependencies: `0`
