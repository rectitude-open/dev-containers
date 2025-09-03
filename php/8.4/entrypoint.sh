#!/bin/sh
set -e

if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
    WWW_DATA_CURRENT_UID=$(id -u www-data)
    WWW_DATA_CURRENT_GID=$(id -g www-data)
 
    if [ "$WWW_DATA_CURRENT_UID" != "$HOST_UID" ] || [ "$WWW_DATA_CURRENT_GID" != "$HOST_GID" ]; then
        groupmod -o -g "$HOST_GID" www-data
        usermod -o -u "$HOST_UID" www-data
    fi
fi

if [ -n "$PROJECT_ROOT" ]; then
    usermod -d "$PROJECT_ROOT" www-data
    chown www-data:www-data "$PROJECT_ROOT"
fi

if [ -f /etc/nginx/custom.conf ]; then
    cp /etc/nginx/custom.conf /etc/nginx/conf.d/default.conf
else
    envsubst '$NGINX_ROOT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
fi

if [ "${VITE_ENABLED}" = "true" ]; then
    envsubst '$PROJECT_ROOT' < /etc/supervisor/conf.d/vite.conf.template >> /etc/supervisor/conf.d/supervisord.conf
fi

if [ -f /etc/supervisor/custom.conf ]; then
    envsubst '$PROJECT_ROOT' < /etc/supervisor/custom.conf >> /etc/supervisor/conf.d/supervisord.conf
fi

exec "$@"
