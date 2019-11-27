#!/bin/bash

# minikube start
## --kubernetes-version option will specify your kubernetes version.
echo -e $(tput setaf 1)"Minikube's kubernetes latest version is error in ubuntu environment. You should check minkube github(https://minikube.sigs.k8s.io/) & kubernetes main website(https://kubernetes.io/). Check kubernetes release version"$(tput sgr0)

echo -e
while sleep 1
do
    echo -e $(tput setaf 1) "Do you agree with that?(y/n)"$(tput sgr0)
    read VAL
    if [ ${VAL} == "y" ]; then
        echo -e "minikube start"
        echo $1
        if [ -z $1 ]; then
            echo -e "Run minikube default version v1.13.5"
            minikube start --vm-driver=none --kubernetes-version v1.13.5
            exit 0
        else
            minikube start --vm-driver=none --kubernetes-version $1
            exit 0
        fi
    elif [ ${VAL} == "n" ]; then
        echo -e $(tput setaf 2)"exit"$(tput sgr0)
        exit 1
    fi
done

# install nodejs
#curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
#sudo apt-get install -y nodejs


echo "alias k=kubectl" >> ~/.bashrc
