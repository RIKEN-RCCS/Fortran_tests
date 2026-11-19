#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_associate(CFI_cdesc_t *p, CFI_cdesc_t *src) {
  int rc = CFI_setpointer(p, src, NULL);
  printf("CFI_setpointer rc=%d\n", rc);
  fflush(stdout);
}
