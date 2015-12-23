#!/bin/bash

su developer -pc 'mkdir -p /tmp/.composer'
export COMPOSER_HOME=${COMPOSER_HOME:-/tmp/.composer/}
export COMPOSER_CACHE_DIR=${COMPOSER_CACHE_DIR:-}
export COMPOSER_NO_INTERACTION=${COMPOSER_NO_INTERACTION:-1}

cd /var/www/html/
. /usr/local/etc/entrypoint.functions.sh

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
esac

if [ -f /usr/local/bin/entrypoint.after.sh ]; then
	. /usr/local/bin/entrypoint.after.sh
fi

exec "$@"
