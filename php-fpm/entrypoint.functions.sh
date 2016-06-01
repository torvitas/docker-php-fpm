#!/bin/bash

function generateSshKeyIfMissing()
{
    mkdir -p /root/.ssh
    chmod 700 -R /root/.ssh
    if [ ! -f ~/.ssh/id_rsa ]; then
      ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
    fi
}

function composerCreate()
{
    disableXDebug
    setComposerPermission
    composer create-project --no-dev
    enableXDebug
}

function composerUp()
{
    disableXDebug
    setComposerPermission
    composer up --no-dev
    enableXDebug
}

function composerUpDev()
{
    disableXDebug
    setComposerPermission
    composer up
    enableXDebug
}

function setComposerPermission()
{
    mkdir -p /usr/local/lib/composer
    chmod g+rwxs -R /usr/local/lib/composer
    mkdir -p /tmp/composer/cache
    chmod g+rwxs -R /tmp/composer/cache
}

function filteredPhpCodeSniffer()
{
    whitelist=/usr/local/etc/phpcs/lists/whitelist
    if [ ! -f ${whitelist} ]; then
        phpCodeSniff ${1}
    fi
    while read folder; do
        echo sniffing in ${folder}
        phpCodeSniff ${1} ${folder}
    done < ${whitelist}
}

function phpCodeSniff()
{
    standard=${1:-PSR2}
    folder=${2:-./}
    mkdir -p /usr/local/etc/phpcs/lists/
    touch /usr/local/etc/phpcs/lists/blacklist
    files=$(find ./${folder} -type f | grep -vf /usr/local/etc/phpcs/lists/blacklist | grep .php)
    disableXDebug
    phpcs --standard=${standard} ${files}
    enableXDebug
}

function phinxMigrate()
{
    phinx migrate --configuration ${PHINX_CONFIGURATION} ${@}
}

function phinxCreateMigration()
{
    phinx create --configuration ${PHINX_CONFIGURATION} ${@}
}

function phinxInit()
{
    phinx init ${@:-${PHINX_CONFIGURATION}}
}

function gitClone()
{
    git clone ${@:-${CI_BUILD_REPO}}
}
