#include <assert.h>
#include <limits.h>
#include <stdio.h>

#include "add.h"

static void test_add_positive(void) {
    assert(add_ints(2, 3) == 5);
    assert(add_ints(0, 0) == 0);
}

static void test_add_negative(void) {
    assert(add_ints(-1, 1) == 0);
    assert(add_ints(-5, -3) == -8);
}

static void test_add_overflow_safe(void) {
    assert(add_ints(INT_MAX, 0) == INT_MAX);
    assert(add_ints(INT_MIN, 0) == INT_MIN);
}

int main(void) {
    test_add_positive();
    test_add_negative();
    test_add_overflow_safe();
    puts("tests: ok");
    return 0;
}
