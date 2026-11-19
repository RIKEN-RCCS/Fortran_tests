#include <stdio.h>
#include <ISO_Fortran_binding.h>

static char buf[12];

void c_establish_type_other(void) {
  CFI_CDESC_T(0) d;
  CFI_cdesc_t *s = (CFI_cdesc_t *)&d;
  int rc = CFI_establish(s, buf, CFI_attribute_other, CFI_type_other, 12, 0, NULL);
  printf("type other: rc=%d elem_len=%ld type_ok=%d\n", rc, (long)s->elem_len,
         s->type == CFI_type_other);
  fflush(stdout);
}
