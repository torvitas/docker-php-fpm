#!/bin/bash
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


generateSshKeyIfMissing
if [ -f /usr/local/bin/entrypoint.d/*.sh ]; then
    source /usr/local/bin/entrypoint.d/*.sh
fi

case ${1} in
    php-fpm)
        php-fpm
esac

HOME="/home/${WEB_USER}" sudo -u ${WEB_USER} -E -- /usr/local/bin/user.entry.sh ${cmd}
