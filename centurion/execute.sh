#!/user/bin/env bash

if [ -z "$1" ]
then
    exit 0
fi

git branch --list "$1*" | xargs -r git branch -d
