#!/bin/bash

PACKAGE=192.168.50.250:5000/shark-develop:display-amd64 &&
	docker build -t ${PACKAGE}-dev --build-arg PACKAGE=${PACKAGE} -f Dockerfile .
