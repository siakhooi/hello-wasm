#!/usr/bin/env bash

# Build with GCC/Clang coverage, run unit tests, then emit an HTML report
# (lcov + genhtml) or plain gcov listings if lcov is not installed.

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

if [ -z "${CC:-}" ]; then
  if command -v cc &>/dev/null; then
    CC=cc
  elif command -v gcc &>/dev/null; then
    CC=gcc
  else
    echo "No C compiler found (cc or gcc). Install a toolchain to run coverage."
    exit 1
  fi
fi

rm -rf coverage/build coverage/html coverage/coverage.info coverage/lcov.info
mkdir -p coverage/build

# Separate objects so .gcno/.gcda basenames match sources (gcov fallback works;
# single-invocation compile uses names like test_runner-add.gcno on newer GCC).
# Unity is built without --coverage so reports stay focused on project sources.
"$CC" -std=c11 -Wall -Wextra -Werror -O0 -g -Ithird_party/unity \
  -c third_party/unity/unity.c -o coverage/build/unity.o
"$CC" --coverage -std=c11 -Wall -Wextra -Werror -O0 -g -Isrc -Ithird_party/unity \
  -c src/add.c -o coverage/build/add.o
"$CC" --coverage -std=c11 -Wall -Wextra -Werror -O0 -g -Isrc -Ithird_party/unity \
  -c tests/test_add.c -o coverage/build/test_add.o
"$CC" --coverage -Wall -Wextra -Werror \
  coverage/build/add.o coverage/build/test_add.o coverage/build/unity.o \
  -o coverage/build/test_runner

coverage/build/test_runner

if command -v lcov &>/dev/null && command -v genhtml &>/dev/null; then
  lcov --capture --directory coverage/build --output-file coverage/lcov.info \
    --rc lcov_branch_coverage=1
  lcov --remove coverage/lcov.info \
    '*/tests/*' \
    -o coverage/coverage.info
  genhtml coverage/coverage.info \
    --branch-coverage \
    --title "hello-wasm coverage" \
    -o coverage/html
  echo "Coverage HTML: ${root}/coverage/html/index.html"
else
  echo "lcov/genhtml not in PATH; install lcov for an HTML report (e.g. apt install lcov)."
  echo "Falling back to gcov text under coverage/gcov/"
  mkdir -p coverage/gcov
  gcov -o coverage/build -b -c src/add.c
  if [[ -f add.c.gcov ]]; then
    mv -f add.c.gcov coverage/gcov/add.c.gcov
  fi
  echo "See: ${root}/coverage/gcov/add.c.gcov"
fi
