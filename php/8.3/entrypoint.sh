#!/bin/sh
set -e

if [ -f /etc/nginx/custom.conf ]; then
    cp /etc/nginx/custom.conf /etc/nginx/conf.d/default.conf
else
    envsubst '$NGINX_ROOT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
fi

if [ "${VITE_ENABLED}" = "true" ]; then
    envsubst '$PROJECT_ROOT' < /etc/supervisor/conf.d/vite.conf.template >> /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
