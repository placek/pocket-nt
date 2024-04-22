FROM alpine:3.19.1
ADD https://www.princexml.com/download/prince-15.3-r0-alpine3.19-x86_64.apk /tmp/prince.apk
RUN apk update && \
    apk add --allow-untrusted /tmp/prince.apk && \
    apk add --no-cache curl ghostscript unzip make sed sqlite && \
    rm /tmp/prince.apk && \
    mkdir /app
COPY . /app
WORKDIR /data
ENTRYPOINT ["make", "-f", "/app/Makefile"]
