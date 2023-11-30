#!/bin/bash

(cd ~/repos/main/server && docker compose build)

cd ../../
PACKAGE=robotics-deployment:server &&
	docker build -t ${PACKAGE}-dev --build-arg PACKAGE=${PACKAGE} -f Dockerfile .
