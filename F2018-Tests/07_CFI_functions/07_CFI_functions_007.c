#include <stdio.h>
#include <string.h>
#include <ISO_Fortran_binding.h>

void c_allocate_pointer(CFI_cdesc_t *p) {
  CFI_index_t lower[2] = {1, 0}, upper[2] = {3, 2};
  int rc = CFI_allocate(p, lower, upper, 0);
  printf("pointer CFI_allocate rc=%d\n", rc);
  fflush(stdout);
}

void c_allocate_char(CFI_cdesc_t *s) {
  int rc = CFI_allocate(s, NULL, NULL, 7);
  printf("char CFI_allocate rc=%d elem_len=%ld\n", rc, (long)s->elem_len);
  fflush(stdout);
  if (rc == CFI_SUCCESS) memcpy(s->base_addr, "abcdefg", 7);
}
