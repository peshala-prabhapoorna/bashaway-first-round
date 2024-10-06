#!/bin/bash
r=$(curl -s -X POST "http://localhost:9000/api/auth/login" -H "x-api-version: 1.0" -d 'username=bashaway&password=2k24')

if [ -z "$r" ]
then
    exit
else
    echo "$r"
fi
