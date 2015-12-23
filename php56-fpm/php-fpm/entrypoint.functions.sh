#!/bin/bash

function generateSshKeyIfMissing()
{
    su developer -c '
        if [ ! -f ~/.ssh/id_rsa ]; then
          mkdir -p ~/.ssh
          chmod 700 -R ~/.ssh
          ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
        fi
    '
}

function composerCreate()
{
    disableXDebug
    su developer -pc "composer create-project --no-dev"
    enableXDebug
}

function composerUp()
{
    disableXDebug
    su developer -pc "composer up --no-dev"
    enableXDebug
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
