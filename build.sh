#!/bin/bash

export $(grep -v '^#' .env | xargs -d '\n')

docker compose build

#docker build \
#	--build-arg GITHUB_TOKEN=${GITHUB_TOKEN} \
#	--build-arg GITHUB_USERNAME=${GITHUB_USERNAME} \
#	-t robotics-deployment:dev \
#	.
