#!/bin/bash

cd ../../
PACKAGE=robotics-deployment:embedded &&
	docker build -t ${PACKAGE}-dev --build-arg PACKAGE=${PACKAGE} -f Dockerfile .
