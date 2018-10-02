#!/bin/sh
sonobuoy run --kubeconfig /root/.kube/config_infinity
until sonobuoy status --kubeconfig /root/.kube/config_infinity | egrep 'systemd_logs|e2e' | grep -m 1 "complete"; do : ; done
until sonobuoy logs --kubeconfig /root/.kube/config_infinity | grep -m 1 "Results available"; do : ; done
sonobuoy retrieve . --kubeconfig /root/.kube/config_infinity
aws s3 sync . s3://${bucket}/ --exclude="*" --include="*.tar.gz"
sonobuoy delete --kubeconfig /root/.kube/config_infinity
