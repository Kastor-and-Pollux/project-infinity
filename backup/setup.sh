#!/bin/sh

# Export Kubeconfig
export KUBECONFIG=.kube/config_infinity

# Clone the ARK repository
git clone https://github.com/heptio/ark.git --branch v0.9.5

# update the files to point to the right Region and Bucket
sed -i "s/<YOUR_REGION>/$region/g" ark/examples/aws/*
sed -i "s/<YOUR_BUCKET>/$bucket/g" ark/examples/aws/*

# Deploy ARK to kubernetes & Create secret
kubectl apply -f ark/examples/common/00-prereqs.yaml
kubectl create secret generic cloud-credentials --namespace heptio-ark --from-file cloud=/root/.aws/credentials
kubectl apply -f ark/examples/aws/00-ark-config.yaml
kubectl apply -f ark/examples/aws/10-deployment.yaml

# Execute the backup
ark backup create cluster-backup

# List the backup
until ark backup get | grep -m 1 "Completed"; do : ; done
kubectl delete -f ark/examples/common/00-prereqs.yaml
