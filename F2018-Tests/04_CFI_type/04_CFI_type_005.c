/* Companion for No.4 005 only: every CFI_type_* macro is defined as a
 * macro and expands to an integer constant expression. Constancy is
 * checked by using each macro as an enumerator initializer (a compile
 * error otherwise); #if value evaluation is not used because a valid
 * definition may contain sizeof. Kept out of 04_CFI_type.c so that such a
 * compile error fails only 005. */

#include <stdio.h>
#include <ISO_Fortran_binding.h>

#if defined(CFI_type_signed_char) && defined(CFI_type_short) \
 && defined(CFI_type_int) && defined(CFI_type_long) \
 && defined(CFI_type_long_long) && defined(CFI_type_size_t) \
 && defined(CFI_type_int8_t) && defined(CFI_type_int16_t) \
 && defined(CFI_type_int32_t) && defined(CFI_type_int64_t) \
 && defined(CFI_type_int_least8_t) && defined(CFI_type_int_least16_t) \
 && defined(CFI_type_int_least32_t) && defined(CFI_type_int_least64_t) \
 && defined(CFI_type_int_fast8_t) && defined(CFI_type_int_fast16_t) \
 && defined(CFI_type_int_fast32_t) && defined(CFI_type_int_fast64_t) \
 && defined(CFI_type_intmax_t) && defined(CFI_type_intptr_t) \
 && defined(CFI_type_ptrdiff_t) \
 && defined(CFI_type_float) && defined(CFI_type_double) \
 && defined(CFI_type_long_double) \
 && defined(CFI_type_float_Complex) && defined(CFI_type_double_Complex) \
 && defined(CFI_type_long_double_Complex) \
 && defined(CFI_type_Bool) && defined(CFI_type_char) \
 && defined(CFI_type_cptr) && defined(CFI_type_struct) \
 && defined(CFI_type_other)
# define MACROS_DEFINED 1
#else
# define MACROS_DEFINED 0
#endif

#if MACROS_DEFINED
enum {
    K_signed_char = CFI_type_signed_char, K_short = CFI_type_short,
    K_int = CFI_type_int, K_long = CFI_type_long,
    K_long_long = CFI_type_long_long, K_size_t = CFI_type_size_t,
    K_int8_t = CFI_type_int8_t, K_int16_t = CFI_type_int16_t,
    K_int32_t = CFI_type_int32_t, K_int64_t = CFI_type_int64_t,
    K_int_least8_t = CFI_type_int_least8_t, K_int_least16_t = CFI_type_int_least16_t,
    K_int_least32_t = CFI_type_int_least32_t, K_int_least64_t = CFI_type_int_least64_t,
    K_int_fast8_t = CFI_type_int_fast8_t, K_int_fast16_t = CFI_type_int_fast16_t,
    K_int_fast32_t = CFI_type_int_fast32_t, K_int_fast64_t = CFI_type_int_fast64_t,
    K_intmax_t = CFI_type_intmax_t, K_intptr_t = CFI_type_intptr_t,
    K_ptrdiff_t = CFI_type_ptrdiff_t,
    K_float = CFI_type_float, K_double = CFI_type_double,
    K_long_double = CFI_type_long_double,
    K_float_Complex = CFI_type_float_Complex, K_double_Complex = CFI_type_double_Complex,
    K_long_double_Complex = CFI_type_long_double_Complex,
    K_Bool = CFI_type_Bool, K_char = CFI_type_char,
    K_cptr = CFI_type_cptr, K_struct = CFI_type_struct,
    K_other = CFI_type_other
};
#endif

void macros_are_constants(void) {
    printf("macros_defined: %s\n", MACROS_DEFINED ? "yes" : "no");
    printf("integer_constant_expressions: %s\n", MACROS_DEFINED ? "yes" : "no");
}
