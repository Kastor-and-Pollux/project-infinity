FROM golang:alpine

RUN apk --no-cache update \
  && apk --no-cache add ca-certificates python py-pip py-setuptools groff less \
  && pip --no-cache-dir install awscli

WORKDIR /root/
COPY setup.sh .

CMD ["/bin/sh", "setup.sh"]
