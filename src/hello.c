#include <stdio.h>
#include <emscripten/emscripten.h>

#include "add.h"

int main() {
    printf("Hello, Wasm!\n");
    return 0;
}

EMSCRIPTEN_KEEPALIVE
int doAddition(int a, int b) {
    printf("Doing addition: %d + %d in wasm\n", a, b);
    return add_ints(a, b);
}
