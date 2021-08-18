git version  
node --version
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ˜/.local/bin/kubectl
mv ./kubectl ˜/.local/bin/kubectl
export PATH="˜/.local/bin/kubectl:$PATH"
npm install @aws-cdk/aws-eks cdk8s cdk8s-plus constructs
npm i
npm run build
cdk bootstrap aws://$(aws sts get-caller-identity --query Account --output text)/$(aws configure get region)
cdk synth