FROM alpine:3.19.1
ADD https://www.princexml.com/download/prince-15.3-r0-alpine3.19-x86_64.apk /tmp/prince.apk
RUN apk add --allow-untrusted /tmp/prince.apk && rm /tmp/prince.apk
ENTRYPOINT ["prince"]
