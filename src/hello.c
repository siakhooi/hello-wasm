#include <stdio.h>
#include <emscripten/emscripten.h>

int main() {
    printf("Hello, Wasm!\n");
    return 0;
}


EMSCRIPTEN_KEEPALIVE
int doAddition(int a, int b) {
    printf("Doing addition: %d + %d in wasm\n", a, b);
    return a + b;
}
