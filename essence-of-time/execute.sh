#!/bin/bash

if [ -z "$1" ]
then
    exit
fi

date -d"$1" +%s
