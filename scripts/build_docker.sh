#!/usr/bin/env bash
DOCKER_TAG_NAME=${1:-bigbox}
docker build -t $DOCKER_TAG_NAME .

