#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_setpointer_char(CFI_cdesc_t *p, CFI_cdesc_t *q) {
  int rc = CFI_setpointer(p, q, NULL);
  printf("CFI_setpointer rc=%d elem_len=%ld\n", rc, (long)p->elem_len);
  fflush(stdout);
}
