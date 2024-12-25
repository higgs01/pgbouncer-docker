FROM alpine:3.21.0

RUN addgroup -S pgbouncer && adduser -S pgbouncer && mkdir /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer

RUN apk --no-cache --update add libevent openssl c-ares gettext ca-certificates postgresql-client pgbouncer bash

WORKDIR /

COPY pgbouncer/auth_file.txt.tmpl /etc/pgbouncer/auth_file.txt.tmpl
COPY pgbouncer/pgbouncer.ini.tmpl /etc/pgbouncer/pgbouncer.ini.tmpl
COPY entrypoint.sh /

RUN chown -R pgbouncer:pgbouncer /var/log/pgbouncer /var/run/pgbouncer /etc/pgbouncer /etc/ssl/certs

USER pgbouncer:pgbouncer
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]