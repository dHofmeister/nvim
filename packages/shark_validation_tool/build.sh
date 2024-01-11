#!/bin/bash

(cd ~/repos/shark_validation_tool/develop/amd64 && ./build.sh)

cd ../../
PACKAGE=192.168.50.250:5000/shark-develop:validation-tool-amd64 &&
	DISTRO=focal &&
	docker build -t ${PACKAGE}-dev --build-arg PACKAGE=${PACKAGE} --build-arg DISTRO=${DISTRO} -f Dockerfile .
