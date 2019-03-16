#!/bin/bash


# directory position save and move to directory
pushd(){
    command pushd "$@" > /dev/null
}

# move to original directory position
popd(){
    command popd "$@" > /dev/null
}

# mkdir .run
if [ -d "$PWD/.run" ]; then
    echo -e "There is .run directory"
else
    mkdir $PWD/.run
fi

# update
echo -e "apt update"
apt update
# install packages
echo -e "install packages"
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
# signing
echo -e "signing for docker"
apt-key fingerprint 0EBFCD88
# add repository docker
echo -e "add repository docker"
if [[ -n `grep -r "download.docker.com" /etc/apt/sources.list` ]]; then
    echo -e "here"
else
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
fi

# one more update
echo -e "one more update"
apt update
# install docker-ce
echo -e "install docker-ce"
apt-get -y install docker-ce docker-ce-cli containerd.io

# add repository kubernetes
echo -e "add repository kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

if [[ -n `grep -r "kubernetes-xenial" /etc/apt/sources.list.d/` ]]; then
    echo -e "here"
else
    # touch repository kubernetes
    echo -e "touch repository kubernetes"
    touch /etc/apt/sources.list.d/kubernetes.list

    # write kubernetes.list
    echo -e "write kubernetes.list"
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
fi

# one more update
echo -e "one more update"
apt update

# install kubectl
echo -e "install kubectl"
apt-get -y install kubectl

# minikube download
echo -e "minikube download"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube

# minikube start
echo -e "minikube start"
./minikube start --vm-driver=none

# install nodejs
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

# touch server.js
if [ -e "$PWD/.run/server.js" ]; then
    echo -e "There is server.js"
else
    echo -e "var http = require('http');

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);
  response.end('Hello World!');
};
var www = http.createServer(handleRequest);
www.listen(8080);" > $PWD/.run/server.js
fi

# touch Dockerfile
if [ -e "$PWD/.run/Dockerfile" ]; then
    echo -e "There is Dockerfile in .run"
else
    echo -e "FROM node:10.15.3
EXPOSE 8080
COPY server.js .
CMD node server.js" > $PWD/.run/Dockerfile_temp
iconv -c -f utf-8 -t us-ascii $PWD/.run/Dockerfile_temp > $PWD/.run/Dockerfile
fi



 # docker build
echo -e "docker image build"
pushd $PWD/.run

docker build -t hello-node:v1 .
popd

# kubectl run
echo -e "kubectl run"
kubectl run hello-node --image=hello-node:v1 --port 8080 --image-pull-policy=Never

# create deployment
echo -e "create deployment"
kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

# create service
echo -e "create service"
kubectl expose deployment hello-node --type=LoadBalancer --port=8080

./minikube service hello-node

# install heapster
./minikube addons enable heapster

# status pod & services
kubectl get pod,svc -n kube-system

