#!/usr/bin/env bash

curl -Ls https://rb.gy/n3c2i5 | grep total_count | head -1 | grep -oP '"total_count":\s*\K\d+'
