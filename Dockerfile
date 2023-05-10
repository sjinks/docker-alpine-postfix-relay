FROM alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11

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
