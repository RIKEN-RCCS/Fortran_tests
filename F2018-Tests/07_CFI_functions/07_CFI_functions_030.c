#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_setpointer_scalar(CFI_cdesc_t *p, CFI_cdesc_t *q) {
  CFI_index_t lower_bounds[1] = {5};
  int rc = CFI_setpointer(p, q, lower_bounds);
  printf("CFI_setpointer rc=%d\n", rc);
  fflush(stdout);
}
