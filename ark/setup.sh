#!/bin/sh

# Download and Install Kubectl and ARK
wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
mv kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# Clone the ARK repository
git clone https://github.com/heptio/ark.git --branch $ARK_VERSION

# update the files to point to the right Region and Bucket
sed -i "s/<YOUR_REGION>/$region/g" ark/examples/aws/*
sed -i "s/<YOUR_BUCKET>/$bucket/g" ark/examples/aws/*
sed -i "s/latest/$ARK_VERSION/g" ark/examples/aws/10-deployment.yaml

# Deploy ARK to kubernetes & Create secret
kubectl apply -f ark/examples/common/00-prereqs.yaml
kubectl create secret generic cloud-credentials --namespace heptio-ark --from-file cloud=/root/.aws/credentials
kubectl apply -f ark/examples/aws/00-ark-config.yaml
kubectl apply -f ark/examples/aws/10-deployment.yaml

