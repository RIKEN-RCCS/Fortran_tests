#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_show(CFI_cdesc_t *a) {
  printf("is_contiguous=%d\n", CFI_is_contiguous(a));
  printf("values");
  for (CFI_index_t i = 0; i < a->dim[0].extent; i++) {
    CFI_index_t sub[1] = {a->dim[0].lower_bound + i};
    printf(" %d", *(int *)CFI_address(a, sub));
  }
  printf("\n");
  fflush(stdout);
}
