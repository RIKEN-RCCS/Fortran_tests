#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_section_pointer(CFI_cdesc_t *p, CFI_cdesc_t *a) {
  CFI_index_t lb[1] = {a->dim[0].lower_bound + 1};
  CFI_index_t ub[1] = {a->dim[0].lower_bound + 5};
  CFI_index_t st[1] = {2};
  int rc = CFI_section(p, a, lb, ub, st);
  printf("section into pointer: rc=%d\n", rc);
  fflush(stdout);
}
