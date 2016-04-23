FROM php:5.6-fpm
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        imagemagick \
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

RUN docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-freetype-dir
RUN docker-php-ext-install gd
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mysql
RUN docker-php-ext-install iconv
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install soap
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache

RUN cd /tmp/ && \
    curl -O http://pecl.php.net/get/xdebug-2.3.2.tgz && \
    tar zxvf xdebug-2.3.2.tgz && \
    mv xdebug-2.3.2 /usr/src/php/ext/xdebug
RUN docker-php-ext-install xdebug

RUN cd /tmp/ && \
    curl -O https://pecl.php.net/get/mongodb-1.1.5.tgz && \
    tar zxvf mongodb-1.1.5.tgz && \
    mv mongodb-1.1.5 /usr/src/php/ext/mongodb
RUN docker-php-ext-install mongodb

RUN cd /tmp/ && \
    curl -O https://pecl.php.net/get/memcached-2.2.0.tgz && \
    tar zxvf memcached-2.2.0.tgz && \
    mv memcached-2.2.0 /usr/src/php/ext/memcached
RUN docker-php-ext-install memcached

RUN cd /tmp/ && \
    curl -O http://downloads.zend.com/guard/7.0.0/zend-loader-php5.6-linux-x86_64.tar.gz && \
    tar zxvf zend-loader-php5.6-linux-x86_64.tar.gz && \
    cd zend-loader-php5.6-linux-x86_64/ && \
    mkdir -p /usr/local/lib/php/extensions/ && \
    cp * /usr/local/lib/php/extensions/ && \
    touch /usr/local/etc/php/conf.d/zend_guard_loader.ini && \
    echo 'zend_extension=/usr/local/lib/php/extensions/ZendGuardLoader.so' > /usr/local/etc/php/conf.d/zend_guard_loader.ini

RUN cd /tmp/ && \
    curl -O http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar zxvf ioncube_loaders_lin_x86-64.tar.gz && \
    mkdir -p /usr/local/lib/php/extensions/ && \
    cp ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/ioncube.so && \
    rm -rf ioncube && \
    touch /usr/local/etc/php/conf.d/aaa_ext-ioncube.ini && \
    echo 'zend_extension=/usr/local/lib/php/extensions/ioncube.so' > /usr/local/etc/php/conf.d/aaa_ext-ioncube.ini

RUN cd /tmp/ && \
    curl -O http://pecl.php.net/get/memcache-2.2.7.tgz && \
    tar zxvf memcache-2.2.7.tgz && \
    mv memcache-2.2.7 /usr/src/php/ext/memcache
RUN docker-php-ext-install memcache

RUN cd /tmp/ && \
    curl -O https://pecl.php.net/get/xhprof-0.9.4.tgz && \
    tar zxvf xhprof-0.9.4.tgz && \
    mv xhprof-0.9.4/extension /usr/src/php/ext/xhprof
RUN docker-php-ext-install xhprof

RUN mkdir /usr/local/lib/php/session && chown www-data.www-data /usr/local/lib/php/session

ENV COMPOSER_HOME=/usr/local/lib/composer/
ENV COMPOSER_CACHE_DIR=/tmp/composer/cache/
ENV COMPOSER_BIN_DIR=/usr/local/lib/composer/bin/
ENV PATH=${PATH}:/usr/local/lib/composer/bin

COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY fpm/ /usr/local/etc/php/fpm/pool.d/
COPY php/ /usr/local/etc/php/conf.d/
RUN mkdir -p /usr/local/etc/php-fpm.d/
RUN touch /usr/local/etc/php-fpm.d/default.conf

RUN useradd -mu 1000 developer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
COPY entrypoint.sh /usr/local/bin/
COPY entrypoint.functions.sh /usr/local/etc/
RUN bash -c "source /usr/local/etc/entrypoint.functions.sh && \
    disableXDebug && \
    composer global config repositories.oxidesales vcs https://github.com/torvitas/coding_standards.git && \
    composer global require codeception/codeception:~2.1 \
                            squizlabs/php_codesniffer:~2.5 \
                            oxid-esales/coding-standards:~2.0 && \
    enableXDebug"
RUN phpcs --config-set ignore_warnings_on_exit 1
RUN phpcs --config-set show_progress 1
RUN phpcs --config-set default_standard PSR2
RUN phpcs --config-set installed_paths /usr/local/lib/composer/vendor/oxid-esales/coding-standards/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN echo PATH=${PATH} >> /home/developer/.profile

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
VOLUME ["/tmp/composer/cache", "/home/developer/.ssh"]
CMD ["php-fpm"]
