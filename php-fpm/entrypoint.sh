#!/bin/bash

export COMPOSER_HOME=${COMPOSER_HOME:-/usr/local/lib/composer/}
export COMPOSER_BIN_DIR=${COMPOSER_BIN_DIR:-}
export COMPOSER_CACHE_DIR=${COMPOSER_CACHE_DIR:-/tmp/composer/cache/}
export COMPOSER_NO_INTERACTION=${COMPOSER_NO_INTERACTION:-1}
export PATH=${PATH}:/usr/local/lib/composer/bin
export MIGRATION_DIR=${MIGRATION_DIR:-/var/www/migrations/}
export PHINX_CONFIGURATION=${PHINX_CONFIGURATION:-${MIGRATION_DIR}"phinx.yml"}

update-ca-certificates

cd /var/www/html/
. /usr/local/etc/entrypoint.xdebug.functions.sh
. /usr/local/etc/entrypoint.functions.sh
setComposerPermission

if [ -f /usr/local/bin/entrypoint.before.sh ]; then
	. /usr/local/bin/entrypoint.before.sh
fi

generateSshKeyIfMissing

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
    phpcs:oxid)
        set -e
        filteredPhpCodeSniffer Oxid
        exit 0
        ;;
    phinx:migrate)
        set -e
        phinxMigrate ${@:2}
        exit 0
        ;;
    phinx:create)
        set -e
        phinxCreateMigration ${@:2}
        exit 0
        ;;
    phinx:init)
        set -e
        phinxInit ${@:2}
        exit 0
        ;;
    git:clone)
        set -e
        gitClone ${@:2}
        exit 0
        ;;
esac

if [ -f /usr/local/bin/entrypoint.after.sh ]; then
	. /usr/local/bin/entrypoint.after.sh $@
fi

exec "$@"
