#!/bin/sh

# Export Kubeconfig
export KUBECONFIG=.kube/config_infinity

# Export S3 State Store for KOPS
export KOPS_STATE_STORE=s3://$S3Bucket

# Clone the repository where the version file is available
git clone https://github.com/ranjujohn/k8s.git

# Get the KOPS yaml file
kops get $ClusterName -o yaml > $ClusterName.yaml

# Set the version variables
currentversion=$(cat $ClusterName.yaml  | grep kubernetesVersion | awk '{print $2}')
newversion=$(cat k8s/version | grep Version | awk '{print $2}')

# Update the KOPS yaml file with the new version number
sed -i "s/$currentversion/$newversion/g" $ClusterName.yaml

# Upload the new YAML file to S3
kops replace -f $ClusterName.yaml

# Upgrade the cluster 
kops update cluster $ClusterName --yes
kops rolling-update cluster $ClusterName --yes
