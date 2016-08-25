#!/bin/bash
source /usr/local/bin/entrypoint.functions.sh
source /usr/local/bin/template.renderer.sh

export COMPOSER_HOME=${COMPOSER_HOME:-/usr/local/lib/composer/}
export COMPOSER_BIN_DIR=${COMPOSER_BIN_DIR:-}
export COMPOSER_CACHE_DIR=${COMPOSER_CACHE_DIR:-/tmp/composer/cache/}
export COMPOSER_NO_INTERACTION=${COMPOSER_NO_INTERACTION:-1}
export PATH=${PATH}:/usr/local/lib/composer/bin
cmd=${@}

WEB_USER_UID=${WEB_USER_UID:-"1000"}
WEB_USER=${WEB_USER:-"web"}
useradd ${WEB_USER} -mu ${WEB_USER_UID}  > /dev/null 2>&1
chown -R ${WEB_USER}.${WEB_USER} /home/${WEB_USER}
gpasswd -a ${WEB_USER} superuser

render /usr/local/templates/php-fpm.conf.template -- > /usr/local/etc/php-fpm.conf

cd /var/www/html/
setComposerPermission

mkdir /usr/local/lib/php/session && chown ${WEB_USER}.${WEB_USER} /usr/local/lib/php/session


generateSshKeyIfMissing
if [ -f /usr/local/bin/entrypoint.d/*.sh ]; then
    source /usr/local/bin/entrypoint.d/*.sh
fi

case ${1} in
    composer:create)
        set -e
        composerCreate
        exit 0
        ;;
    composer:up)
        set -e
        composerUp
        exit 0
        ;;
    composer:up:dev)
        set -e
        composerUpDev
        exit 0
        ;;
    phpcs:psr2)
        set -e
        filteredPhpCodeSniffer PSR2
        exit 0
        ;;
    php-fpm)
        php-fpm
esac

HOME="/home/${WEB_USER}" sudo -u ${WEB_USER} -E -- ${cmd}
