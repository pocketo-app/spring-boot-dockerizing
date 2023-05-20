# syntax=docker/dockerfile:1
FROM eclipse-temurin:17-jre-alpine
WORKDIR /workspace/
COPY ../target/app.jar ./app.jar
ENTRYPOINT ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005", "-jar", "./app.jar"]

EXPOSE 8081
EXPOSE 5005
