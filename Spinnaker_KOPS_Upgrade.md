## Continuously Upgrade KOPS cluster using Spinnaker

We are planning to create a spinnaker environment that can automatically upgrade Kubernetes Cluster (KOPS).

## Goals to be achieved

- Initiate a cluster upgrade when there is a new version of kubernetes
- Using Heptio ARK, backup the complete cluster before doing the upgrade
- Notify once the backup is completed and continue to the upgradation stage
- Upgrade the cluster to the new version and notify once done
- Post upgrade, perform a sonobuoy test and submit the reports to S3

## Prerequisites:

- Should have a running Kubernetes cluster with Spinnaker installed
- Create a secret with AWS credentials in kubernetes cluster
- Create a secret with kubeconfig (of the cluster to be upgraded) in kubernetes cluster
- Create a custom image with kops, kubectl and aws cli.
- If you are using private registry, create a secret of docker-registry type to authenticate with the container registry.
- Create S3 buckets for storing cluster backup and sonobuoy test report

## Creating pipeline

This pipeline should be triggered when there is a version change in the GIT Repo.
Configure the S3 bucket name(For cluster backup and test report) as parameters

  ### Stage 1: Backup the Cluster

    - Create a Deploy (Manifest) stage from the stage selector and provide a YAML with the custom image created above
    - Environment variables should be set to pass the S3 bucket name
    - AWS credentials and Kubeconfig should be mounted as volumes in this POD
    - Clone ARK repo and edit the yaml file to point to the right s3 bucket.
    - Install ARK to a specific namespace & initiate backup to S3
    - Once completed, notify via slack
    - Trigger Stage 2

  ### Stage 2: Upgrade the Cluster

    - Create a Deploy (Manifest) stage from the stage selector and provide a YAML with the custom image created above
    - Environment variables should be set to pass the cluster name and the S3 bucket name of cluster state
    - AWS credentials and Kubeconfig should be mounted as volumes in this POD
    - Clone the repository that triggered the job
    - Update the YAML file with the required Kubernetes version
    - Replace the YAML file using kops replace
    - Execute kops update and kops rolling update to deploy the new version.
    - Once completed, notify via slack
    - Trigger Stage 3

  ### Stage 3: Run Conformance Test

    - Create a Deploy (Manifest) stage from the stage selector and provide a YAML with the custom image created above
    - AWS credentials and Kubeconfig should be mounted as volumes in this POD
    - Run the sonobuoy test.
    - Once sonobuoy status shows the run as completed, copy the output to an S3 bucket
    - Notify via slack
