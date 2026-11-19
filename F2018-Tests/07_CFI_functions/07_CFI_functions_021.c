#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_setpointer_unassociated(CFI_cdesc_t *p, CFI_cdesc_t *q) {
  int rc = CFI_setpointer(p, q, NULL);
  printf("unassociated source: rc=%d\n", rc);
  fflush(stdout);
}
