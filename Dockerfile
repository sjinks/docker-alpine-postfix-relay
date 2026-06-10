FROM alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4

RUN \
    apk add --no-cache postfix cyrus-sasl cyrus-sasl-login cyrus-sasl-crammd5 && \
    postconf -ev 'inet_interfaces = all' && \
    postconf -ev 'mydestination = localhost' && \
    postconf -ev 'myorigin = $mydomain' && \
    postconf -ev 'smtp_use_tls = yes' && \
    postconf -ev 'smtp_host_lookup = native,dns' && \
    postconf -ev 'maillog_file = /dev/stdout' && \
    postconf -Mv "postlog/unix-dgram=postlog   unix-dgram n  -       n       -       1       postlogd" && \
    newaliases

COPY entrypoint.sh /usr/local/bin/

EXPOSE 25
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
