FROM php:8.3-fpm

ENV NODE_VERSION=20.x

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

ARG TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get clean && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    apt-utils \
    vim \
    wget \
    git \
    curl \
    htop \
    cron \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libmemcached-dev \
    libzip-dev \
    libpng-dev \
    libwebp-dev \
    libonig-dev \
    libxml2-dev \
    librdkafka-dev \
    libpq-dev \
    libicu-dev \
    openssh-server \
    zip \
    unzip \
    supervisor \
    sqlite3  \
    nano \
    cron

COPY --from=composer/composer /usr/bin/composer /usr/bin/composer

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
RUN apt-get install -y nodejs

RUN apt-get install -y nginx && \
    rm /etc/nginx/sites-enabled/default && \
    mkdir -p /home/wwwlogs

RUN yes | docker-php-ext-install mysqli && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ --with-webp && \
    docker-php-ext-install pdo_mysql gd zip pcntl bcmath mbstring exif && \
    docker-php-ext-enable opcache && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl

RUN yes | pecl install xdebug && \
    docker-php-ext-enable xdebug

WORKDIR /home/wwwroot

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
