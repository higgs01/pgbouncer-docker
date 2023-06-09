#!/bin/sh

set -ex

if [ "$PGUSER" = "postgres" ]; then
    echo "WARNING: pgbouncer will connect with a superuser privileges!"
    echo "You need to fix this as soon as possible."
fi

if [ -z "${CONNECTION_POOLER_CLIENT_TLS_CRT}" ]; then
    openssl req -nodes -new -x509 -subj /CN=spilo.dummy.org \
        -keyout /etc/ssl/certs/pgbouncer.key \
        -out /etc/ssl/certs/pgbouncer.crt
else
    ln -s ${CONNECTION_POOLER_CLIENT_TLS_CRT} /etc/ssl/certs/pgbouncer.crt
    ln -s ${CONNECTION_POOLER_CLIENT_TLS_KEY} /etc/ssl/certs/pgbouncer.key
    if [ ! -z "${CONNECTION_POOLER_CLIENT_CA_FILE}" ]; then
        ln -s ${CONNECTION_POOLER_CLIENT_CA_FILE} /etc/ssl/certs/ca.crt
    fi
fi

envsubst < /etc/pgbouncer/pgbouncer.ini.tmpl > /etc/pgbouncer/pgbouncer.ini
envsubst < /etc/pgbouncer/auth_file.txt.tmpl > /etc/pgbouncer/auth_file.txt

exec /usr/bin/pgbouncer /etc/pgbouncer/pgbouncer.ini