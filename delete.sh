#!/bin/bash

kubectl delete svc --all
kubectl delete rc --all
kubectl delete replicaset --all
kubectl delete deployment --all
kubectl delete pod --all
./minikube stop
./minikube delete
