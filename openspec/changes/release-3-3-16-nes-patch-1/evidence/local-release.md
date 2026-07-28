# Local RELEASE verification evidence

Recorded at: `2026-07-28T04:01:50Z`

## Ownership and repository baseline

- Component: `spring-kafka-3.3`
- Change: `release-3-3-16-nes-patch-1`
- Coordinator lease: `coordinator-wave7-kafka-33`
- Branch: `3.3.x-bjca-patch`
- Baseline HEAD before release commit: `3c28931fe`
- Toolchain: Amazon Corretto `17.0.17-amzn`

Credentials remain exclusively in user-level Gradle/Maven configuration and were neither read nor recorded.

## Upstream dependencies

No catalog-declared internal NES upstreams. Generated POM depends on official Spring Framework / Micrometer / Kafka clients (not internal SNAPSHOT).

## Serialized local publication

```bash
JAVA_HOME=/Users/anan/.sdkman/candidates/java/17.0.17-amzn \
./gradlew publishToMavenLocal -x test
```

- Exit status: success (`0`)
- Gradle: `BUILD SUCCESSFUL in 1m 7s`
- Mode: no `clean`
- Log: `/tmp/nes-kafka33-install.log`

## Confirmed publication set

- `cn.bjca.footstone.bpring.kafka:bjca-footstone-bpring-kafka:3.3.16-nes.patch.1` (pom/jar/sources/javadoc)
- `cn.bjca.footstone.bpring.kafka:bjca-footstone-bpring-kafka-test:3.3.16-nes.patch.1`

Representative GAV remains the main kafka module. BOM publication may also appear locally; representative consumer uses the main kafka module.

## Generated POM scan

- `filesScanned`: `2`
- `clean`: `true`
- `findings`: `0`

## Offline/online local consumer

Consumer: `/tmp/nes-kafka33-local-consumer/pom.xml`

- First offline resolve needed transitive Micrometer jars not yet in local cache; online `mvn dependency:resolve` succeeded (`0`)
- Resolved kafka `3.3.16-nes.patch.1`
- Internal SNAPSHOT dependencies: `0`
