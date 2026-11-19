#include <stdio.h>
#include <ISO_Fortran_binding.h>

static int *saved;

void c_save(CFI_cdesc_t *x) {
  saved = (int *)x->base_addr;
  printf("c_save base_addr_null=%d\n", saved == NULL);
  fflush(stdout);
}

void c_use_saved(void) {
  printf("saved a=");
  for (int i = 0; i < 3; i++) {
    printf(" %d", saved[i]);
  }
  printf("\n");
  saved[1] = 99;
  fflush(stdout);
}
