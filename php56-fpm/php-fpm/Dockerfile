FROM php:5.6-fpm
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN apt-get update && apt-get install -y libssl-dev libpng12-dev libjpeg-dev re2c libmcrypt-dev libxml2-dev --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN cd /tmp/ && \
    curl -O http://pecl.php.net/get/memcache-2.2.7.tgz && \
    tar zxvf memcache-2.2.7.tgz && \
    mv memcache-2.2.7 /usr/src/php/ext/memcache

RUN cd /tmp/ && \
    curl -O http://pecl.php.net/get/xdebug-2.3.2.tgz && \
    tar zxvf xdebug-2.3.2.tgz && \
    mv xdebug-2.3.2 /usr/src/php/ext/xdebug

RUN cd /tmp/ && \
    curl -O https://pecl.php.net/get/xhprof-0.9.4.tgz && \
    tar zxvf xhprof-0.9.4.tgz && \
    mv xhprof-0.9.4/extension /usr/src/php/ext/xhprof

RUN cd /tmp/ && \
    curl -O https://pecl.php.net/get/mongo-1.6.8.tgz && \
    tar zxvf mongo-1.6.8.tgz && \
    mv mongo-1.6.8 /usr/src/php/ext/mongo

RUN docker-php-ext-configure gd --with-jpeg-dir --with-png-dir
RUN docker-php-ext-install mysqli iconv mcrypt mbstring zip soap mysql bcmath xdebug memcache pdo_mysql gd xhprof mongo

RUN mkdir /usr/local/lib/php/session && chown www-data.www-data /usr/local/lib/php/session

COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY zzz_xdebug.ini /usr/local/etc/php/conf.d/zzz_xdebug.ini
COPY date.ini /usr/local/etc/php/conf.d/date.ini
COPY log.ini /usr/local/etc/php/conf.d/log.ini
RUN mkdir /usr/local/etc/php-fpm.d/
