#!/bin/sh

# Download Sonobuoy
wget https://github.com/heptio/sonobuoy/releases/download/${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION:1}_linux_amd64.tar.gz
tar -zxvf sonobuoy_${SONOBUOY_VERSION:1}_linux_amd64.tar.gz
rm sonobuoy_${SONOBUOY_VERSION:1}_linux_amd64.tar.gz
mv sonobuoy /usr/local/bin/
chmod +x /usr/local/bin/sonobuoy

# Deploy and run sonobuoy on Kubernetes
sonobuoy run -m Quick --kubeconfig /root/.kube/config

# Wait until Sonobuoy test completes
until sonobuoy status --kubeconfig /root/.kube/config | grep -m 1 "complete"; do : ; done

# Wait for the report to be generated
until sonobuoy logs --kubeconfig /root/.kube/config | grep -m 1 "Results available"; do : ; done

# Retrieve the result file to local system
sonobuoy retrieve . --kubeconfig /root/.kube/config

# Upload the result file to S3 bucket
aws s3 sync . s3://${bucket}/ --exclude="*" --include="*.tar.gz"

# Delete sonobouoy from the Kubernetes cluster
sonobuoy delete --kubeconfig /root/.kube/config
