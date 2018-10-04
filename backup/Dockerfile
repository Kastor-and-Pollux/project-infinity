FROM alpine:latest

ENV KUBECTL_VERSION=v1.10.2
ENV ARK_VERSION=v0.9.6

RUN apk --no-cache update \
  && apk --no-cache add git curl \
  && curl -LO --silent --show-error https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && curl -LO --silent --show-error https://github.com/heptio/ark/releases/download/${ARK_VERSION}/ark-${ARK_VERSION}-linux-amd64.tar.gz \
  && tar -zxvf ark-${ARK_VERSION}-linux-amd64.tar.gz \
  && mv ark /usr/local/bin/ \
  && chmod +x /usr/local/bin/kubectl /usr/local/bin/ark

WORKDIR /root/
COPY setup.sh .

CMD ["/bin/sh", "setup.sh"]

