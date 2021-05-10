#!/bin/sh

[ "${DEBUG:-}" = "yes" ] && set -x

: "${SERVER_HOSTNAME:?"required but not set"}"
: "${SMTP_SERVER:?"required but not set"}"
: "${SMTP_PORT:=587}"
: "${SMTP_NETWORKS:="10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16"}"
: "${SMTP_PASSWORD_FILE:=}"
: "${SMTP_USERNAME:=}"
: "${SMTP_PASSWORD:=}"

if [ -n "${SMTP_PASSWORD_FILE}" ] && [ -f "${SMTP_PASSWORD_FILE}" ]; then
    SMTP_PASSWORD=$(cat "${SMTP_PASSWORD_FILE}")
fi

if [ -n "${SMTP_USERNAME}" ] && [ -z "${SMTP_PASSWORD}" ]; then
    echo "FATAL: SMTP_USERNAME is set but SMTP_PASSWORD isn't (or file nebtioned in SMTP_PASSWORD_FILE does not exist or is empty)"
    exit 1
fi

postconf -e "myhostname = ${SERVER_HOSTNAME}"
postconf -e "relayhost = [${SMTP_SERVER}]:${SMTP_PORT}"
postconf -e "mynetworks = ${SMTP_NETWORKS}"

if [ -n "${SMTP_USERNAME}" ]; then
    postconf -e 'smtp_sasl_auth_enable = yes'
    postconf -e 'smtp_sasl_password_maps = lmdb:/etc/postfix/sasl_passwd'
    postconf -e 'smtp_sasl_security_options = noanonymous'
else
    postconf -X smtp_sasl_auth_enable smtp_sasl_password_maps smtp_sasl_security_options
fi

if [ ! -f /etc/postfix/sasl_passwd ] && [ -n "${SMTP_USERNAME}" ]; then
    if ! grep -q "${SMTP_SERVER}" /etc/postfix/sasl_passwd 2> /dev/null; then
        echo "[${SMTP_SERVER}]:${SMTP_PORT} ${SMTP_USERNAME}:${SMTP_PASSWORD}" >> /etc/postfix/sasl_passwd
        postmap /etc/postfix/sasl_passwd
    fi
fi

if [ "${SMTP_PORT}" = "465" ]; then
    postconf -e 'smtp_tls_wrappermode = yes'
    postconf -e 'smtp_tls_security_level = encrypt'
else
    postconf -X smtp_tls_wrappermode smtp_tls_security_level
fi

if [ $$ = 1 ]; then
    rm -f /var/spool/postfix/pid/master.pid
fi

exec /usr/sbin/postfix -c /etc/postfix start-fg
