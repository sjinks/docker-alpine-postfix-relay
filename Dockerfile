FROM alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a

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
