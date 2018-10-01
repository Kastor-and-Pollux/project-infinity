#!/bin/sh
export KUBECONFIG=.kube/config_infinity
export KOPS_STATE_STORE=s3://$S3Bucket
# kops get $Cluster-Name --state=s3://$S3-Bucket -o yaml > $Cluster-Name.yaml
kops replace -f $ClusterName.yaml
kops update cluster $ClusterName --yes
kops rolling-update cluster $ClusterName --yes
