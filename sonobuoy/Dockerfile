FROM golang:alpine

RUN apk --no-cache update \
  && apk --no-cache add curl ca-certificates python py-pip py-setuptools groff less \
  && pip --no-cache-dir install awscli \
  && curl -LO --silent --show-error https://github.com/heptio/sonobuoy/releases/download/v0.11.6/sonobuoy_0.11.6_linux_amd64.tar.gz \
  && tar -zxvf sonobuoy_0.11.6_linux_amd64.tar.gz \
  && mv sonobuoy /usr/local/bin/ \
  && rm sonobuoy_0.11.6_linux_amd64.tar.gz \
  && chmod +x /usr/local/bin/sonobuoy

COPY setup.sh .

CMD ["/bin/sh", "setup.sh"]
