@echo off
git version  
node --version
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ˜/.local/bin/kubectl
mv ./kubectl ˜/.local/bin/kubectl
export PATH="˜/.local/bin/kubectl:$PATH"
@echo on
echo 'Done installing kubectl successfully'
echo 'Installing cdk and aws dependencies...'
@echo off
npm install @aws-cdk/aws-eks cdk8s cdk8s-plus constructs
npm i
@echo on
echo 'Building the project...'
npm run build
echo 'Project build completed successfully'


-- changes
#!/bin/bash
GitVersion=$(git version | cut -d " " -f 3)
NpmVersion=$(npm -v)
NodeVersion=$(node -v)
CdkVersion=$(cdk --version | cut -d " " -f 1)
OSUname=$(uname)

cat <<EOF | mail -s "$(date): Report on $(hostname)" "iyerb@amazon.com"
Git  Version: $GitVersion
NPM  Version: $NpmVersion
Node Version: $NodeVersion
CDK  Version: $CdkVersion
OS Uname: $OSUname
EOF

git version  
node --version
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ˜/.local/bin/kubectl
mv ./kubectl ˜/.local/bin/kubectl
export PATH="˜/.local/bin/kubectl:$PATH"
@echo on
echo 'Done installing kubectl successfully'
echo 'Installing cdk and aws dependencies...'
@echo off
npm install @aws-cdk/aws-eks cdk8s cdk8s-plus constructs
npm i
@echo on
echo 'Building the project...'
npm run build
echo 'Project build completed successfully'