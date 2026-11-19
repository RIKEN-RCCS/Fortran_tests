#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_address_size1(CFI_cdesc_t *a) {
  printf("rank1: rank=%d values", (int)a->rank);
  for (CFI_index_t i = 0; i < 5; i++) {
    CFI_index_t sub[1] = {a->dim[0].lower_bound + i};
    printf(" %d", *(int *)CFI_address(a, sub));
  }
  printf("\n");
  fflush(stdout);
}

void c_address_size2(CFI_cdesc_t *b) {
  printf("rank2: rank=%d values", (int)b->rank);
  for (CFI_index_t j = 0; j < 3; j++)
    for (CFI_index_t i = 0; i < 2; i++) {
      CFI_index_t sub[2] = {b->dim[0].lower_bound + i, b->dim[1].lower_bound + j};
      printf(" %d", *(int *)CFI_address(b, sub));
    }
  printf("\n");
  fflush(stdout);
}
