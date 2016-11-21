#!/bin/bash

export PATH=${PATH}:/usr/local/lib/composer/bin/
ssh-add -l

if [ -f /usr/local/bin/entrypoint.d/user/*.sh ]; then
    source /usr/local/bin/entrypoint.d/user/*.sh
fi

exec ${@}
