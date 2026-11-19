#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_recv(CFI_cdesc_t *x);

void c_relay(CFI_cdesc_t *x) {
  printf("relay type_other=%d rank=%d\n", x->type == CFI_type_other, (int)x->rank);
  fflush(stdout);
  f_recv(x);
}
