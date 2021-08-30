#!/bin/bash
LOG_FILE=./error.log
# Redirect standard error to output
exec 2>$LOG_FILE
errtxt="please check $LOG_FILE for errors"
s="STEP"

install(){
  echo "$s 1: Installing Kubectl" 
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  chmod +x kubectl
  mkdir -p ˜/.local/bin/kubectl
  mv ./kubectl ˜/.local/bin/kubectl
  export PATH="˜/.local/bin/kubectl:$PATH"
  echo "$s 1: Installation of Kubectl Completed"
}

if ! [ -x "$(command -v kubectl)" ]; then
  echo 'Error: kubectl is not installed.' >&2
  install  
  if ! [ -x "$(command -v kubectl)" ]; then
    echo "Error: kubectl not correctly installed." >&2
    exit 1
  else
    echo "kubectl Installed"
    KubeCtlVersion=$(kubectl version --client --short | cut -d " " -f 3)
    echo "Version: $KubeCtlVersion"
  fi
else 
  echo 'kubectl Installed'
fi