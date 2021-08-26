#!bin/bash
LOG_FILE=./output.log
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

installnpmdependencies(){  
  echo "$s 2:installing npm & cdk dependencies..."       
  npm install @aws-cdk/aws-eks cdk8s cdk8s-plus constructs
  npm i
  echo "$s 2: NPM Dependencies installed"
}

buildproject(){
  echo "$s 3:Building project..."
  npm run build
  echo "$s 3:Project build completed!"
}

cdkbootstrap(){
  echo "$s 4:Running CDK Bootstrap..."
  ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
  REGION=$(aws configure get region)
  if [ -z "$ACCOUNT" ]; then 
    echo "Account is not configured"
    exit 1
  else 
    echo "Account used for bootstrap $ACCOUNT"
  fi
  if [ -z "$REGION" ]; then 
    echo "Region is not configured"
    exit 1
  else 
    echo "Region used for bootstrap $REGION"
  fi
  cdk bootstrap aws://$ACCOUNT/$REGION 
  echo "$s 4:CDK Bootstrap completed!"
}

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
else 
  echo 'Git Installed'
  GitVersion=$(git version | cut -d " " -f 3)
  echo $GitVersion
fi

if ! [ -x "$(command -v npm)" ]; then
  echo 'Error: npm is not installed.' >&2
  exit 1
else 
  echo 'npm Installed'
  NpmVersion=$(npm -v)
  echo "Version: $NpmVersion"
fi

if ! [ -x "$(command -v node)" ]; then
  echo 'Error: node is not installed.' >&2
  exit 1
else 
  echo 'node Installed'
  NodeVersion=$(node -v)
  echo "Version: $NodeVersion"
fi

if ! [ -x "$(command -v cdk)" ]; then
  echo 'Error: cdk is not installed.' >&2
  exit 1
else 
  echo 'cdk Installed'
  CdkVersion=$(cdk --version | cut -d " " -f 1)
  echo "Version: $CdkVersion"
fi

if ! [ -x "$(command -v tat)" ]; then
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

if [ -x "$(command -v npm)" ]; then
  installnpmdependencies
  buildproject
fi

if [ -x "$(command -v cdk)" ]; then  
  cdkbootstrap
fi