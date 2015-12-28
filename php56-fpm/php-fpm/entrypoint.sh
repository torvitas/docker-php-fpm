#!/bin/bash

export COMPOSER_HOME=${COMPOSER_HOME:-/usr/local/lib/composer/}
export COMPOSER_BIN_DIR=${COMPOSER_BIN_DIR:-}
export COMPOSER_CACHE_DIR=${COMPOSER_CACHE_DIR:-/tmp/composer/cache/}
export COMPOSER_NO_INTERACTION=${COMPOSER_NO_INTERACTION:-1}
export PATH=${PATH}:/usr/local/lib/composer/bin

cd /var/www/html/
. /usr/local/etc/entrypoint.functions.sh
setComposerPermission

if [ -f /usr/local/bin/entrypoint.before.sh ]; then
	. /usr/local/bin/entrypoint.before.sh
fi

generateSshKeyIfMissing
if [ ! -f /var/www/html/composer.lock ]; then
	composerCreate
fi

case ${1} in
    composer:create)
        composerCreate
        exit 0
        ;;
    composer:up)
        composerUp
        exit 0
        ;;
    composer:up:dev)
        composerUpDev
        exit 0
        ;;
esac

if [ -f /usr/local/bin/entrypoint.after.sh ]; then
	. /usr/local/bin/entrypoint.after.sh
fi

exec "$@"
