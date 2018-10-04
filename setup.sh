#!/bin/sh
export KUBECONFIG=.kube/config_infinity
export KOPS_STATE_STORE=s3://$S3Bucket
git clone https://github.com/ranjujohn/k8s.git
kops get $ClusterName --state=s3://$S3-Bucket -o yaml > $ClusterName.yaml
currentversion=$(cat $ClusterName.yaml  | grep kubernetesVersion | awk '{print $2}')
newversion=$(cat k8s/version | grep Version | awk '{print $2}')
sed -i "s/$currentversion/$newversion/g" $ClusterName.yaml
kops replace -f $ClusterName.yaml
kops update cluster $ClusterName --yes
kops rolling-update cluster $ClusterName --yes
