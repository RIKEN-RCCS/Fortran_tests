#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <ISO_Fortran_binding.h>

static int is_int_kind_code(CFI_type_t type) {
  static const struct {
    CFI_type_t code;
    size_t size;
  } codes[] = {
      {CFI_type_signed_char, sizeof(signed char)},
      {CFI_type_short, sizeof(short)},
      {CFI_type_int, sizeof(int)},
      {CFI_type_long, sizeof(long)},
      {CFI_type_long_long, sizeof(long long)},
      {CFI_type_size_t, sizeof(size_t)},
      {CFI_type_int8_t, sizeof(int8_t)},
      {CFI_type_int16_t, sizeof(int16_t)},
      {CFI_type_int32_t, sizeof(int32_t)},
      {CFI_type_int64_t, sizeof(int64_t)},
      {CFI_type_int_least8_t, sizeof(int_least8_t)},
      {CFI_type_int_least16_t, sizeof(int_least16_t)},
      {CFI_type_int_least32_t, sizeof(int_least32_t)},
      {CFI_type_int_least64_t, sizeof(int_least64_t)},
      {CFI_type_int_fast8_t, sizeof(int_fast8_t)},
      {CFI_type_int_fast16_t, sizeof(int_fast16_t)},
      {CFI_type_int_fast32_t, sizeof(int_fast32_t)},
      {CFI_type_int_fast64_t, sizeof(int_fast64_t)},
      {CFI_type_intmax_t, sizeof(intmax_t)},
      {CFI_type_intptr_t, sizeof(intptr_t)},
      {CFI_type_ptrdiff_t, sizeof(ptrdiff_t)},
  };
  for (size_t i = 0; i < sizeof codes / sizeof codes[0]; i++)
    if (codes[i].code > 0 && codes[i].code == type &&
        codes[i].size == sizeof(int))
      return 1;
  return 0;
}

void c_show_shape(CFI_cdesc_t *x) {
  printf("shape: type_ok=%d v(1)=%.1f\n", x->type == CFI_type_double,
         *(double *)x->base_addr);
  fflush(stdout);
}

void c_show_rank(CFI_cdesc_t *x) {
  printf("rank: rank=%d type_ok=%d first=%d\n", (int)x->rank,
         is_int_kind_code(x->type), *(int *)x->base_addr);
  fflush(stdout);
}
