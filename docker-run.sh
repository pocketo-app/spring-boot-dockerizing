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

if [[ $MODE == 'cnb-jdk' || $MODE == 'cnb-jre' || $MODE == 'cnb-jlink' ]]; then
	docker run \
		-e BPL_DEBUG_ENABLED=true -e BPL_DEBUG_PORT=5005 -e BPL_DEBUG_SUSPEND=false \
		-p 8081:8081 -p 5005:5005 \
		-it \
		--rm \
		"$IMAGE_NAME:$MODE"
elif [[
	$MODE == 'jib-ubuntu-jdk' ||
	$MODE == 'jib-ubuntu-jre' ||
	$MODE == 'ubuntu-jdk-fat' ||
	$MODE == 'ubuntu-jre-fat' ||
	$MODE == 'ubuntu-jlink-fat' ||
	$MODE == 'alpine-jre-fat' ||
	$MODE == 'alpine-jre-layered'
]]; then
	docker run -p 8081:8081 -p 5005:5005 -it --rm "$IMAGE_NAME:$MODE"
fi

echo "Done in $(($(date +%s)-TIME)) seconds"
