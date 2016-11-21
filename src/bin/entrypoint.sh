#!/bin/bash
source /usr/local/bin/entrypoint.functions.sh
source /usr/local/bin/template.renderer.sh

export COMPOSER_HOME=${COMPOSER_HOME:-/usr/local/lib/composer/}
export COMPOSER_BIN_DIR=${COMPOSER_BIN_DIR:-}
export COMPOSER_CACHE_DIR=${COMPOSER_CACHE_DIR:-/tmp/composer/cache/}
export COMPOSER_NO_INTERACTION=${COMPOSER_NO_INTERACTION:-1}
export PATH=${PATH}:/usr/local/lib/composer/bin
cmd=${@}

export WEB_USER_UID=${WEB_USER_UID:-"1000"}
export WEB_USER=${WEB_USER:-"web"}
export WEB_ROOT=${WEB_ROOT:-/var/www/html}
useradd ${WEB_USER} -mu ${WEB_USER_UID}  > /dev/null 2>&1
chown -R ${WEB_USER}.${WEB_USER} /home/${WEB_USER}
gpasswd -a ${WEB_USER} superuser
chmod +x /usr/local/bin/user.entry.sh

render /usr/local/templates/php-fpm.conf.template -- > /usr/local/etc/php-fpm.conf

cd ${WEB_ROOT}
setComposerPermission

mkdir /usr/local/lib/php/session && chown ${WEB_USER}.${WEB_USER} /usr/local/lib/php/session

if [ -f /usr/local/bin/entrypoint.d/*.sh ]; then
    source /usr/local/bin/entrypoint.d/*.sh
fi

case ${1} in
    composer)
        set -e
        disableXDebug
        echo "using the composer entrypoint is deprecated, this function is going to be removed soon";
        su ${WEB_USER} -pc "composer ${@:2}"
        enableXDebug
        exit 0
        ;;
    composer:create)
        set -e
        echo "using the composer:create entrypoint is deprecated, this function is going to be removed soon";
        composerCreate
        exit 0
        ;;
    composer:up)
        set -e
        echo "using the composer:up entrypoint is deprecated, this function is going to be removed soon";
        composerUp
        exit 0
        ;;
    composer:up:dev)
        set -e
        echo "using the composer:up:dev entrypoint is deprecated, this function is going to be removed soon";
        composerUpDev
        exit 0
        ;;
    phpcs:psr2)
        set -e
        echo "using the phpcs:psr2 entrypoint is deprecated, this function is going to be removed soon";
        filteredPhpCodeSniffer PSR2
        exit 0
        ;;
    php-fpm)
        php-fpm
esac

HOME="/home/${WEB_USER}" sudo -u ${WEB_USER} -E -- /usr/local/bin/user.entry.sh ${cmd}
