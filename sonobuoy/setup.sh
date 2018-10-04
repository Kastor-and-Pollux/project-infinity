#!/bin/sh
# Deploy and run sonobuoy on Kubernetes
sonobuoy run --kubeconfig /root/.kube/config_infinity

# Wait for the report to be generated
until sonobuoy logs --kubeconfig /root/.kube/config_infinity | grep -m 1 "Results available"; do : ; done

# Retrieve the result file to local system
sonobuoy retrieve . --kubeconfig /root/.kube/config_infinity

# Upload the result file to S3 bucket
aws s3 sync . s3://${bucket}/ --exclude="*" --include="*.tar.gz"

# Delete sonobouoy from the Kubernetes cluster
sonobuoy delete --kubeconfig /root/.kube/config_infinity
