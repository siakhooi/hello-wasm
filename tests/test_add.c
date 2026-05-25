#include <limits.h>

#include "add.h"
#include "unity.h"

void setUp(void) {}

void tearDown(void) {}

void test_add_positive(void) {
    TEST_ASSERT_EQUAL_INT(5, add_ints(2, 3));
    TEST_ASSERT_EQUAL_INT(0, add_ints(0, 0));
}

void test_add_negative(void) {
    TEST_ASSERT_EQUAL_INT(0, add_ints(-1, 1));
    TEST_ASSERT_EQUAL_INT(-8, add_ints(-5, -3));
}

void test_add_overflow_safe(void) {
    TEST_ASSERT_EQUAL_INT(INT_MAX, add_ints(INT_MAX, 0));
    TEST_ASSERT_EQUAL_INT(INT_MIN, add_ints(INT_MIN, 0));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_add_positive);
    RUN_TEST(test_add_negative);
    RUN_TEST(test_add_overflow_safe);
    return UNITY_END();
}
