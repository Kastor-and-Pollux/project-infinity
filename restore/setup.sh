#!/bin/sh

# Download and Install Kubectl and ARK
wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
wget https://github.com/heptio/ark/releases/download/${ARK_VERSION}/ark-${ARK_VERSION}-linux-amd64.tar.gz
tar -zxvf ark-${ARK_VERSION}-linux-amd64.tar.gz
mv kubectl /usr/local/bin/kubectl && mv ark /usr/local/bin/
chmod +x /usr/local/bin/kubectl /usr/local/bin/ark

# Execute backup
backupname=$(ark backup get | awk '{print $1}' |  head -n 2 | tail -n 1)
ark restore create --from-backup $backupname

# Wait for the backup to complete
until ark restore get $backupname | grep -m 1 "Completed"; do : ; done
