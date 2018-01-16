#!/usr/bin/env bash
DOCKER_TAG_NAME=${1:-bigbox}
docker stop $DOCKER_TAG_NAME
docker rm $DOCKER_TAG_NAME
docker rmi $DOCKER_TAG_NAME


