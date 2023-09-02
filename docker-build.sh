#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -e
set -u

# https://www.shellcheck.net/
# Unavailable in POSIX sh
set -o pipefail
IFS=$'\n\t'

MODE=$1
DOCKER_USERNAME=tonghoangvu
IMAGE_NAME=$DOCKER_USERNAME/spring-boot-dockerizing
TIME=$(date +%s)

if [[ $MODE == 'cnb-jdk' ]]; then
	./mvnw spring-boot:build-image -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE"
elif [[ $MODE == 'cnb-jre' ]]; then
	./mvnw spring-boot:build-image -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE" -Dbp.jvm.type=JRE
elif [[ $MODE == 'cnb-jlink' ]]; then
	./mvnw spring-boot:build-image -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE" -Dbp.jvm.jlink.enabled=true
elif [[ $MODE == 'jib-ubuntu-jdk' ]]; then
	./mvnw jib:dockerBuild -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE" -Djib.from.image=eclipse-temurin:17-jdk-jammy \
		-Djib.from.auth.username="$DOCKER_USERNAME" -Djib.from.auth.password="$DOCKER_TOKEN"
elif [[ $MODE == 'jib-ubuntu-jre' ]]; then
	./mvnw jib:dockerBuild -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE" -Djib.from.image=eclipse-temurin:17-jre-jammy \
		-Djib.from.auth.username="$DOCKER_USERNAME" -Djib.from.auth.password="$DOCKER_TOKEN"
elif [[
	$MODE == 'ubuntu-jdk-fat' ||
	$MODE == 'ubuntu-jre-fat' ||
	$MODE == 'ubuntu-jlink-fat' ||
	$MODE == 'alpine-jre-fat' ||
	$MODE == 'alpine-jre-layered'
]]; then
	export DOCKER_BUILDKIT=1
	docker build -f "./docker/$MODE.Dockerfile" -t "$IMAGE_NAME:$MODE" .
fi

echo "Done in $(($(date +%s)-TIME)) seconds"
