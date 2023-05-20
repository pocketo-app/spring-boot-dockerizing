#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -e
set -u

# https://www.shellcheck.net/
# Unavailable in POSIX sh
set -o pipefail
IFS=$'\n\t'

MODE=$1
IMAGE_NAME=tonghoangvu/spring-boot-dockerizing
TIME=$(date +%s)

if [[ $MODE == 'cnb-jdk' ]]; then
	./mvnw spring-boot:build-image -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE"
elif [[ $MODE == 'cnb-jre' ]]; then
	./mvnw spring-boot:build-image -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE" -Dbp.jvm.type=JRE
elif [[ $MODE == 'cnb-jlink' ]]; then
	./mvnw spring-boot:build-image -DskipTests "-Ddocker.image.name=$IMAGE_NAME:$MODE" -Dbp.jvm.jlink.enabled=true
fi

echo "Done in $(($(date +%s)-TIME)) seconds"
