#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_setpointer_rank2(CFI_cdesc_t *p, CFI_cdesc_t *q) {
  CFI_index_t lower_bounds[2] = {-1, 5};
  int rc = CFI_setpointer(p, q, lower_bounds);
  printf("rank 2 source: rc=%d\n", rc);
  fflush(stdout);
}
