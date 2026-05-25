#!/usr/bin/env bash

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

if ! command -v cc &>/dev/null && ! command -v gcc &>/dev/null; then
  echo "No C compiler found (cc or gcc). Install a toolchain to run unit tests."
  exit 1
fi

: "${CC:=cc}"
mkdir -p tests

"$CC" -std=c11 -Wall -Wextra -Werror -Isrc -Ithird_party/unity \
  tests/test_add.c src/add.c third_party/unity/unity.c \
  -o tests/test_runner

exec ./tests/test_runner
