#!/bin/bash

echo -e "Install docker & kubectl & minikube"

# directory position save and move to directory
pushd(){
    command pushd "$@" > /dev/null
}

# move to original directory position
popd(){
    command popd "$@" > /dev/null
}

# update
echo -e "apt update"
sudo apt update
# install packages
echo -e "install packages"
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# add docker official gpg key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# signing
echo -e "signing for docker"
sudo apt-key fingerprint 0EBFCD88
# add repository docker
echo -e "add repository docker"
if [[ -n `grep -r "download.docker.com" /etc/apt/sources.list` ]]; then
    echo -e "here"
else
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
fi

# one more update
echo -e "one more update"
sudo apt update
# install docker-ce
echo -e "install docker-ce"
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# add repository kubernetes
echo -e "add repository kubernetes"
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

if [[ -n `grep -r "kubernetes-xenial" /etc/apt/sources.list.d/` ]]; then
    echo -e "here"
else
    # touch repository kubernetes
    echo -e "touch repository kubernetes"
    sudo touch /etc/apt/sources.list.d/kubernetes.list

    # write kubernetes.list
    echo -e "write kubernetes.list"
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
fi

# one more update
echo -e "one more update"
sudo apt update

# install kubectl
echo -e "install kubectl"
sudo apt-get -y install kubectl

# minikube download
echo -e "minikube download"
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && sudo chmod +x minikube && sudo mv minikube /usr/bin/

mkdir ~/.kube
mkdir ~/.minikube

sudo chown $USER:$USER -R ~/.kube
sudo chown $USER:$USER -R ~/.minikube
sudo usermod -a -G docker $USER
sudo service docker restart

echo "alias k=kubectl" >> ~/.bashrc


echo -e
echo -e "Copy this command"

echo -e "minikube start --vm-driver=none --kubernetes-version v1.13.5"


echo -e "Delete cluster command"
echo -e "minikube stop && minikube delete --purge"

# docker build
#echo -e "docker image build"
#pushd $PWD/.run
#
#docker build -t hello-node:v1 .
#popd

# kubectl run
#echo -e "kubectl run"
#kubectl run hello-node --image=hello-node:v1 --port 8080 --image-pull-policy=Never

# create deployment
#echo -e "create deployment"
#kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

# create service
#echo -e "create service"
#kubectl expose deployment hello-node --type=LoadBalancer --port=8080

#./minikube service hello-node

# create dashboard
#./minikube dashboard

# install heapster
#./minikube addons enable heapster

# status pod & services
#kubectl get pod,svc -n kube-system

