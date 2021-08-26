#!/bin/bash
LOG_FILE=./output.log
# Open standard output as $LOG_FILE file for read and write.
exec 1<>$LOG_FILE
# Redirect standard error to standard output
exec 2>&1
s="STEP"
errtxt="please check $LOG_FILE for errors"
OSUname=$(uname)

checkInstalled(){
    if [[ $? -eq 0 ]];
        then
            echo "$1 Is installed, version: $2"    
        else
            echo "$1 Is not installed"
    fi
}

installKubeCtl(){
    echo "$s 1: Installing Kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ˜/.local/bin/kubectl
    mv ./kubectl ˜/.local/bin/kubectl
    export PATH="˜/.local/bin/kubectl:$PATH"
    echo "$s 1: Installation of Kubectl Completed"
}

GitVersion=$(git version | cut -d " " -f 3)
checkInstalled "Git" $GitVersion 

NpmVersion=$(npm -v)
checkInstalled "Npm" $NpmVersion 

NodeVersion=$(node -v)
checkInstalled "Node" $NodeVersion 

CdkVersion=$(cdk --version | cut -d " " -f 1)
checkInstalled "CDK" $CdkVersion 

KubeCtlVersion=$(kubectl version --client --short | cut -d " " -f 3)
checkInstalled "Kubectl" $KubeCtlVersion 

#check If no kubectl found. Install if not found
if [[ $? -eq 1 ]];
then
    echo "Kubectl not found. Installing kubectl..."
    installKubeCtl
    wait $!    
    if [[ $? -eq 0 ]];
        then
            echo "Kubectl sucessfully installed"
            #verify kubectl installed.  
            KubeCtlVersion=$(kubectl version --client --short | cut -d " " -f 3)
            checkInstalled "Kubectl" $KubeCtlVersion   
        else    
            echo "Kubectl installation failed...$errtxt"    
    fi
fi
if [ -n "$NpmVersion" ];
then
    echo "NPM Exists..installing dependencies..."    
    npm install @aws-cdk/aws-eks cdk8s cdk8s-plus constructs
    checkInstalled "Npm Dependecies" $NodeVersion
    npm i
    checkInstalled "Npm Dependecies" $NodeVersion    
else 
    echo "NPM not found, has to be installed to proceed."    
fi    
if [ -n "$NpmVersion" ];
    then
        echo "Building the project..."    
        npm run build
        wait $!
        if [[ $? -eq 0 ]];
            then
                echo "Project build sucessful"    
            else    
                echo "Project build failed...$errtxt"    
        fi
    else 
        echo "NPM not found, has to be installed to proceed."    
fi
if [[ $? -eq 0 ]];
then 
    echo "All Installation sucessful"
else
    echo "Installation failed...$errtxt"    
fi
