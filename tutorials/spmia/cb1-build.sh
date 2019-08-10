#!/bin/bash

eval $(minikube docker-env)

export BUILD_NAME=cb1

mvn package docker:build
