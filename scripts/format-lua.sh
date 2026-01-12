#!/bin/bash
# Format Lua files using stylua (installed via mason)

STYLUA_PATH="$HOME/.local/share/nvim/mason/bin/stylua"

if [ ! -x "$STYLUA_PATH" ]; then
    echo "stylua not found at $STYLUA_PATH. Please ensure it's installed via mason."
    exit 1
fi

for file in "$@"; do
    if [[ "$file" == *.lua ]]; then
        "$STYLUA_PATH" "$file"
        echo "Formatted $file"
    else
        echo "Skipping $file (not a .lua file)"
    fi
done