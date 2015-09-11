FROM php:7-fpm
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN apt-get update && apt-get install -y libssl-dev libpng12-dev libjpeg-dev libfreetype6-dev re2c libmcrypt-dev libxml2-dev --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN cd /tmp/ && \
    curl -O http://pecl.php.net/get/memcache-2.2.7.tgz && \
    tar zxvf memcache-2.2.7.tgz && \
    mv memcache-2.2.7 /usr/src/php/ext/memcache

RUN docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-freetype-dir
RUN docker-php-ext-install mysqli iconv mcrypt mbstring zip soap bcmath pdo_mysql gd

RUN mkdir /usr/local/lib/php/session && chown www-data.www-data /usr/local/lib/php/session

COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY fpm/ /usr/local/etc/php/fpm/pool.d/
COPY php/ /usr/local/etc/php/conf.d/
RUN touch /usr/local/etc/php-fpm.d/default.conf
