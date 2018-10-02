FROM alpine:latest

ENV KOPS_VERSION=1.9.0
# https://kubernetes.io/docs/tasks/kubectl/install/
# latest stable kubectl: curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION=v1.10.2

RUN apk --no-cache update \
  && apk --no-cache add ca-certificates python py-pip py-setuptools groff less \
  && apk --no-cache add --virtual build-dependencies curl \
  && pip --no-cache-dir install awscli \
  && curl -LO --silent --show-error https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kops /usr/local/bin/kubectl \
  && apk del --purge build-dependencies

WORKDIR /root/
COPY setup.sh .
# COPY cluster.yaml . 
CMD ["/bin/sh", "setup.sh"]
