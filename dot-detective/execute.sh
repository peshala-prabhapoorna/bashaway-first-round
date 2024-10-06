#!/usr/bin/env bash

mkdir -p out
jq '[paths(scalars) as $path | {"key": $path | join("."), "value": getpath($path)}] | from_entries' src/chaos.json > out/transformed.json
