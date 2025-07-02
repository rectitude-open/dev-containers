#!/bin/sh
set -e

envsubst '$NGINX_ROOT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

if [ "${VITE_ENABLED}" = "true" ]; then
    envsubst '$PROJECT_ROOT' < /etc/supervisor/conf.d/vite.conf.template >> /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
