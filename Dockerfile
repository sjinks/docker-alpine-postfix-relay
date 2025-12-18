FROM alpine:3.23.2@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62

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
