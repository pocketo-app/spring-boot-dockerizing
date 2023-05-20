# syntax=docker/dockerfile:1
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /workspace/
RUN $JAVA_HOME/bin/jlink --add-modules java.se,jdk.jdwp.agent --strip-debug --no-man-pages --no-header-files --compress=2 --output ./jre/

FROM ubuntu:jammy
ENV JAVA_HOME=/opt/java/jre
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=builder /workspace/jre/ $JAVA_HOME

WORKDIR /workspace/
COPY ../target/app.jar ./app.jar
ENTRYPOINT ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005", "-jar", "./app.jar"]

EXPOSE 8081
EXPOSE 5005
