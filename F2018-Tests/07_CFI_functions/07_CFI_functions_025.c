#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_allocate_deallocate(CFI_cdesc_t *p) {
  CFI_index_t lower[1] = {1}, upper[1] = {3};
  int rc = CFI_allocate(p, lower, upper, 0);
  printf("CFI_allocate rc=%d base_addr_null=%d\n", rc, p->base_addr == NULL);
  fflush(stdout);
  rc = CFI_deallocate(p);
  printf("CFI_deallocate rc=%d base_addr_null=%d\n", rc, p->base_addr == NULL);
  fflush(stdout);
}

void c_deallocate(CFI_cdesc_t *p) {
  int rc = CFI_deallocate(p);
  printf("CFI_deallocate rc=%d base_addr_null=%d\n", rc, p->base_addr == NULL);
  fflush(stdout);
}
