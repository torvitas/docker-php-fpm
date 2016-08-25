#!/bin/bash

function render()
{
    File="$1"
    while read -r line; do
        while [[ "$line" =~ (\$[\{\(]?[a-zA-Z_][a-zA-Z_0-9]*[\}\)]) ]]; do
            LHS=${BASH_REMATCH[1]}
            RHS="$(eval echo "\"$LHS\"")"
            line=${line//$LHS/$RHS}
        done
        echo -e "$line"
    done < $File
}
