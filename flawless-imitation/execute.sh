#!/bin/bash

SRC_DIR="src"
OUT_DIR="out"

mkdir -p "$OUT_DIR"

find "$SRC_DIR" -type f | while read -r file; do
    relative_path="${file#$SRC_DIR/}"
    
    if [[ "$relative_path" == *.js ]]; then
        new_file_name="${relative_path%.js}_clone.js"
    else
        new_file_name="$relative_path"
    fi

    mkdir -p "$OUT_DIR/$(dirname "$new_file_name")"

    cp "$file" "$OUT_DIR/$new_file_name"
done
