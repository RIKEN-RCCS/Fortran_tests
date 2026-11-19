#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_use_then_free(CFI_cdesc_t *a) {
  printf("CFI_address a=");
  for (CFI_index_t i = 0; i < a->dim[0].extent; i++) {
    CFI_index_t sub[1] = {a->dim[0].lower_bound + i};
    printf(" %d", *(int *)CFI_address(a, sub));
  }
  printf("\n");
  int rc = CFI_deallocate(a);
  printf("CFI_deallocate rc=%d base_addr_null=%d\n", rc, a->base_addr == NULL);
  fflush(stdout);
}
