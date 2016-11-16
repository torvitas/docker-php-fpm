FROM php:7-fpm-alpine
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        imagemagick \
        libmagickwand-dev \
        openssh-client \
        sudo \
        git \
        libmemcached-dev \
        libssl-dev \
        libpng12-dev \
        libjpeg-dev \
        re2c \
        libfreetype6-dev \
        libmcrypt-dev \
        libxml2-dev && \
    rm -r /var/lib/apt/lists/*


RUN cd /tmp/ && \
    mkdir -p /usr/src/php/ext && \
    curl -O http://pecl.php.net/get/xdebug-2.4.0.tgz && \
    tar zxvf xdebug-2.4.0.tgz && \
    mv xdebug-2.4.0 /usr/src/php/ext/xdebug && \
    curl -O https://pecl.php.net/get/mongodb-1.1.5.tgz && \
    tar zxvf mongodb-1.1.5.tgz && \
    mv mongodb-1.1.5 /usr/src/php/ext/mongodb && \
    curl -O https://pecl.php.net/get/imagick-3.4.3RC1.tgz && \
    tar zxvf imagick-3.4.3RC1.tgz && \
    mv imagick-3.4.3RC1 /usr/src/php/ext/imagick && \
    git clone https://github.com/php-memcached-dev/php-memcached.git /usr/src/php/ext/memcached && \
    cd /usr/src/php/ext/memcached && \
    git checkout php7 && \
    git clone https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis && \
    cd /usr/src/php/ext/redis && \
    git checkout php7 && \
    echo 'xdebug' >> /usr/src/php-available-exts && \
    echo 'mongodb' >> /usr/src/php-available-exts && \
    echo 'imagick' >> /usr/src/php-available-exts && \
    echo 'memcached' >> /usr/src/php-available-exts && \
    echo 'redis' >> /usr/src/php-available-exts && \
    cd / && \
    rm -rf /tmp/*

RUN cd /usr/src/ && tar -xf php.tar.xz && cp -rf php-${PHP_VERSION}/* php && cd /var/www/html && \
    docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-freetype-dir && \
    docker-php-ext-install \
    gd \
    imagick \
    xdebug \
    soap \
    iconv \
    mcrypt \
    mbstring \
    pdo_mysql \
    mysqli \
    zip \
    bcmath \
    opcache \
    mongodb \
    memcached \
    redis \
    pcntl && \
    rm -rf /usr/src/php*

RUN addgroup superuser && \
    echo '%superuser        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers

CMD ["php-fpm"]

ENTRYPOINT ["bash", "-i", "/usr/local/bin/entrypoint.sh"]
COPY src/ /usr/local/
RUN chmod +x /usr/local/bin/entrypoint.sh
