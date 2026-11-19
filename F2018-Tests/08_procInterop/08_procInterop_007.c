#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_show(CFI_cdesc_t *s);

static char text[4] = {'w', 'x', 'y', 'z'};

void c_call(void) {
  CFI_CDESC_T(0) d;
  CFI_cdesc_t *s = (CFI_cdesc_t *)&d;
  CFI_establish(s, text, CFI_attribute_other, CFI_type_char, 4, 0, NULL);
  f_show(s);
}
