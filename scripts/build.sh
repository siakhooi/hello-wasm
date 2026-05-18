#!/usr/bin/env bash

set -euo pipefail

if ! command -v emcc &>/dev/null; then
  echo "Emscripten compiler (emcc) not found. Please install Emscripten SDK and ensure emcc is in your PATH."
  exit 1
fi

mkdir -p docs

emcc src/hello.c -O2 \
  -s  EXPORTED_RUNTIME_METHODS='["ccall"]' \
  -o docs/hello.js
