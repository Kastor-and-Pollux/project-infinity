FROM alpine:latest

ENV KOPS_VERSION=1.9.0
ENV KUBECTL_VERSION=v1.10.2

RUN apk --no-cache update \
  && apk --no-cache add git curl ca-certificates python py-pip py-setuptools groff less \
  && pip --no-cache-dir install awscli \
  && curl -LO --silent --show-error https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kops /usr/local/bin/kubectl

WORKDIR /root/
COPY setup.sh .
CMD ["/bin/sh", "setup.sh"]
