FROM alpine:3.8

RUN apk --no-cache update && apk --no-cache add git

COPY setup.sh .
CMD ["/bin/sh", "setup.sh"]
