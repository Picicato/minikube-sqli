#!/bin/bash

minikube status
minikube kubectl -- version --client
eval $(minikube -p minikube docker-env)

