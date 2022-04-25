FROM alpine:3.10

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh

RUN git lfs install

COPY mirror.sh /mirror.sh
COPY setup-ssh.sh /setup-ssh.sh

ENTRYPOINT ["/mirror.sh"]
