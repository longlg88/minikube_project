#!/bin/bash

sudo chown $USER:$USER -R ~/.kube
sudo chown $USER:$USER -R ~/.minikube
sudo usermod -a -G docker $USER
sudo service docker restart
newgrp - docker
