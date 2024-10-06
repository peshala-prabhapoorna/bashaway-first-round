#!/usr/bin/env bash

if [ -z "$1" ]; then
    exit 
fi

if (( $1 % 2 == 0 )); then
    echo "Even"
else
    echo "Odd"
fi
