#!/bin/bash

(cd ~/repos/main/embedded && docker compose build)

cd ../../
PACKAGE=robotics-deployment:embedded &&
	docker build -t ${PACKAGE}-dev --build-arg PACKAGE=${PACKAGE} -f Dockerfile .
