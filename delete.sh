#!/bin/bash

kubectl delete service hello-node
kubectl delete deployment hello-node
./minikube stop
./minikube delete
