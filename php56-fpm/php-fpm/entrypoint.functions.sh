#!/bin/bash

function generateSshKeyIfMissing()
{
    su developer -c '
        if [ ! -f ~/.ssh/id_rsa ]; then
          mkdir -p ~/.ssh
          chmod 700 -R ~/.ssh
          ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
        fi
        chmod 700 -R ~/.ssh
    '
}

function composerCreate()
{
    disableXDebug
    setComposerPermission
    su developer -pc "composer create-project --no-dev"
    enableXDebug
}

function composerUp()
{
    disableXDebug
    setComposerPermission
    su developer -pc "composer up --no-dev"
    enableXDebug
}

function composerUpDev()
{
    disableXDebug
    setComposerPermission
    su developer -pc "composer up"
    enableXDebug
}

function setComposerPermission()
{
    mkdir -p /usr/local/lib/composer
    chown developer.developer -R /usr/local/lib/composer
    chmod g+rwxs -R /usr/local/lib/composer
    mkdir -p /tmp/composer/cache
    chown developer.developer -R /tmp/composer/cache
    chmod g+rwxs -R /tmp/composer/cache
}

function disableXDebug()
{
    local xDebugIniPath=$(getXDebugIniPath)
    local xDebugIniBackupPath=$(getXDebugIniBackupPath)
    mv $xDebugIniPath $xDebugIniBackupPath
}

function enableXDebug()
{
    local xDebugIniPath=$(getXDebugIniPath)
    local xDebugIniBackupPath=$(getXDebugIniBackupPath)
    mv $xDebugIniBackupPath $xDebugIniPath
}

function getXDebugIniPath()
{
    local xDebugIniPath='/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
    echo $xDebugIniPath
}

function getXDebugIniBackupPath()
{
    local xDebugIniBackupPath='/usr/local/etc/php/docker-php-ext-xdebug.ini'
    echo $xDebugIniBackupPath
}
