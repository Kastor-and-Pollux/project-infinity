#!/bin/sh
# export KUBECONFIG=.kube/config_infinity
sonobuoy run --mode Quick --kubeconfig /root/.kube/config_infinity
until sonobuoy status --kubeconfig /root/.kube/config_infinity | grep e2e | grep -m 1 "complete"; do : ; done
#until sonobuoy status | grep systemd_logs | grep -m 1 "complete"; do : ; done
sleep 1m
sonobuoy retrieve . --kubeconfig /root/.kube/config_infinity
aws s3 cp *.tar.gz s3://${bucket}/sonobuoy_test.tar.gz
sonobuoy delete --kubeconfig /root/.kube/config_infinity
