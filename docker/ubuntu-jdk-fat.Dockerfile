# syntax=docker/dockerfile:1
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /workspace/
COPY ../target/app.jar ./app.jar
ENTRYPOINT ["java", "-jar", "./app.jar"]

EXPOSE 8081
