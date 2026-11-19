#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_allocate(CFI_cdesc_t *a) {
  CFI_index_t lower[1] = {2}, upper[1] = {5};
  int rc = CFI_allocate(a, lower, upper, 0);
  printf("CFI_allocate rc=%d\n", rc);
  fflush(stdout);
  if (rc == CFI_SUCCESS)
    for (CFI_index_t i = 2; i <= 5; i++) {
      CFI_index_t sub[1] = {i};
      *(int *)CFI_address(a, sub) = (int)(10 * (i - 1));
    }
}

void c_deallocate(CFI_cdesc_t *a) {
  int rc = CFI_deallocate(a);
  printf("CFI_deallocate rc=%d base_addr_null=%d\n", rc, a->base_addr == NULL);
  fflush(stdout);
}
