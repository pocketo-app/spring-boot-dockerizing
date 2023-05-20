# syntax=docker/dockerfile:1
FROM eclipse-temurin:17-jre-alpine AS builder
WORKDIR /workspace/
COPY ../target/app.jar ./app.jar
RUN java -Djarmode=layertools -jar ./app.jar extract

FROM eclipse-temurin:17-jre-alpine
WORKDIR /workspace/
COPY --from=builder /workspace/dependencies/ ./
COPY --from=builder /workspace/spring-boot-loader/ ./
COPY --from=builder /workspace/snapshot-dependencies/ ./
COPY --from=builder /workspace/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]

EXPOSE 8081
