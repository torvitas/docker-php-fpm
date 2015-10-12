FROM php:5.4-fpm
MAINTAINER "Sascha Marcel Schmidt" <docker@saschaschmidt.net>

RUN cd /tmp/ && \
    curl -O http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz && \
    tar zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz && \
    cd ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/ && \
    mkdir -p /usr/local/lib/php/extensions/ && \
    cp * /usr/local/lib/php/extensions/ && \
    touch /usr/local/etc/php/conf.d/zend_guard_loader.ini && \
    echo 'extension=/usr/local/lib/php/extensions/ZendGuardLoader.so' > /usr/local/etc/php/conf.d/zend_guard_loader.ini

RUN apt-get update && apt-get install libssl-dev zlib1g-dev libpng12-dev libjpeg-dev re2c libmcrypt-dev libxml2-dev libmemcached-dev -y --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN cd /tmp/ && \
    curl -O http://pecl.php.net/get/memcache-2.2.7.tgz && \
    tar zxvf memcache-2.2.7.tgz && \
    mv memcache-2.2.7 /usr/src/php/ext/memcache

RUN cd /tmp/ && \
    curl -O http://pecl.php.net/get/APC-3.1.13.tgz && \
    tar zxvf APC-3.1.13.tgz && \
    mv APC-3.1.13 /usr/src/php/ext/apc

RUN cd /tmp/ && \
    curl -O https://pecl.php.net/get/xdebug-2.3.2.tgz && \
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

RUN cd /tmp/ && \
    curl -O https://pecl.php.net/get/memcached-2.2.0.tgz && \
    tar zxvf memcached-2.2.0.tgz && \
    mv memcached-2.2.0 /usr/src/php/ext/memcached

RUN docker-php-ext-configure gd --with-jpeg-dir --with-png-dir
RUN docker-php-ext-install apc memcache mysqli iconv mcrypt mbstring zip soap mysql bcmath pdo_mysql xdebug gd xhprof mongo memcached

RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN mkdir /usr/local/lib/php/session && chown www-data.www-data /usr/local/lib/php/session

COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY zzz_xdebug.ini /usr/local/etc/php/conf.d/zzz_xdebug.ini
COPY log.ini /usr/local/etc/php/conf.d/log.ini
RUN mkdir /usr/local/etc/php-fpm.d/
