#!/bin/sh

#Instal Required packages 
wget https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops
wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
mv kubectl /usr/local/bin/kubectl
chmod +x /usr/local/bin/kops /usr/local/bin/kubectl

# Export S3 State Store for KOPS
export KOPS_STATE_STORE=s3://$S3Bucket

# Clone the repository where the version file is available
git clone https://github.com/Kastor-and-Pollux/project-infinity.git

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
