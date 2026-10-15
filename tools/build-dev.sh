#!/usr/bin/env bash
# Bundles the library and a script that uses it into one file for in-game
# testing, so the library does not have to be hosted first.
# Usage: tools/build-dev.sh [script]   (default: examples/demo.lua)
set -e
cd "$(dirname "$0")/.."
script="${1:-examples/demo.lua}"
mkdir -p build
{
    echo 'local Library = (function()'
    cat src/PaneUI.lua
    echo
    echo 'end)()'
    # Drop everything up to and including the loadstring line.
    sed '1,/^local Library = /d' "$script"
} > build/dev.lua
echo "build/dev.lua"
