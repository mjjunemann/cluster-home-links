#!/bin/bash

DEBUG=false
if [[ $DEBUG = true ]]; then
    DEBUG_PATH=($PWD)
    echo DEBUG MODE: $DEBUG
    echo "DEBUG PATH: $DEBUG_PATH"
fi

function check_and_export {

    local search="$1"
    #if ! grep -q $search "$DEBUG_PATH/exports"; then
    if ! grep -q -e $search /etc/exports; then
        local append="$2     192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)"
        if $DEBUG; then
            echo $append >> $DEBUG_PATH/exports
        else
            echo $append >> /etc/exports
            exportfs -a
        fi
        echo "Export added to /etc/exports: "
        echo "\t $append"
    else
        echo "Export already exists for $1"
    fi
}

check_and_export "/home\b[^/]" /home