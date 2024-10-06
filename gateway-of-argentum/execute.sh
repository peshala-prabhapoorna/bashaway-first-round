#!/bin/bash

mkdir -p out

while IFS= read -r line || [[ -n "$line" ]]; do
    masked_line=$(echo "$line" | sed -E 's/(.*)([0-9]{4})$/************\2/')
    echo "$masked_line" >> out/masked.txt
done < src/parchment.txt
