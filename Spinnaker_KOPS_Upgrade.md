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
- If you are using private registry, create a secret of docker-registry type to authenticate with the container registry.
- Create S3 buckets for storing cluster backup and sonobuoy test report
- ARK should be installed and configured for the backup
- Custom image for Backup
- Custom image for upgrade
- Custom image for Sonobuoy test

## Creating pipeline

This pipeline should be triggered when there is a version change in the GIT Repo.
Configure the S3 bucket name(For cluster backup and test report) as parameters

  ### Stage 1: Backup the Cluster

    - Create a Deploy (Manifest) stage from the stage selector and provide a YAML with the custom image for backup
    - Kubeconfig should be mounted as volumes in this POD
    - Kubectl and ARk version has to be passed as env. variables from a configmap
    - This custom image will do the following tasks
        - Download Kubectl & ARK and run the backup
        - Wait for it to be completed.
    - Once completed, notify via slack
    - Trigger Stage 2

  ### Stage 2: Upgrade the Cluster

    - Create a Deploy (Manifest) stage from the stage selector and provide a YAML with the custom image for upgrade
    - Environment variables should be set to pass the cluster name and the S3 bucket name of cluster state
    - AWS credentials and Kubeconfig should be mounted as volumes in this POD
    - Kubectl and KOPS version has to be passed as env. variables from a configmap
    - This custom image will do the following tasks
        - Download Kubectl & KOPS
        - Clone the repository that triggered the job
        - Export the KOPS config yaml
        - Update the YAML file with the required Kubernetes version based on the version file
        - Replace the YAML file using kops replace
        - Execute kops update and kops rolling update to deploy the new version.
    - Once completed, notify via slack
    - Trigger Stage 3

  ### Stage 3: Run Conformance Test

    - Create a Deploy (Manifest) stage from the stage selector and provide a YAML with the custom image for Sonobuoy test
    - Environment variables should be set to pass the S3 bucket name for copying the report.
    - AWS credentials and Kubeconfig should be mounted as volumes in this POD
    - Sonobuoy version has to be passed as env. variable from a configmap
    - This custom image will do the following tasks
        - Download sonobuoy
        - Install and run the sonobuoy test.
        - Wiat for the sonobuoy test to complete
        - copy the output to an S3 bucket
        - Delete sonobouoy from the Kubernetes cluster
    - Notify via slack
